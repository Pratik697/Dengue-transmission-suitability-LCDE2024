#Program to calculate percent change in baseline decade with recent decade for long data

# Load the required libraries
#Program to calculate the percent change in total Europe data for albopictus

# Install the 'eurostat' package if not already installed
# Remeber to convert comma values in dataset to decimal values.
# Remeber to convert comma values in dataset to decimal values.
#install.packages("eurostat")
library('sf')
# Load the 'eurostat' library
library(eurostat)
library(dplyr)
library(cowplot)
library(gridExtra)
library(ggplot2)
library(dplyr)
library(tidyr)

#importing the required data


setwd("/Users/pratik/Desktop/NEWDATA/Revised_Submission_on_12_Sept")

Total_eu_data <- read.csv("Annual_R0_by_Total_Europe_1951_2022-Table.csv")

# first 10 years compared with last 10 years

Base <- mean(as.numeric(Total_eu_data[2,3:12]))

Rcnt_decade <- mean(as.numeric(Total_eu_data[2,65:74]))

change_total<- (Rcnt_decade-Base)/Base
pcnt_change_total<- change_total*100
pcnt_change_total
