# Description ----
# This script is created to extract digit span task data.
# CHAN, Man Fung Morris 9-8-2021

# Basic setups ----
rm( list =  ls())
gc()
library( dplyr)
library( readxl)

# Please change the directory to the one containing the Raw.csv file first
setwd( 'C:\\Users\\morris\\Desktop\\Mitacs\\Data\\Digitspan\\Digitspan_20210810')

# Data importation ----

df <- read.csv( 'Raw_digitspan.csv', header = 1, na.strings = (''), check.names = FALSE)
df <- df[ -c(1:2), ]

# Get the relevant columns and remove df to save memory
Date = df$EndDate
Participant_code = df$Q537
Notes = vector( mode = "character", length= nrow(df))
# Basic infos

df.forward <- df %>% select( matches( 'Empan'))
# All of the forward digit span results are in the columns with 'Empan' in the name

df.backward <- df[ , c( '1_Q721', '1_Q722', '1_Q727', '1_Q728', '1_Q733', 
                      '1_Q734', '1_Q943', '1_Q1725', '1_Q1038', '1_Q1818', '1_Q1145', '1_Q1926', '1_Q1265', '1_Q2046')]
# These are the columns with the backward digit span responses

ans.forward <- read.csv( 'ans_digitspan_forward.csv')
ans.forward <- ans.forward$stimulus
ans.forward <- sapply( ans.forward, as.character)
ans.backward <- read.csv( 'ans_digitspan_backward.csv')
ans.backward <- ans.backward$stimulus
ans.backward <- sapply( ans.backward, as.character)

rm( df)
gc()

# Formating ----

# Change the header name of forward trial data frame
name_seq = c( '.1_fw', '.2_fw')
header = c()
for (i in 5:9){
  prefix = sprintf( 'Q%d', i)
  new_header_seq = paste( prefix, name_seq, sep = '')
  header = c( header, new_header_seq)
}
names( df.forward) = header

# Change the header name of backward trial data frame
name_seq = c( '.1_bw', '.2_bw')
header = c()
for (i in 3:9){
  prefix = sprintf( 'Q%d', i)
  new_header_seq = paste( prefix, name_seq, sep = '')
  header = c( header, new_header_seq)
}
names( df.backward) = header


# Functions ----
func.sortbylength <- function( x){
  y = x[order( nchar(x), decreasing = TRUE, na.last = TRUE)]
  return( y)
}

func.score <- function( df.input, ans.input){
  df.process <- df.input
  df.ans <- data.frame( t( replicate( nrow( df.input), ans.input)))
  df.compare <- df.ans == df.input
  df.process[ !df.compare] <- ''
  df.test <- data.frame( t( apply( df.process, 1, func.sortbylength)))
  # Transpose (t) is needed because apply with return a "vector" of output,
  # which here each output is a vector, resulting in a matrix.
  y = nchar( df.test[ ,1])
  return( y)
}

# Answer Checking ----

df.forward$Score_forward <- func.score( df.forward, ans.forward)
df.backward$Score_backward <- func.score( df.backward, ans.backward)

df.info <- data.frame( Date, Participant_code, Notes)


# File Creation ----
maindir <- getwd()
dir.create( file.path( maindir, 'Output'), showWarnings = FALSE)
outputdir <- file.path( maindir, 'Output')
setwd( outputdir)


df.combined <- cbind( df.info, df.forward, df.backward)
df.combined[ is.na( df.combined)] <- ''
write.csv( df.combined, 'DigitSpan.csv', row.names = FALSE)