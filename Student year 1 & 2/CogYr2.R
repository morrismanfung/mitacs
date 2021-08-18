# Description ----
# This script is created to combine all questionnaire and cognitive tasks results
# of second year data collection.
# CHAN, Man Fung Morris 17-8-2021

# Basic setups ----
library( dplyr)
rm( list =  ls())
gc()

# Please change the directory to the one containing the Raw.csv file first
setwd( 'C:\\Users\\morris\\Desktop\\Mitacs\\Data\\20210815')

ans.std = read.csv( 'ans_stroop_std.csv')
ans.std = ans.std$ans
ans.emotif = read.csv( 'ans_stroop_emotif.csv')
ans.emotif = ans.emotif$ans

df <- read.csv( 'Raw_student_year2.csv', header = 1, na.strings = (''))
df <- df[ -1, ]

# Data importation ----
# Get the relevant columns and remove df to save memory
Date = df$EndDate
Participant_code = df$Q9
Notes = vector( mode = "character", length= nrow(df))
# Basic infos

df.emotif <- df %>% select( matches( 'Q187_Page.Submit|Q188'))
# 'Q187_Page.Submit' corresponds to response time in emotive trials
# 'Q188' corresponds to the response


df.syllogisms = df %>% select( matches( 'Q184'))
ans.syllogisms = read.csv( 'ans_y2_syllogisms.csv')
ans.syllogisms = ans.syllogisms$ans_num

rm( df)
gc()

# Function ----
add_column.func <- function( df.input, every = 2){
  df.input_copy = df.input
  count_trial = ncol( df.input_copy)/every
  if (every == 1){
    index = seq( 1, 2*count_trial-1, by = 2)
  } else {
    index = seq( 2, ncol( df.input_copy), by = 2) + seq( 1, ncol( df.input_copy)/2) - 1
  }
  for (i in index) {
    df.input_copy <- as.data.frame( append( df.input_copy, list( emp = NA), i))
  }
  return( df.input_copy)
}

stroop_func <- function( df.raw, ans.raw){
  df_name = sub( '...', '', deparse( substitute( df.raw)))
  # Get the data frame name
  
  # ...Extract the data ----
  count_trial = ncol( df.raw)/2
  df.raw <- add_column.func( df.raw)
  
  name_seq = c( 'RT', 'Resp', 'Score')
  header = c()
  for (i in 1:count_trial){
    prefix = sprintf( 'Q.%d', i)
    new_header_seq = paste( prefix, name_seq, sep = '')
    header = c( header, new_header_seq)
  }
  # Create a list of names for the header
  
  names( df.raw) = header
  # Change the header's name
  
  for ( i in 1:count_trial){
    df.raw[[ sprintf( 'Q.%dScore', i)]][df.raw[[ sprintf( 'Q.%dResp', i)]] == ans.raw[i]] = 1;
    df.raw[[ sprintf( 'Q.%dScore', i)]][df.raw[[ sprintf( 'Q.%dResp', i)]] != ans.raw[i]] = 0;
  }
  # Adding the accuracy score
  
  df.raw <- sapply( df.raw, as.numeric)
  df.raw <- as.data.frame( df.raw)
  
  df.raw_acc = df.raw[ , sprintf( 'Q.%dScore', seq( 1:count_trial))]
  # Create a copy with only the accuracy score
  df.raw$TotalScore = rowSums( df.raw_acc, na.rm = TRUE)
  # Add the accuracy score
  
  df.raw_RT = df.raw[ , sprintf( 'Q.%dRT', seq( 1:count_trial))]
  # Create a copy the RT
  df.raw$meanRT = rowMeans( df.raw_RT, na.rm = TRUE)
  # Add the mean RT
  
  df.raw_RT[ df.raw_acc == 0] <- NA
  # remove the RT of the wrong trials
  df.raw$meanCorrectRT = rowMeans( df.raw_RT, na.rm = TRUE)
  # Add the mean RT of the correct trials
  
  return( df.raw)
}

header_append.func <- function( df.input, start_with){
  header = c()
  name_seq = c( 'resp', 'score')
  count_trial = ncol( df.input)/2
  for (i in 1:count_trial){
    prefix = sprintf( paste( start_with, '.%d', sep = ''), i)
    new_header_seq = paste( prefix, name_seq, sep = '')
    header = c( header, new_header_seq)
  }
  names( df.input) = header
  return( df.input)
}
# Cleaning ----

# ...Info ----
df.info = data.frame( Date, Participant_code, Notes)

# ...Stroop ----
output.emotif = stroop_func(df.emotif, ans.emotif)

emotif.name = paste( colnames( output.emotif), '_emotif', sep = '')

names( output.emotif) = emotif.name

output.emotif = cbind( df.info, output.emotif)

#...Syllogisms ----
df.syllogisms <- add_column.func( df.syllogisms, every = 1)
df.syllogisms <- header_append.func( df.syllogisms, 'S')

for ( i in 1:28){
  df.syllogisms[[ sprintf( 'S.%dscore', i)]][df.syllogisms[[ sprintf( 'S.%dresp', i)]] == ans.syllogisms[i]] = 1;
  df.syllogisms[[ sprintf( 'S.%dscore', i)]][df.syllogisms[[ sprintf( 'S.%dresp', i)]] != ans.syllogisms[i]] = 0;
}

df.syllogisms_acc = df.syllogisms[ , sprintf( 'S.%dscore', seq( 1:28))]

df.syllogisms$SyllogismsTotalScore = rowSums( df.syllogisms_acc)

# ...File creation
maindir <- getwd()
dir.create( file.path( maindir, 'Output'), showWarnings = FALSE)
outputdir <- file.path( maindir, 'Output')
setwd( outputdir)

output.combined = cbind( df.info,
                         output.emotif[ , c( 'TotalScore_emotif', 'meanRT_emotif', 'meanCorrectRT_emotif')],
                         df.syllogisms$SyllogismsTotalScore)

output.combined <- sapply( output.combined, as.character)
write.csv( output.combined, 'yr2_Cognitive_Tasks_combined.csv', row.names = FALSE)

output.emotif[ is.na( output.emotif)] <- ''

write.csv( output.emotif, 'yr2_Stroop_emotif.csv')

write.csv( df.syllogisms,'yr2_Syllogisms_cleaned.csv')
