# Creates Figure 7

# One sd change effect over years for wards, CR and DR.
# Second row is static variables, sd change effect.
# Non-linear only.

rm(list = ls())
library(readxl) # For reading in data from Excel
library(ggplot2)
library(cowplot)
library(dplyr) # for SQL-like joins
library(stringr) # for the function str_wrap()

yrs <- 1:11
yrs_text <- yrs + 1920

# Read in results from fractional regression from file
fracreg_df <- read_excel(path = "2024-Cite-Malade-Smallpox/Results_DR_CR_fracreg_COV_1314_1921.xlsx")

## Create line plot for upper panel Fig 3 ###
all_results <- fracreg_df

# Use factor levels and labels to set up experience variable ordering and display labels
Exp_var <- unique(all_results$Experience_variable)
all_results$Experience_variable <- factor(all_results$Experience_variable,
                                          levels = Exp_var,
                                          labels = gsub(pattern = "_", replacement = " ", x = Exp_var))

# Remove cases and deaths and re-label rates
all_results <- subset(all_results, Model == "fracreg_1314")

all_results$Deaths_cases <- factor(all_results$Deaths_cases, levels = c("cases","Deaths"),
                                   labels = c("Smallpox case rate","Smallpox death rate"))

all_results <- subset(all_results,Time_varying == T) # moved this here as wasn't running in ggplot

# Construct Fig 7a
fig_7a <- ggplot(all_results) + 
  geom_line(aes(x = Year, y = - SD_change_effect)) +
  scale_x_continuous(name = NULL, breaks = yrs_text) + 
  scale_y_continuous(name = " ", labels = scales::percent) +
  coord_cartesian(ylim = c(0, .1), expand = F) + # Get axes to cross at zero on y-axis
  facet_grid(~ Deaths_cases) + 
  theme_classic() + 
  theme(strip.background = element_blank(), 
        strip.text = element_text(face = "bold"),
        legend.margin=margin(c(0,10,0,5)), # top, right, bottom, left
        plot.margin=grid::unit(c(0,5,0,5), "mm"),
        axis.title.y = element_text(size = 8),
        axis.text.x = element_text(angle = 90),
        #axis.text.x = element_text( vjust = 0.5, hjust=1),
        #        plot.margin = unit(c(1,0.5,0.5,0.5), "cm"), # top, right, bottom, left
        panel.spacing = unit(2, "lines"),
        legend.position="none")
fig_7a

## Create bar chart for lower panel Fig 7 ###

all_results_bar <-   fracreg_df
static_variables <- c("Rooms_per_house_1921","Persons_per_acre_1921")
all_results_bar <- subset(all_results_bar, Model == "fracreg_1314")

# Use factor levels and labels to set up experience variable ordering and display labels
Exp_var <- unique(all_results_bar$Experience_variable)
all_results_bar$Experience_variable <- factor(all_results_bar$Experience_variable,
                                              levels = Exp_var,
                                              labels = gsub(pattern = "_", replacement = " ", x = Exp_var))
all_results_bar$Deaths_cases <- factor(all_results_bar$Deaths_cases, levels = c("cases","Deaths"),
                                   labels = c("Smallpox case rate","Smallpox death rate"))
# Construct Fig 7b
# Marginal effects on the y-axis
static_variables_results <- filter(all_results_bar, Variable_name %in% static_variables)
static_variables_results$Variable_name <- factor(static_variables_results$Variable_name,
                                                 levels = static_variables,
                                                 labels = c("Population density","Rooms per dwelling"))
# SD_change_effect on the y-axis
fig_7b <- ggplot(static_variables_results) + 
  geom_col(aes(x = Variable_name, 
               y = - SD_change_effect),
           position = position_dodge(width = 0.5),
           width = 0.4,
           colour = "white") +
  scale_y_continuous(name = "",
                     labels = scales::percent_format(accuracy = 5L), limits = c(0,0.2),
                     expand = expansion(mult = c(0, 0))) +
  scale_x_discrete("", labels = function(x) str_wrap(x, width = 10)) +
  facet_wrap(~ Deaths_cases) + 
  theme_classic() + theme(axis.line=element_line(),
                          strip.background = element_blank(),
                          strip.text = element_blank(),
                          legend.margin=margin(c(0,5,0,5)), # top, right, bottom, left
                          axis.title.y = element_text(hjust = -0.4), # fiddle to get axis text across both plots
                          panel.spacing = unit(2, "lines"),
                          plot.margin=grid::unit(c(7,5,0,7), "mm"), # top, right, bottom, left
                          legend.position="none")
fig_7b

# Create full-height y-axis label
title <- ggdraw() + 
  draw_label(
    "Percent reduction in vaccine refusal rate for one sd increase in\n (A) case or death rate and (B) variable shown on x-axis",
    size = 10,
    x = 0,
    vjust = 0,
    angle = 90
  ) +
  theme(
    # add margin on the left of the drawing canvas,
    # so title is aligned with left edge of first plot
    plot.margin = margin(0, 0, 0, 25)
  )

right_panel <- plot_grid(fig_7a, fig_7b, labels = c('A', 'B'), ncol = 1)
fig_7 <- plot_grid(title, right_panel, ncol = 2, rel_widths = c(0.07,0.93))
fig_7

ggsave(filename = paste0("Figure_7.pdf"), plot = fig_7, path = "2024-Cite-Malade-Smallpox/Smallpox_Figs", width = 18, height = 11.5, units = "cm")
ggsave(filename = paste0("Figure_7.png"), plot = fig_7, path = "2024-Cite-Malade-Smallpox/Smallpox_Figs", width = 18, height = 11.5, units = "cm")
ggsave(filename = paste0("Figure_7.eps"), plot = fig_7, path = "2024-Cite-Malade-Smallpox/Smallpox_Figs", width = 18, height = 11.5, units = "cm")
