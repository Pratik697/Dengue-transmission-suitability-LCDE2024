#Program to calculate percent change in baseline decade with recent decade for long data

# Load the required libraries
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
edat_lfse_04 <- read.csv("R0_data_by_EU_region_wise_csv.csv")


filtered_data <- edat_lfse_04 %>%
  filter(Arbo_disease == "Dengue (albopictus)" & EU_Region == "Southern Europe"& 
           year >= 1951 & year <= 1960) # we can remove year statement to get Value for all the years

filtered_data

baseline = mean(filtered_data[1:10,5])

filtered_data1 <- edat_lfse_04 %>%
  filter(Arbo_disease == "Dengue (albopictus)" & EU_Region == "Southern Europe"& 
           year >= 2013 & year <= 2022) # we can remove year statement to get Value for all the years

filtered_data1

Recent_decade <-mean(filtered_data1[1:10,5])

#relative change
#change<-(Recent_decade-baseline)/baseline

#absolute change 
change<-(Recent_decade-baseline)

pcnt_change<-change*100
pcnt_change


