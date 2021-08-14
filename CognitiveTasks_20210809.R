# Description ----
# This script is created to extract results of cognitive tasks.
# CHAN, Man Fung Morris 2-8-2021

# Basic setups ----
rm( list =  ls())
gc()
library( dplyr)
library( readxl)

# Please change the directory to the one containing the Raw.csv file first
setwd( 'C:\\Users\\morris\\Desktop\\mitacs\\Data\\Nurse\\Nurse_20210809')

ans_standard = read_xlsx( 'Stroop.xlsx', sheet = 1, col_names = FALSE)
ans_emotif = read_xlsx( 'Stroop.xlsx', sheet = 2)
df <- read.csv( 'Raw_nurse_20210806.csv', header = 1, na.strings = (''))
df <- df[ -c(1:2), ]

# Data importation ----
# Get the relevant columns and remove df to save memory
Date = df$EndDate
Consent = df$Q9
Participant_code = df$Q13
Notes = vector( mode = "character", length= nrow(df))
# Basic infos

df.practice <- df %>% select( matches( 'Q67_Page.Submit|Q69'))
# 'Q67_Page.Submit' corresponds to response time in practice trials
# 'Q69' corresponds to the response

df.emotif <- df %>% select( matches( 'Q48_Page.Submit|Q50'))
# 'Q48_Page.Submit' corresponds to response time in practice trials
# 'Q50' corresponds to the response

ans_practice = c( 1, 2, 2, 1, 1, 1, 1)

ans_standard = ans_standard$...4
ans_standard = as.numeric( factor( ans_standard, c( 'rouge', 'jaune', 'vert', 'bleu')))
ans_standard = replace( ans_standard, ans_standard == 2, 1)
ans_standard = replace( ans_standard, ans_standard == 3 | ans_standard == 4, 2)

ans_emotif = ans_emotif$...4
ans_emotif = as.numeric( factor( ans_emotif, c( 'rouge', 'jaune', 'vert', 'bleu')))
ans_emotif = replace( ans_emotif, ans_emotif == 2, 1)
ans_emotif = replace( ans_emotif, ans_emotif == 3 | ans_emotif == 4, 2)

df.association <- df %>% select( matches( 'Q54'))
df.raven <- df[,230:241]

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
  name_seq = c( 'ans', 'Score')
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
df.info = data.frame( Date, Consent, Participant_code, Notes)

# ...Stroop ----
output.prac = stroop_func(df.practice, ans_practice)
output.emotif = stroop_func(df.emotif, ans_emotif)

practice.name = paste( colnames( output.prac), '_prac', sep = '')
emotif.name = paste( colnames( output.emotif), '_emotif', sep = '')

names( output.prac) = practice.name
names( output.emotif) = emotif.name

output.prac = cbind( df.info, output.prac)
output.emotif = cbind( df.info, output.emotif)

# ...Raven ----
df.raven <- add_column.func( df.raven, every = 1)
df.raven <- header_append.func( df.raven, 'R')

ans.raven = c( 8, 2, 3, 8, 7, 4, 5, 1, 7, 6, 1, 2)
for ( i in 1:12){
  df.raven[[ sprintf( 'R.%dScore', i)]][df.raven[[ sprintf( 'R.%dans', i)]] == ans.raven[i]] = 1;
  df.raven[[ sprintf( 'R.%dScore', i)]][df.raven[[ sprintf( 'R.%dans', i)]] != ans.raven[i]] = 0;
}

df.raven_acc = df.raven[ , sprintf( 'R.%dScore', seq( 1:12))]

df.raven$RavenTotalScore = rowSums( df.raven_acc)

write.csv( df.raven, 'Raven_cleaned.csv')

# ...Association ----
df.association <- add_column.func( df.association, every = 1)

df.association <- header_append.func( df.association, 'A')

# ...File creation
maindir <- getwd()
dir.create( file.path( maindir, 'Output'), showWarnings = FALSE)
outputdir <- file.path( maindir, 'Output')
setwd( outputdir)

output.combined = cbind( df.info, output.prac[ , c( 'TotalScore_prac', 'meanRT_prac', 'meanCorrectRT_prac')], 
                         output.emotif[ , c( 'TotalScore_emotif', 'meanRT_emotif', 'meanCorrectRT_emotif')],
                         df.raven[ , c('RavenTotalScore')])

colnames( output.combined)[11] <- 'RavenTotalScore'
output.combined <- sapply( output.combined, as.character)
write.csv( output.combined, 'Cognitive_Tasks_combined.csv', row.names = FALSE)

output.prac[ is.na( output.prac)] <- ''
output.emotif[ is.na( output.emotif)] <- ''

write.csv( output.prac, 'Stroop_practice.csv')
write.csv( output.emotif, 'Stroop_emotif.csv')

df.association[ is.na( df.association)] <- ''
write.csv( df.association, 'Association.csv')