# Mapping 1920 smallpox outbreak

rm(list = ls())
library(sf)
library(tidyverse)
library(cowplot)
library(writexl)
library(readxl) # For reading in data from Excel
library(dplyr) # for SQL-like joins
library(gdalUtils)
library(ggplot2)
library(rgeos)
library(rgdal) # for readOGR
library(rgeos) # for readWKT (location of smallpox hospital)
library(sf) # For maps


#Read in shp files for Wards etc
wards_geom <- sf::st_read("2024-Cite-Malade-Smallpox/shp/Wards_1912.shp")
rivers <- sf::st_read("2024-Cite-Malade-Smallpox/shp/Rivers.shp")
subway <- sf::st_read("2024-Cite-Malade-Smallpox/shp/Subway.shp")

# Read in smallpox data
Smallpox_data <- read_excel(path = "2024-Cite-Malade-Smallpox/Smallpox_data_1911_onwards.xlsx")

# Reduce to one year with 37 wards
Smallpox_data <- subset(Smallpox_data, Year== 1922)
# Reduce to key variables
variables <- c("Ward_name", "Ward_num", "Smallpox_case_rate_1920", "Smallpox_death_rate_1920")
Smallpox_data <- Smallpox_data[variables]

# Replace zeros with NA to clearly show where no cases/rates
Smallpox_data$Smallpox_case_rate_1920 <- ifelse(Smallpox_data$Smallpox_case_rate_1920 == 0, NA, Smallpox_data$Smallpox_case_rate_1920)
Smallpox_data$Smallpox_death_rate_1920 <- ifelse(Smallpox_data$Smallpox_death_rate_1920 == 0, NA, Smallpox_data$Smallpox_death_rate_1920)

wards_geom <- left_join(wards_geom, Smallpox_data, by=c("Ward_Num"="Ward_num"))
class(wards_geom)

# Plotting wards with names
ggplot(wards_geom) + geom_sf() + ggtitle("Wards 1920") +
  geom_sf_label(aes(label = paste0(Ward_name)))

# Adding hospital positions
wards_proj4string <- readOGR(path.expand("shp/Wards_Shp/Wards_1912.shp"))
belvidere_hosp <- readWKT("POINT(262400 663601)", p4s = proj4string(wards_proj4string)) # in Dalmarnock, British National Grid coordinates, pulled from Digimap directly
belvidere_hosp <- st_as_sf(belvidere_hosp)
robroyston_hosp <- readWKT("POINT(263586 668786)", p4s = proj4string(wards_proj4string)) # in Springburn, British National Grid coordinates, pulled from Digimap directly
robroyston_hosp <- st_as_sf(robroyston_hosp)

legend_position_x <- 0.08
legend_position_y <- 0.19
annotate_hjust <- -0.15
annotate_vjust <- -0.6
legend_key_size <- 0.28
summary(wards_geom$Smallpox_case_rate_1920) # max 2.53
summary(wards_geom$Smallpox_death_rate_1920) # max 0.4

CR_map <- ggplot(data=wards_geom) + geom_sf(aes(fill = Smallpox_case_rate_1920), colour = "lightgrey", size = 0.2) +
  geom_sf(data=subway, colour = "grey60", linetype = 1, size = 0.6) + 
  geom_sf(data=subway, colour = "black", linetype = 6, size = 0.6) + 
  geom_sf(data=rivers, fill = "dodgerblue3", size = 0.2, colour="dodgerblue3") + 
  geom_sf(data=robroyston_hosp , col="#990000", size = 3, shape = 3, stroke = 1.5) +
  geom_sf(data=belvidere_hosp , col="white", size = 3, shape = 3, stroke = 2.5) +
  geom_sf(data=belvidere_hosp , col="#000099", size = 3, shape = 3, stroke = 1.5) +
  scale_fill_gradient("Numbers",low = "gold", high = "darkolivegreen", 
                      limits = c(0,3), breaks = seq(1,3,by=1), label = function(x) sprintf("%.1f", x), na.value="white") +
  theme_light() +  ggtitle("Smallpox case rate")  +
  theme(legend.position = c(legend_position_x, legend_position_y),
        legend.title = element_blank(), axis.title.x=element_blank(), axis.title.y=element_blank(),
        legend.key.size = unit(legend_key_size, 'cm'),
        plot.margin = unit(c(0.1, 0.1, 0.1, 0.2), "cm")) 
CR_map

DR_map <- ggplot(data=wards_geom) + geom_sf(aes(fill = Smallpox_death_rate_1920), colour = "lightgrey", size = 0.2) +
  geom_sf(data=subway, colour = "grey60", linetype = 1, size = 0.6) + 
  geom_sf(data=subway, colour = "black", linetype = 6, size = 0.6) + 
  geom_sf(data=rivers, fill = "dodgerblue3", size = 0.2, colour="dodgerblue3") + 
  geom_sf(data=robroyston_hosp , col="#990000", size = 3, shape = 3, stroke = 1.5) +
  geom_sf(data=belvidere_hosp , col="white", size = 3, shape = 3, stroke = 2.5) +
  geom_sf(data=belvidere_hosp , col="#000099", size = 3, shape = 3, stroke = 1.5) +
  scale_fill_gradient("Numbers",low = "gold", high = "darkolivegreen", 
                      limits = c(0,0.5), breaks = seq(0.1,0.5, by=0.1), label = function(x) sprintf("%.1f", x), na.value="white") +
  theme_light() +  ggtitle("Smallpox death rate")  +
  theme(legend.position = c(legend_position_x, legend_position_y),
        legend.title = element_blank(), axis.title.x=element_blank(), axis.title.y=element_blank(),
        legend.key.size = unit(legend_key_size, 'cm'),
        plot.margin = unit(c(0.1, 0.1, 0.1, 0.2), "cm"))
DR_map

Combined_plot <- plot_grid(CR_map, DR_map, nrow = 1)
Combined_plot

ggsave(plot = Combined_plot, filename = "2024-Cite-Malade-Smallpox/Smallpox_Figs/Figure_4.png",  width = 20, height = 9, units = "cm")
ggsave(plot = Combined_plot, filename = "2024-Cite-Malade-Smallpox/Smallpox_Figs/Figure_4.pdf",  width = 20, height = 9, units = "cm")
ggsave(plot = Combined_plot, filename = "2024-Cite-Malade-Smallpox/Smallpox_Figs/Figure_4.eps",  width = 20, height = 9, units = "cm")

###########################################################################################
