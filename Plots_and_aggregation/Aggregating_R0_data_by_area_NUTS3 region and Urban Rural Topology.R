#code to aggregate value by adding weight to area of NUTS3 region for a particular year

#aggregation by area means ggregating by area considers the transmission  suitability of dengue in a 
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

#importing shapefile and data
setwd("/Users/pratik/Desktop/NEWDATA/Plots_code")
SHP_2_3035 <- read_sf("NUTS_RG_01M_2021_3035_LEVL_3.shp")
setwd("/Users/pratik/Desktop/NEWDATA/Annual_R0_by_NUTS2_Country_NUTS_ID_CSV_FILE")
edat_lfse_04 <- read.csv("Annual_R0_by_NUTS3_1951_2022-Table.csv", sep = ";")


# Specify the year for filtering
year <- "X2022"

# Filter the data for the specified year and specified disease in Arbo_disease column
filtered_data <- edat_lfse_04[edat_lfse_04$Arbo_disease == "Dengue (albopictus)", c("NUTS_ID", "URBN_TYPE", year, "Arbo_disease")]
# Join the filtered data with the shapefile by NUTS_ID
joined_data <- merge(SHP_2_3035, filtered_data, by = "NUTS_ID", all.x = TRUE)

# Calculate the area of each NUTS_ID region.  
joined_data$Area <- st_area(joined_data) # "SHP_2_3035$Area <- st_area(SHP_2_3035)" this code gives the corresponding area of each NUTS3 region

#Calculating weight * corresponding R0 value column
joined_data$Weighted_R0 <- joined_data$X2022 * joined_data$Area

# Calculate the sum of weighted_R0 for each URBN_TYPE, Note URBN_TYPE is now URBN_TYPE.x
aggregated_data <- aggregate(joined_data$Weighted_R0, by = list(joined_data$URBN_TYPE.x), FUN = sum, na.rm = TRUE)

# Calculate the sum of area for each URBN_TYPE, Note URBN_TYPE is now URBN_TYPE.x
area_data <- aggregate(joined_data$Area, by = list(joined_data$URBN_TYPE.x), FUN = sum, na.rm = TRUE)

# Merge the aggregated data with the area data based on URBN_TYPE i.e. it creats two columns holding the above two values
aggregated_data <- merge(aggregated_data, area_data, by = "Group.1")

# Calculate the normalized sum of weighted_R0 by dividing by the sum of area
aggregated_data$Normalized_Sum <- aggregated_data$x.x / aggregated_data$x.y

# Rename the columns in the aggregated data
colnames(aggregated_data) <- c("URBN_TYPE", "Weighted_R0_Sum", "Sum_Area", "Normalized_Sum")

# Remove rows with NA values
aggregated_data <- na.omit(aggregated_data)

# Print the aggregated data
print(aggregated_data)

# Remove units from the final aggregated data
aggregated_data$Weighted_R0_Sum <- gsub("\\[.*?\\]", "", aggregated_data$Weighted_R0_Sum)
aggregated_data$Sum_Area <- gsub("\\[.*?\\]", "", aggregated_data$Sum_Area)
aggregated_data$Normalized_Sum <- gsub("\\[.*?\\]", "", aggregated_data$Normalized_Sum)

# Print the aggregated data without units
print(aggregated_data)

#All the data in process of removal of units got converted to string , so converting again to numeric

aggregated_data$Sum_Area <- as.numeric(aggregated_data$Sum_Area)
aggregated_data$Weighted_R0_Sum <- as.numeric(aggregated_data$Weighted_R0_Sum)
aggregated_data$Normalized_Sum <- as.numeric(aggregated_data$Normalized_Sum)

# Now we have to plot normalized sum values to the shapefile of Urban rural

edat_lfse_04_shp <- aggregated_data %>% 
  #filter(Arbo_disease == 'Dengue (albopictus)') %>%               # both males and females
  #filter(1951 == '') %>%       # level of education
  #  filter(age == 'Y25-34') %>%          # age between 25 and 34  
  #  filter(TIME_PERIOD == 2020) %>%             # during 2020
  select(URBN_TYPE, Normalized_Sum) %>% 
  right_join(SHP_2_3035, by = "URBN_TYPE") %>% 
  st_as_sf()


edat_lfse_04_shp %>% 
  ggplot(aes(fill = Normalized_Sum)) +
  geom_sf(
    size = 0.1, 
    color = "#333333"
  ) +
  scale_fill_distiller(
    palette = "YlGnBu",
    direction = 1, 
    name = "R0",
    breaks = c(0.07131569, 0.08692564, 0.09281052),
    labels = c("0", "0.1", "0.2"),
    na.value = "gray80",
    guide = guide_colorbar(
      direction = "vertical", 
      title.position = "top", 
      label.position = "right",  
      barwidth = unit(0.4, "cm"), 
      barheight = unit(6, "cm"),  
      ticks = TRUE, 
    )
  ) + 
  scale_x_continuous(limits = c(2500000, 7000000)) +
  scale_y_continuous(limits = c(1600000, 5200000)) +
  labs(
    title = "Population by educational attainment level",
    subtitle = "ISCED 5-8, at least tertiary educational level during 2020",
    caption = "Data: Eurostat edat_lfse_04"
  ) +
  theme_void() +
  theme(legend.position = c(0.94, 0.70))
