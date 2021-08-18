# Description ----
# This script is created to extract digit span task data.
# CHAN, Man Fung Morris 2-8-2021

# Basic setups ----
rm( list =  ls())
gc()
library( dplyr)
library( readxl)

# Please change the directory to the one containing the Raw.csv file first
setwd( 'C:/Users/morris/Desktop/Mitacs/Data/20210817')

# Data importation ----

df <- read.csv( 'Raw_digitspan_year2.csv', header = 1, na.strings = (''), check.names = FALSE)
df <- df[ -1, ]

# Get the relevant columns and remove df to save memory
Date = df$EndDate
Participant_code = df$Q175
Notes = vector( mode = "character", length= nrow(df))
# Basic infos

df.forward <- df[ , c( 43, 68, 97, 126, 159, 192, 229, 266, 307, 348)]


df.backward <- df[ , c( 365, 382, 403, 424, 449, 474, 503,
                        532, 565, 598, 635, 672, 713, 754)]


ans <- read.csv( 'ans_y2_empan.csv')
ans.forward <- ans$ans_fw
ans.forward <- ans.forward[ !is.na( ans.forward)]
ans.backward <- ans$ans_bw


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

df.forward$Empan_fw <- func.score( df.forward, ans.forward)
df.backward$Empan_bw <- func.score( df.backward, ans.backward)

df.info <- data.frame( Date, Participant_code, Notes)


# File Creation ----
maindir <- getwd()
dir.create( file.path( maindir, 'Output'), showWarnings = FALSE)
outputdir <- file.path( maindir, 'Output')
setwd( outputdir)


df.combined <- cbind( df.info, df.forward$Empan_fw, df.backward$Empan_bw)
df.combined[ is.na( df.combined)] <- ''
write.csv( df.combined, 'yr2_DigitSpan.csv', row.names = FALSE)