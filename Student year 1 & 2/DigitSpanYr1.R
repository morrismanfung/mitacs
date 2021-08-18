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

df <- read.csv( 'Raw_digitspan_year1.csv', header = 1, na.strings = (''), check.names = FALSE)
df <- df[ -1, ]

# Get the relevant columns and remove df to save memory
Date = df$endDate
Participant_code = df$QID1187_TEXT
Notes = vector( mode = "character", length= nrow(df))
# Basic infos

df <- df %>% select( matches( 'TEXT'))
df <- df[ , -c(1, ncol( df))]

df.forward <- df[ , 1:30]
df.backward <- df[ , 31:72]

ans <- read.csv( 'ans_y1_empan.csv')
ans.forward <- ans$ans_fw
ans.forward <- ans.forward[ !is.na( ans.forward)]
ans.backward <- ans$ans_bw


rm( df)
gc()

# Formating ----

# Change the header name of forward trial data frame
name_seq = sprintf( '.%d_fw', seq( 1, 6))
header = c()
for (i in 5:9){
  prefix = sprintf( 'Q%d', i)
  new_header_seq = paste( prefix, name_seq, sep = '')
  header = c( header, new_header_seq)
}
names( df.forward) = header

# Change the header name of backward trial data frame
name_seq = sprintf( '.%d_bw', seq( 1, 6))
header = c()
for (i in 3:9){
  prefix = sprintf( 'Q%d', i)
  new_header_seq = paste( prefix, name_seq, sep = '')
  header = c( header, new_header_seq)
}
names( df.backward) = header

# Forward trials ----
df.input <- df.forward
ans.input <- ans.forward
df.process <- df.input
df.ans <- data.frame( t( replicate( nrow( df.process), ans.input)))
df.compare <- df.ans == df.process
df.process[ !df.compare] <- ''
df.nchar <- data.frame( sapply( df.process, nchar))
df.output <- data.frame( seq(1:nrow( df.process)))
df.output$n5 <- rowSums( df.nchar[ , 1:6])/5
df.output$n6 <- rowSums( df.nchar[ , 7:12])/6
df.output$n7 <- rowSums( df.nchar[ , 13:18])/7
df.output$n8 <- rowSums( df.nchar[ , 19:24])/8
df.output$n9 <- rowSums( df.nchar[ , 25:30])/9
df.output <- df.output[ , -1]
df.output[ df.output < 2] <- NA
df.output[ !is.na( df.output)] <- 1
df.output$Empan <- rowSums( df.output, na.rm = TRUE) + 4
df.output$Empan[ df.output$Empan < 5] <- ''
df.forward$Empan_fw <- df.output$Empan

# Backward trials ----
df.input <- df.backward
ans.input <- ans.backward
df.process <- df.input
df.ans <- data.frame( t( replicate( nrow( df.process), ans.input)))
df.compare <- df.ans == df.process
df.process[ !df.compare] <- ''
df.nchar <- data.frame( sapply( df.process, nchar))
df.output <- data.frame( seq(1:nrow( df.process)))
df.output$n3 <- rowSums( df.nchar[ , 1:6])/3
df.output$n4 <- rowSums( df.nchar[ , 7:12])/4
df.output$n5 <- rowSums( df.nchar[ , 13:18])/5
df.output$n6 <- rowSums( df.nchar[ , 19:24])/6
df.output$n7 <- rowSums( df.nchar[ , 25:30])/7
df.output$n8 <- rowSums( df.nchar[ , 31:36])/8
df.output$n9 <- rowSums( df.nchar[ , 37:42])/9
df.output <- df.output[ , -1]
df.output[ df.output < 2] <- NA
df.output[ !is.na( df.output)] <- 1
df.output$Empan <- rowSums( df.output, na.rm = TRUE) + 2
df.output$Empan[ df.output$Empan < 3] <- ''
df.backward$Empan_bw <- df.output$Empan



df.info <- data.frame( Date, Participant_code, Notes)


# File Creation ----
maindir <- getwd()
dir.create( file.path( maindir, 'Output'), showWarnings = FALSE)
outputdir <- file.path( maindir, 'Output')
setwd( outputdir)

df.combined <- cbind( df.info, df.forward$Empan_fw, df.backward$Empan_bw)
df.combined[ is.na( df.combined)] <- ''
write.csv( df.combined, 'yr1_DigitSpan.csv', row.names = FALSE)