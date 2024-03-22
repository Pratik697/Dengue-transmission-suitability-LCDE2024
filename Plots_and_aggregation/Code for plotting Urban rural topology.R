# Load the required libraries
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

setwd("/Users/pratik/Desktop/NEWDATA/Annual_R0_by_NUTS2_Country_NUTS_ID_CSV_FILE")
edat_lfse_04 <- read.csv("R0_value_aggregated_by_Urban_Rural_topology.csv", sep = ";")


# Reshape the data from wide to long format
df_long <- pivot_longer(edat_lfse_04, cols = starts_with("X"), names_to = "Year", values_to = "Value")

# Convert the Year column to numeric
df_long$Year <- as.numeric(gsub("X", "", df_long$Year))



#Plotting

#colour palatte
LCD_figColors <- c("darkblue", "#EE7733", "darkgreen")


#converting the data to numeric values
df_long$Year<- as.numeric(as.character(df_long$Year))

df_long$Value <- as.numeric(as.character(df_long$Value))
#alpha1=1700 

Urban_Rural_fig <- 
  df_long%>%
  #filter(Arbo_disease==  "Zika" & Indicator=="R0" & EU_Region != "All Europe")%>%
  ggplot(aes( Year ,
              Value, #
              color=as.factor(URBN_TYPE)))+
  geom_line()+
  geom_smooth(
    method=lm,
    aes(Year ,
        Value, #
        fill=as.factor(URBN_TYPE)
    ),
    alpha=0.1,  se = FALSE,
    lty=2,lwd=0.5, show.legend = FALSE
    
  )+
  # geom_line(LCD_Henrik_Mobility1990_2021, mapping= aes(x= x,
  #                                            y = y/scaling_factor
  # ), color = "black",size=1, alpha=0.8)+ #as.numeric(alpha) 1500
  theme_bw()+
  scale_x_continuous(breaks=c(seq(1950,2020,10))
  )+
  xlab(" ")+
  ylab(expression("Transmission suitability of Dengue - R"[0])) +
  scale_color_manual(labels = c("Urban","Intemediate","Rural"),#,
                     values = c(LCD_figColors[1], LCD_figColors[2], LCD_figColors[3]),
                     guide = "legend"
  )+
  guides(fill = guide_legend(override.aes = list(linetype = 0))) +
  theme(
    strip.text =element_text(hjust =0),
    legend.key =element_blank(),
    axis.line.x.top = element_line(colour = 'black', size = 0),
    legend.text.align =0,
    panel.grid =element_blank(),
    legend.key.height =grid::unit(0.2,'cm'),
    legend.position = "top",  # Change legend position to top
    legend.justification = "left",  # Change legend justification to center
    legend.direction = "vertical",  # Change legend direction to vertical
    legend.title = element_blank(),
    legend.box = "vertical",  # Display legend in a vertical box        
    axis.text =element_text(vjust=0.5,size=10),
    panel.border =element_blank(),
    axis.line.y.left =element_line(size=0.1),
    axis.text.y.right  = element_text(margin = margin(r = .3, unit = "cm"),size=10) ,
    axis.line.x.bottom =element_line(size=0.1),
    axis.line.y.right = element_line(size=0.1),
    axis.ticks.y.right = element_line(color = "black"),
    axis.title.y.right = element_text(color = "black", size = 10)
  )# +
# scale_y_continuous( 
#sec.axis = sec_axis( trans=~.*scaling_factor,
#    name="Relative change (%) in imports of \n dengue cases to dengue suitable NUTS3 regions"
#  )
# )


Urban_Rural_fig



