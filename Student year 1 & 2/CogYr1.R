# Description ----
# This script is created to combine all questionnaire and cognitive tasks results
# of first year and second year data collection.
# CHAN, Man Fung Morris 15-8-2021

# Basic setups ----
rm( list =  ls())
gc()
library( dplyr)
library( readxl)

# Please change the directory to the one containing the Raw.csv file first
setwd( 'C:\\Users\\morris\\Desktop\\Mitacs\\Data\\20210815')

ans.std = read.csv( 'ans_stroop_std.csv')
ans.std = ans.std$ans
ans.emotif = read.csv( 'ans_stroop_emotif.csv')
ans.emotif = ans.emotif$ans

df <- read.csv( 'Raw_student_year1.csv', header = 1, na.strings = (''))

# Data importation ----
# Get the relevant columns and remove df to save memory
Date = df$endDate
Participant_code = df$QID65_TEXT
Notes = vector( mode = "character", length= nrow(df))
# Basic infos

df.std <- df %>% select( matches( 'QID605_PAGE_SUBMIT|QID606'))
# 'QID605_PAGE_SUBMIT' corresponds to response time in standard trials
# 'Q69' corresponds to the response

df.emotif <- df %>% select( matches( 'QID607_PAGE_SUBMIT|QID608'))
# 'QID607_PAGE_SUBMIT' corresponds to response time in emotive trials
# 'QID608' corresponds to the response

df.syllogisms = df[ , 1674:1701]
ans.syllogisms = read.csv( 'ans_y1_syllogisms.csv')
ans.syllogisms = ans.syllogisms$ans

df.association <- df[ , 1702:1719]

df.raven <- df[ , 1720:1731]

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
output.std = stroop_func(df.std, ans.std)
output.emotif = stroop_func(df.emotif, ans.emotif)

std.name = paste( colnames( output.std), '_std', sep = '')
emotif.name = paste( colnames( output.emotif), '_emotif', sep = '')

names( output.std) = std.name
names( output.emotif) = emotif.name

output.std = cbind( df.info, output.std)
output.emotif = cbind( df.info, output.emotif)

# ...Raven ----
df.raven <- add_column.func( df.raven, every = 1)
df.raven <- header_append.func( df.raven, 'R')

ans.raven = c( 8, 2, 3, 8, 7, 4, 5, 1, 7, 6, 1, 2)
for ( i in 1:12){
  df.raven[[ sprintf( 'R.%dscore', i)]][df.raven[[ sprintf( 'R.%dresp', i)]] == ans.raven[i]] = 1;
  df.raven[[ sprintf( 'R.%dscore', i)]][df.raven[[ sprintf( 'R.%dresp', i)]] != ans.raven[i]] = 0;
}

df.raven_acc = df.raven[ , sprintf( 'R.%dscore', seq( 1:12))]

df.raven$RavenTotalScore = rowSums( df.raven_acc)

#...Syllogisms ----
df.syllogisms <- add_column.func( df.syllogisms, every = 1)
df.syllogisms <- header_append.func( df.syllogisms, 'S')

for ( i in 1:28){
  df.syllogisms[[ sprintf( 'S.%dscore', i)]][df.syllogisms[[ sprintf( 'S.%dresp', i)]] == ans.syllogisms[i]] = 1;
  df.syllogisms[[ sprintf( 'S.%dscore', i)]][df.syllogisms[[ sprintf( 'S.%dresp', i)]] != ans.syllogisms[i]] = 0;
}

df.syllogisms_acc = df.syllogisms[ , sprintf( 'S.%dscore', seq( 1:28))]

df.syllogisms$SyllogismsTotalScore = rowSums( df.syllogisms_acc)

# ...Association ----
df.association <- add_column.func( df.association, every = 1)

df.association <- header_append.func( df.association, 'A')

df.association[ is.na( df.association)] <- ''

# ...File creation
maindir <- getwd()
dir.create( file.path( maindir, 'Output'), showWarnings = FALSE)
outputdir <- file.path( maindir, 'Output')
setwd( outputdir)

output.combined = cbind( df.info, output.std[ , c( 'TotalScore_std', 'meanRT_std', 'meanCorrectRT_std')], 
                         output.emotif[ , c( 'TotalScore_emotif', 'meanRT_emotif', 'meanCorrectRT_emotif')],
                         df.raven$RavenTotalScore, df.syllogisms$SyllogismsTotalScore)

output.combined <- sapply( output.combined, as.character)
write.csv( output.combined, 'Cognitive_Tasks_combined_yr1.csv', row.names = FALSE)

output.std[ is.na( output.std)] <- ''
output.emotif[ is.na( output.emotif)] <- ''

write.csv( output.std, 'yr1_Stroop_std.csv')
write.csv( output.emotif, 'yr1_Stroop_emotif.csv')

write.csv( df.association, 'yr1_Association_cleaned.csv')
write.csv( df.raven, 'yr1_Raven_cleaned.csv')
write.csv( df.syllogisms,'yr1_Syllogisms_cleaned.csv')
