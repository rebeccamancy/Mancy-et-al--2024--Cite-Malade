# Creates Figure 6

# Non-linear marginal effects, wards only, case rate and death rate,
# starting from 1921. 

rm(list = ls())
library(readxl) # For reading in data from Excel
library(ggplot2)
library(dplyr)

yrs <- 1:11
yrs_text <- yrs + 1920

# Read in fractional regression results
all_results <- read_excel(path = "2024-Cite-Malade-Smallpox/Results_DR_CR_fracreg_COV_1314_1921.xlsx")

# Use factor levels and labels to set up experience variable ordering and display labels
Exp_var <- unique(all_results$Experience_variable)
all_results <- filter(all_results, Time_varying == T)
all_results <- subset(all_results, Model == "fracreg_1314")
all_results$Experience_variable <- factor(all_results$Experience_variable, 
                                          levels = Exp_var,
                                          labels = gsub(pattern = "_", replacement = " ", x = Exp_var))
all_results$Deaths_cases <- factor(all_results$Deaths_cases, levels = c("cases","Deaths"),
                                 labels = c("Smallpox case rate","Smallpox death rate"))

# Construct Fig 6
fig_6_1314_COV_RHS <- ggplot(filter(all_results, Time_varying == T)) + 
  geom_hline(yintercept = 0, linetype = 2) +
  geom_line(aes(x = Year, y = Marginal_effect)) + 
  geom_pointrange(aes(x = Year, y = Marginal_effect, 
                      ymin = LCI_marginal_effect, ymax = UCI_marginal_effect), 
                  size = 0.3,
                  position = position_dodge(width = 0.3)) + 
  scale_x_continuous(name = "", breaks = yrs_text) + 
  scale_y_continuous(name = "Marginal effect of the smallpox case/death rate\non the vaccine refusal rate") +
  facet_wrap( ~  Deaths_cases, scales = "free_y") + 
  theme_classic() + 
  theme(axis.text.x = element_text(angle = 90)) +
  theme(strip.background = element_blank(), 
        axis.title.y = element_text(size = 10) ,
        strip.text = element_text(face = "bold"),
        legend.position = "none",
        legend.box.margin = unit(c(0,0,0,0), "cm")) # top, right, bottom, left
fig_6_1314_COV_RHS

ggsave(filename = paste0("Figure_6.pdf"), plot = fig_6_1314_COV_RHS, path = "2024-Cite-Malade-Smallpox/Smallpox_Figs", width = 18, height = 8.5, units = "cm")
ggsave(filename = paste0("Figure_6.png"), plot = fig_6_1314_COV_RHS, path = "2024-Cite-Malade-Smallpox/Smallpox_Figs", width = 18, height = 8.5, units = "cm")
ggsave(filename = paste0("Figure_6.eps"), plot = fig_6_1314_COV_RHS, path = "2024-Cite-Malade-Smallpox/Smallpox_Figs", width = 18, height = 8.5, units = "cm")
