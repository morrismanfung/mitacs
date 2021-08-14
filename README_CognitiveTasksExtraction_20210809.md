
# CognitiveTasksExtraction
By Chan, Man Fung Morris 09-08-2021

# Content
- [Description](#description)
- [Input](#input)
- [Output](#output)
- [Basic setups](#basic-setups)
- [Details](#details)
- [Functions](#functions)

# Description

This script is written to extract the results of cognitive tasks (emotional Stroop task, Association task and Raven's progressive matrices) from the .csv file exported from Qualtrics. Answers for the Stroop task are extracted from the .xlsx file Stroop.xlsx. Answers are used to calculate the accuracy score for the Stroop task and the reaction time for the trials with correct responses. Additional columns are added to table with Association task' and Raven's results for scoring.

# Input
1. **Raw_Nurse.csv**
	- Original file *CEėVEė+Anneėe+1+InfirmieĖres_21+juillet+
	2021_09.08 NUMERIQUE.csv* was renamed to *Raw_Nurse.csv* for better processing.
2. **Stroop.xlsx**
	- An .xlsx with two sheets containing the correct answer of the Stroop trials.

# Output
The script will automatically creates a folder named *Output* in the working directory to save the outputs below.
1. **Stroop_practice.csv**
   - A .csv file with the cleaned responses of the Stroop task practice trials.
2. **Stroop_emotif.csv**
	- A .csv file with the cleaned reponses of the Stroop task emotive trials.
3. **Raven_cleaned.csv**
	- A .csv file with the Raven's responses and total score.
4. **Association.csv**
	- A .csv file with the cleaned Association responses without for manual scoring.
5. **Cognitive_Tasks_combined.csv**
	- A .csv file with the participants' info, mean RT of the Stroop task and the Raven's score.
  

# Basic setups

> Basic setups before running the script.

## R and Rstudio installation

R and RStudio are required to run the script. They could be downloaded through the links below.

## Package requirement

`dplyr` and `readxl` were required for the script. Installation can be done by running the command below in the console, before running the script:
```r
install.packages( c( 'dplyr' ,'readxl'))
```
## Input file

To minimize the chance of error, a long file name with French characters is not suggested to be used, especially in computers not in French, or with Chinese installed :) It is suggested to change the raw data file from Qualtrics to Raw_Nurse.csv.


## Directory

For simplicity, the script **does not** automatically set its directory as the working directory. Users must use the code,
```r
setwd( 'Put/Your/Directory/Here')
```
to change the working directory. The working directory must include the raw data file, named *Raw.csv*, and the file with the Stroop answers.

A new folder, named *Output*, if not already exists, will be created in the working directory to store the output files.


# Details

> Detailed description of the script.

## Working Principle

The function in the script is able to extract relevant columns (Stroop’s, Association task’s and Raven’s results) by identifying columns with the common keywords in their names.


|Task |Column keywords|
|-----------|----------|
|Stroop task - practice trials| Q67_Page.Submit (RT) and Q69 (Response)|
|Stroop task - emotive trials| Q48_Page.Submit (RT) and Q50 (Response)|
|Association task| Q54
|Raven's progressive matrices| *The last 12 columns were selected as no common keywords are found in the columns with Raven data*|

  
  

## Functions

### add_column.func

This function is designed to add 1 column into a data frame for every 1 or 2 columns. It is a general function that is used for Association task’s and Raven’s result, and in the function `stroop_func` for the Stroop’s data.

```r
add_column.func <- function( df.input, every = 2){
	...
	return( df.input_copy)
}
```

It takes in a data frame and an argument `every` specifying the frequency of adding a new column. 1 data frame will be returned.

### stroop_func
This function is designed to calculate the mean reaction time (RT) and accuracy score of each participants.
```r
stroop_func <- function( df.raw, ans.raw){
	...
	write.csv( df.raw, filename)
	return( df.raw)
}
```
It takes 2 inputs: a data frame with only the relevant Stroop columns, and a list of correct answer, both prepared by the script before running the function. The dataframe is extracted from Raw.csv. The answers are extracted from Stroop.xlsx. A .csv with the data frame will be created. The data frame is also returned for further processing.

# Maintainer
Chan, Man Fung Morris, HKU
