# Plot COV rates by ward in 1919 and 1920

rm(list = ls())
library(readxl) # For reading in data from Excel
library(ggplot2)
library(dplyr) # for SQL-like joins
library(reshape) # for version of rename used here

# Import specially created smallpox 1920 dataset
COV <- read_excel("2024-Cite-Malade-Smallpox/Smallpox_data_1911_onwards.xlsx", sheet = "Data")

# Reduce to 1912 - 1920
COV_1912_1920 <- subset(COV, Year>= 1912 & Year <= 1920)
# Reduce to columns 1-23 which includes any variables we need
COV_1912_1920 <- COV_1912_1920[,1:23]

# Look at COV rates 1919 and 1920
COV_1919 <- subset(COV, Year == 1919)
COV_1920 <- subset(COV, Year == 1920)
COV_1920$COV_1919 <- COV_1919$COV_perc_births

# Plot COV 1919 and 1920

COV_variables <- c("Ward_name", "COV_1919")
COV_variables_1920 <- c("Ward_name", "COV_perc_births")
COV_variables_results_1919 <- COV_1920[COV_variables]
COV_variables_results_1919$Year <- 1919 
COV_variables_results_1920 <- COV_1920[COV_variables_1920]
COV_variables_results_1920$Year <- 1920
colnames(COV_variables_results_1919)[2] <- "COV_perc_births"

COV_variables_results <- rbind(COV_variables_results_1919, COV_variables_results_1920)
# Make Year a character
COV_variables_results$Year <- as.character(COV_variables_results$Year)
COV_variables_results <- as.data.frame(COV_variables_results)

# Look at COV rates 1919 and 1920
COV_1919 <- subset(COV, Year == 1919)
COV_1920 <- subset(COV, Year == 1920)
COV_1920$COV_1919 <- COV_1919$COV_perc_births

COV_variables <- c("Ward_name", "COV_1919")
COV_variables_1920 <- c("Ward_name", "COV_perc_births")
COV_variables_results_1919 <- COV_1920[COV_variables]
COV_variables_results_1920 <- COV_1920[COV_variables_1920]
COV_variables_results_1919 <- rename(COV_variables_results_1919, "COV_perc_births" == COV_1919)
colnames(COV_variables_results_1920)[2] <- "COV_1920"

COV_variables_results <- cbind(COV_variables_results_1919, COV_variables_results_1920[,2])
COV_variables_results <- as.data.frame(COV_variables_results)
COV_variables_results$COV_av <- (COV_variables_results$COV_1919 + COV_variables_results$COV_1920)/2
COV_variables_results$range <- COV_variables_results$COV_1919 - COV_variables_results$COV_1920

COV_variables_results <- arrange(COV_variables_results, range)

#To make 'arrange' stick: turn your 'treatment' column into a character vector
COV_variables_results$Ward_name <- as.character(COV_variables_results$Ward_name)
#Then turn it back into a factor with the levels in the correct order
COV_variables_results$Ward_name <- factor(COV_variables_results$Ward_name, levels=unique(COV_variables_results$Ward_name))

temp_ordered <- arrange(.data = COV_variables_results, COV_1919)
temp_ordered$Ward_name <- factor(temp_ordered$Ward_name, levels = temp_ordered$Ward_name, ordered = T)
dim(temp_ordered)
head(temp_ordered)

# Make and save figure
fig_COV <- ggplot(temp_ordered) + 
  geom_linerange(mapping=aes(x=Ward_name, y=COV_av, ymin=COV_1920, ymax=COV_1919), linewidth =0.5)  +
  geom_point(aes(x=Ward_name,y=COV_1920),shape = 16, fill="black", color="black",size = 3) +
  geom_point(aes(x=Ward_name,y=COV_1919),shape = 1, size = 3) +
  scale_y_continuous(name = "Vaccination refusal rate (open circles = 1919, filled circles = 1920)",
                   labels = scales::percent, limits = c(0,0.45),
                   expand = expansion(mult = c(0.1, 0.1))) +
  theme_classic() + theme(
                          strip.background = element_blank(),
                          axis.title.x = element_text(family = "Helvetica", size = 10),
                          strip.text = element_blank(),
                          legend.margin=margin(c(0,5,0,5)), # top, right, bottom, left
                          axis.ticks.y = element_line(),
                          panel.spacing = unit(2, "lines")) +
  theme(axis.title.y = element_blank()) +
  coord_flip(xlim = NULL, ylim = NULL, expand = TRUE, clip = "on") # Co-ord flip so horizontal
fig_COV 
  
ggsave(filename = paste0("Figure_5.png"), plot = fig_COV, path = "2024-Cite-Malade-Smallpox/Smallpox_Figs", width = 22, height = 15, units = "cm", dpi = 300)
ggsave(filename = paste0("Figure_5.pdf"), plot = fig_COV, path = "2024-Cite-Malade-Smallpox/Smallpox_Figs", width = 22, height = 15, units = "cm")
ggsave(filename = paste0("Figure_5.eps"), plot = fig_COV, path = "2024-Cite-Malade-Smallpox/Smallpox_Figs", width = 22, height = 15, units = "cm")
