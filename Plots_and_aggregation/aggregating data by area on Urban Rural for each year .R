# Code for extracting spatial aggregate data for Urban Rural topology for each year in different columns.


#aggregation by area means aggregating by area considers the transmission  suitability of dengue in a 
#geographic area as a whole, without giving more weight to densely populated regions. 

#Aggregating by population as weightage focuses on assessing the transmission suitability of dengue per human in a specific area.
#It takes into account the population density and aims to understand the risk and impact of transmission on 
#the human population.


# Install the 'eurostat' package if not already installed
# Remeber to convert comma values in dataset to decimal values.
# Remeber to convert comma values in dataset to decimal values.
#install.packages("eurostat")
library('sf')
# Load the 'eurostat' library
library(eurostat)
library(dplyr)
library(dplyr)
library(cowplot)
library(gridExtra)
library(ggplot2)
library(dplyr)
library(tidyr)
#importing shapefile and data
setwd("/Users/pratik/Desktop/NEWDATA/Plots_code")
SHP_2_3035 <- read_sf("NUTS_RG_01M_2021_3035_LEVL_3.shp")
setwd("/Users/pratik/Desktop/NEWDATA/Annual_R0_by_NUTS2_Country_NUTS_ID_CSV_FILE")
edat_lfse_04 <- read.csv("Annual_R0_by_NUTS3_1951_2022-Table.csv", sep = ";")



# Specify the years for filtering
years <- c("X1951", "X1952", "X1953", "X1954", "X1955", "X1956", "X1957", "X1958", "X1959", "X1960",
           "X1961", "X1962", "X1963", "X1964", "X1965", "X1966", "X1967", "X1968", "X1969", "X1970",
           "X1971", "X1972", "X1973", "X1974", "X1975", "X1976", "X1977", "X1978", "X1979", "X1980",
           "X1981", "X1982", "X1983", "X1984", "X1985", "X1986", "X1987", "X1988", "X1989", "X1990",
           "X1991", "X1992", "X1993", "X1994", "X1995", "X1996", "X1997", "X1998", "X1999", "X2000",
           "X2001", "X2002", "X2003", "X2004", "X2005", "X2006", "X2007", "X2008", "X2009", "X2010",
           "X2011", "X2012", "X2013", "X2014", "X2015", "X2016", "X2017", "X2018", "X2019", "X2020",
           "X2021", "X2022")  # Add more years as needed

# Create an empty data frame to store the results
normalized_data <- data.frame(URBN_TYPE = character(0), stringsAsFactors = FALSE)

# Iterate through each year
for (year in years) {
  # Filter the data for the specified year and specified disease in Arbo_disease column
  filtered_data <- edat_lfse_04[edat_lfse_04$Arbo_disease == "Dengue (albopictus)", c("NUTS_ID", "URBN_TYPE", year, "Arbo_disease")]
  # Join the filtered data with the shapefile by NUTS_ID
  joined_data <- merge(SHP_2_3035, filtered_data, by = "NUTS_ID", all.x = TRUE)
  
  # Calculate the area of each NUTS_ID region
  joined_data$Area <- st_area(joined_data)
  
  # Calculating weight * corresponding R0 value column
  joined_data$Weighted_R0 <- joined_data[[year]] * joined_data$Area
  
  # Calculate the sum of weighted_R0 for each URBN_TYPE
  aggregated_data <- aggregate(joined_data$Weighted_R0, by = list(joined_data$URBN_TYPE.x), FUN = sum, na.rm = TRUE)
  
  # Calculate the sum of area for each URBN_TYPE
  area_data <- aggregate(joined_data$Area, by = list(joined_data$URBN_TYPE.x), FUN = sum, na.rm = TRUE)
  
  # Merge the aggregated data with the area data based on URBN_TYPE
  aggregated_data <- merge(aggregated_data, area_data, by = "Group.1")
  
  # Calculate the normalized sum of weighted_R0 by dividing by the sum of area
  aggregated_data$Normalized_Sum <- aggregated_data$x.x / aggregated_data$x.y
  
  # Rename the columns in the aggregated data
  colnames(aggregated_data) <- c("URBN_TYPE", "Weighted_R0_Sum", "Area of Topology", year)
  
  #Remove the unit from the year column
  aggregated_data[[year]] <- gsub("\\s+\\[.*\\]", "", aggregated_data[[year]])
  
  # Remove rows with NA values
  aggregated_data <- na.omit(aggregated_data)
  
  # Merge the current year's data with the normalized_data data frame
  if (nrow(normalized_data) == 0) {
    normalized_data <- aggregated_data
  } else {
    normalized_data <- merge(normalized_data, aggregated_data[, c("URBN_TYPE", year)], by = "URBN_TYPE", all.x = TRUE)
  }
}

# Remove the temporary columns
normalized_data <- subset(normalized_data, select = -c(Weighted_R0_Sum))

# Print the normalized data
print(normalized_data)


# Specify the file path
file_path <- "R0_value_aggregated_by_Urban_Rural_topology1.csv"
# Write the normalized_data dataframe to a CSV file
write.csv(normalized_data, file = file_path, row.names = FALSE)

