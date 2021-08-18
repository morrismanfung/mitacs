
# DigitSpanExtraction
By Chan, Man Fung Morris 10-08-2021

# Content
- [Description](#description)
- [Input](#input)
- [Output](#output)
- [Basic setups](#basic-setups)
- [Details](#details)
- [Functions](#functions)

# Description

This script is written to extract the results of both forward and backward digit span from the .csv file exported from Qualtrics. Answers for the tasks are extracted from 2 .csv file (*ans_digitspan_forward.csv* & *ans_digitspan_backward.csv*. Answers are used to calculate the digit span of each participants. 

# Input
1. **Raw_digitspan.csv**
	- Original file was renamed to *Raw_Nurse.csv* for better processing.
2. **ans_digitspan_forward.csv**
	- A .csv file with stimulus of the foward trials.
3. **ans_digitspan_backward.csv**
	- A .csv file with stimulus of the backward trials.

# Output
The script will automatically creates a folder named *Output* in the working directory to save the outputs below.
1. **DigitSpan.csv**
   - A .csv file with the cleaned responses of the digit span task and the digit span for forward and backward trials respectively.
  

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

To minimize the chance of error, a long file name with French characters is not suggested to be used, especially in computers not in French, or with Chinese installed :) It is suggested to change the raw data file from Qualtrics to Raw_DigitSpan.csv.


## Directory

For simplicity, the script **does not** automatically set its directory as the working directory. Users must use the code,
```r
setwd( 'Put/Your/Directory/Here')
# OR setwd( 'Put\\Your\\Directory\\Here')
# Either use slash (/) or 2 backslashes (\\)
```
to change the working directory. The working directory must include the raw data file, named *Raw_digitspan.csv*, and the files with the answers.

A new folder, named *Output*, if not already exists, will be created in the working directory to store the output files.


# Details

> Detailed description of the script.

## Working Principle

## Data Extraction

The script is able to extract relevant columns (participants' responses) by specfiying the column names. This is the only way because commonality among the names of relevant columns is not found.

## Digit Span Calculation

Incorrect responses of each participants will first be removed from the data set, leaving the correct ones. The correct responses will be ordered by their length in decreasing order for each participant separately. Thus, each participants first response in the data frame will be the one 1) being correct & 2) being the longest. Individua digit span is extracted to counting the number of digit in that response.

## Functions

### func.sortbylength

This function is designed to sort a vector of characters by their length in a decreasing order. It is used in the function `func.score` for the response data frame,

```r
func.sortbylength <- function( x){
	...
	return( y)
}
```

It takes in a vector. A vector will be returned. In application, it is applied to every row of the data frames. Together with the `apply` function, a matrix will be generated. The matrix will be tranformed to a data frame for further processing.

### func.score
This function is designed to calculate digit span of each participants.
```r
func.score <- function( df.input, ans.input){
	...
	return( y)
}
```
It takes 2 inputs: a data frame with only the relevant digit span responses columns, and a list of correct answer, both prepared by the script before running the function. The dataframe is extracted from *Raw_digitspan.csv*. The answers are extracted from *ans_digitspan_forward.csv* and *ans_digitspan_backward.csv*. One vector will be returned for further processing. That is a vector containing digit span of each individuals, which will be concatenated to the cleaned response to produce the final output.

# Maintainer
Chan, Man Fung Morris, HKU


