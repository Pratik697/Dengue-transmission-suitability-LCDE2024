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

SHP_2_3035 <- read_sf("NUTS_RG_01M_2021_3035_LEVL_3.shp")
edat_lfse_04 <- read.csv("Annual_R0_by_NUTS3_1951_2022-Table.csv", sep = ";")


# Aggregate the data by URBN_TYPE across the entire NUTS_ID for the specified year
aggregated_data <- edat_lfse_04 %>%
  filter(Arbo_disease == 'Dengue (albopictus)') %>%
  group_by(URBN_TYPE) %>%
  summarise(
    Total_Count = n(),
    Mean_Value = mean(X1951)
  )

# Print the aggregated data
print(aggregated_data)

#plotting the data
edat_lfse_04_shp <- aggregated_data %>% 
  #filter(Arbo_disease == 'Dengue (albopictus)') %>%               # both males and females
  #filter(1951 == '') %>%       # level of education
  #  filter(age == 'Y25-34') %>%          # age between 25 and 34  
  #  filter(TIME_PERIOD == 2020) %>%             # during 2020
  select(URBN_TYPE, Mean_Value) %>% 
  right_join(SHP_2_3035, by = "URBN_TYPE") %>% 
  st_as_sf()

edat_lfse_04_shp %>% 
  ggplot(aes(fill = URBN_TYPE)) +
  geom_sf(
    size = 0.1, 
    color = "#333333"
  ) +
  scale_fill_distiller(
    palette = "YlGnBu",
    direction = 1, 
    name = "R0",
    breaks = c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1),
    labels = c("0", "0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1"),
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