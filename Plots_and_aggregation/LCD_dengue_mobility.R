setwd("/Users/pratik/Desktop/NEWDATA/Revised_Submission_on_12_Sept")

library(ggplot2)
library(dplyr)
library(tidyverse)
library(readxl)

LCD_Sewe_Dengue1951_2021 <- read.csv("R0_data_by_EU_region_wise_csv.csv")

LCD_Henrik_Mobility1990_2021 <- read_excel("Dengue_mobility_data.xlsx")



LCD_figColors <- c("#EE3377","#33BBEE" , "#EE7733", "#009988", "#CC3311")


# a scaling factor is needed for the 2nd vertical axis (left y-axis)
# a general rule is to estiamte scaling factor is ~ max(right vertical )/max(left vertical axis)

 max_right_vertical_axis = LCD_Sewe_Dengue1951_2021%>%
  filter(Arbo_disease==  "Dengue (albopictus)" & Indicator=="R0" & EU_Region != "All Europe")%>%
   summarize(max= max(Value))
 
 max_left_vertical_axis= max(LCD_Henrik_Mobility1990_2021$ImportedCases) # replace imported cases by the corrsponding column in excel file. 
 
 scaling_factor=  max_left_vertical_axis/max_right_vertical_axis$max
   
 
#alpha1=1700 


LCD_dengue_fig <- 
  LCD_Sewe_Dengue1951_2021 %>%
  filter(Arbo_disease == "Dengue (albopictus)" & Indicator == "R0" & EU_Region != "All Europe") %>%
  ggplot(aes(year, Value, color = EU_Region)) +
  geom_line() +
  geom_smooth(
    method = lm,
    aes(
      year,
      Value,
      fill = EU_Region
    ),
    alpha = 0.1,
    se = FALSE,
    lty = 2,
    lwd = 0.5,
    show.legend = FALSE
  ) +
  geom_line(
    LCD_Henrik_Mobility1990_2021,
    mapping = aes(
      x = Year,
      y = ImportedCases / scaling_factor
    ),
    color = "black",
    size = 1,
    alpha = 0.8
  ) +
  theme_bw() +
  scale_x_continuous(
    breaks = c(seq(1950, 2020, 10)),
    expand = c(0, 0)  # Set expand to zero to remove gaps at both ends, if you remove this line then there will be a little gap at  both ends
  ) +
  xlab(" ") +
  ylab(expression("Dengue(Albopictus) - change in R"[0])) +
  scale_color_manual(
    labels = c("Eastern Europe", "Northern Europe", "Southern Europe", "Western Asia", "Western Europe"),
    values = c(LCD_figColors[1], LCD_figColors[2], LCD_figColors[3], LCD_figColors[5], LCD_figColors[4]),
    guide = "legend"
  ) +
  theme(
    strip.text = element_text(hjust = 0),
    legend.key = element_blank(),
    axis.line.x.top = element_line(colour = 'black', size = 0),
    legend.text.align = 0,
    panel.grid = element_blank(),
    legend.key.height = grid::unit(0.2, 'cm'),
    legend.position = "bottom",
    legend.direction = "horizontal",
    legend.title = element_blank(),
    axis.text = element_text(vjust = 0.5, size = 10),
    panel.border = element_blank(),
    axis.line.y.left = element_line(size = 0.1),
    axis.text.y.right = element_text(margin = margin(r = .3, unit = "cm"), size = 10),
    axis.line.x.bottom = element_line(size = 0.1),
    axis.line.y.right = element_line(size = 0.1),
    axis.ticks.y.right = element_line(color = "black"),
    axis.title.y.right = element_text(color = "black", size = 10)
  ) +
  scale_y_continuous(
    sec.axis = sec_axis(
      trans = ~.*scaling_factor,
      name = "Relative change (%) in imports of \n dengue cases to dengue suitable NUTS3 regions"
    )
  )

