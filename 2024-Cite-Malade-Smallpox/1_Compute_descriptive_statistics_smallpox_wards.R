# Computes descriptive statistics for models etc

rm(list = ls())
library(readxl) # For reading in data from Excel
library(dplyr) # for SQL-like joins and pipe %>%
library(writexl)

# Read in data
# Import specially created smallpox 1920 dataset
COV <- read_excel("2024-Cite-Malade-Smallpox/Smallpox_data_1911_onwards.xlsx", sheet = "Data")
# Remove years pre-1920
COV <- subset(COV, Year >= 1920)

# ---------------------- Descriptive statistics for figure calculations -----------------------

# Overall COV_Prop_Births desc stats 
mean(COV$COV_perc_births)
min(COV$COV_perc_births)
max(COV$COV_perc_births)
sd(COV$COV_perc_births)
COV_c_of_v <- sd(COV$COV_perc_births) / mean(COV$COV_perc_births) * 100

# Summary of COV rates in 1931
summary(COV %>% filter(Year == 1931) %>% dplyr::select(COV_perc_births))
# Compute mean and sd in the number of cases of smallpox
mean(unlist(COV %>% filter(Year == 1920) %>% dplyr::select(Smallpox_cases_1920)))
sd(unlist(COV %>% filter(Year == 1920) %>% dplyr::select(Smallpox_cases_1920)))
sd(unlist(COV %>% filter(Year == 1920) %>% dplyr::select(Smallpox_deaths_1920)))
summary(unlist(COV %>% filter(Year == 1920) %>% dplyr::select(Smallpox_cases_1920)))
summary(unlist(COV %>% filter(Year == 1920) %>% dplyr::select(Smallpox_deaths_1920)))
# Mean and sd in rate of COV in 1920
mean(unlist(COV %>% filter(Year == 1920) %>% dplyr::select(COV_perc_births)))
sd(unlist(COV %>% filter(Year == 1920) %>% dplyr::select(COV_perc_births)))
mean(unlist(COV %>% dplyr::select(COV_perc_births))) # Across all wards/times

sum(COV %>% filter(Year == 1920) %>% dplyr::select(Smallpox_deaths_1920))
summary(COV %>% filter(Year == 1920) %>% dplyr::select(Smallpox_deaths_1920))
# How many fold difference is there in cases per 1000 between wards?
COV_1920 <- COV %>% filter(Year == 1920)
# Remove zeros
COV_1920 <- subset(COV_1920, Smallpox_case_rate_1920 > 0)
max(COV_1920 %>% dplyr::select(Smallpox_case_rate_1920)) / min(COV_1920 %>% 
                                                 dplyr::select(Smallpox_case_rate_1920))

# ---------------------- Mean values of COV per year -----------------------

# Used in standard deviation change effect by year for figures
Mean_COV_By_Year <- COV %>% 
  group_by(Year) %>%
  summarise(Mean_COV = mean(COV_perc_births),
            sd_COV = sd(COV_perc_births),
            min_COV = min(COV_perc_births),
            max_COV = max(COV_perc_births))

write_xlsx(Mean_COV_By_Year, paste0("2024-Cite-Malade-Smallpox/DescStat_Ward_All_TimeVarying.xlsx"))
write.csv(Mean_COV_By_Year, file = paste0("2024-Cite-Malade-Smallpox/DescStat_Ward_All_TimeVarying .csv"))


# ---------- Descriptive statistics for figure calculations --------------

# Compute descriptive statistics
COV_1920 <- COV %>% filter(Year == 1920) # So we don't get each of the variables repeated for multiple years
variables <- c("Smallpox_cases_1920", "Smallpox_case_rate_1920",
               "Smallpox_deaths_1920", "Smallpox_death_rate_1920",
               "Persons_per_acre_1921","Rooms_per_house_1921",
               "Distance_Belvidere", "COV_perc_births_1913_14")

output <- data.frame() # As numeric
output_formatted <- data.frame() # For writing out table (formatted character strings)
for (var in variables) {
  print(var)
  c_min <- min(COV_1920 %>% dplyr::select(one_of(var)))
  c_max <- max(COV_1920 %>% dplyr::select(one_of(var)))
  c_mean <- mean(unlist(COV_1920 %>% dplyr::select(one_of(var))))
  c_sd <- sd(unlist(COV_1920 %>% dplyr::select(one_of(var))))
  c_CV <-  sd(unlist(COV_1920 %>% dplyr::select(one_of(var))))/mean(unlist(COV_1920 %>% dplyr::select(one_of(var)))) *100
  output <- rbind(output, data.frame(var = var,
                                     min = c_min,
                                     max = c_max,
                                     mean = c_mean,
                                     sd = c_sd,
                                     CoV = c_CV))
  output_formatted <- rbind(output_formatted, data.frame(var = var, 
                                                         min = c_min,
                                                         max = c_max, 
                                                         mean = formatC(signif(c_mean, digits=3), digits=3, format="fg", flag="#"), 
                                                         sd = formatC(signif(c_sd, digits=3), digits=3, format="fg", flag="#"),
                                                         CoV = formatC(signif(c_sd, digits=3), digits=3, format="fg", flag="#")))
}
print(output)
str(output)
str(output_formatted)

# Write out summary statistics to file

write_xlsx(output, path = paste0("2024-Cite-Malade-Smallpox/Desc_Stat_Ward_All_TimeInvariant.xlsx"))
write.csv(output, file = paste0("2024-Cite-Malade-Smallpox/Desc_Stat_Ward_All_TimeInvariant.csv"))

