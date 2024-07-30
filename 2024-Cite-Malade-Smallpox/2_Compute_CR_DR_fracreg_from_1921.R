# Examining impact of 1920 outbreak (DR and CR) on subsequent COV

# Produces base model results (fracreg with clustered SE) using Persons_per_acre_1921,
# Rooms_per_house_1921 and average COV 1913-14 as controls.
# Also produces margins output for fracreg model

rm(list = ls())
library(readxl) # For reading in data from Excel
library(writexl)
library(dplyr) # for SQL-like joins
library(tidyr) # for gather

# Load libraries for robust standard errors and small-sample adjustment
library(lmtest)
library(clubSandwich)
library(margins)
library(estimatr)
library(sandwich) # for vcovCL

#######################################################################################
#                                 Set up and estimate models 
#######################################################################################

# Import specially created smallpox 1920 dataset
Data_1907_onwards_all_wards <- read_excel("2024-Cite-Malade-Smallpox/Smallpox_data_1911_onwards.xlsx", sheet = "Data")

source("2024-Cite-Malade-Smallpox/R/compile_fracreg_outputs_1920.R")

###############################################################################
###### Looking at impact of smallpox outbreak on COV in following years #######
######                   Looking at all 37 wards                        #######
###############################################################################

Data_1921_onwards <- subset(Data_1907_onwards_all_wards, Year >= 1921)

yrs <- 1:11
yrs_text <- yrs + 1920

# Add Year_numeric
Data_1921_onwards$Year_numeric <- Data_1921_onwards$Year - 1920

# Run analysis : No Belvidere
# CASE RATE
case_rate_fracreg_1314 <- glm(COV_perc_births ~ Smallpox_case_rate_1920 * Year_numeric +
                                Persons_per_acre_1921 + 
                                Rooms_per_house_1921  +
                                COV_perc_births_1913_14, 
                              data = Data_1921_onwards, 
                              family = quasibinomial('logit')) # fracreg logit
summary(case_rate_fracreg_1314) # NB: Only use this output for coefficient estimates because se are non-clustered

# Compute clustered standard errors - see https://www.r-bloggers.com/2021/05/clustered-standard-errors-with-r/
# Compute covariance matrix
case_rate_fracreg_cl_vcov_mat_1314 <- vcovCL(case_rate_fracreg_1314, cluster = ~ Ward_name)
case_rate_fracreg_clusSE_1314 <- coeftest(case_rate_fracreg_1314, vcov = case_rate_fracreg_cl_vcov_mat_1314)
case_rate_fracreg_clusSE_1314

# Compute margins, passing in covariance matrix for clustered standard errors
# This gives the same AME as Stata with clustered SE
case_rate_fracreg_margins_years_1314 <- margins(case_rate_fracreg_1314, vcov = case_rate_fracreg_cl_vcov_mat_1314, 
                                                variables = "Smallpox_case_rate_1920", 
                                                at = list(Year_numeric = yrs))
summary(case_rate_fracreg_margins_years_1314)
case_rate_fracreg_margins_1314 <- margins(case_rate_fracreg_1314, vcov = case_rate_fracreg_cl_vcov_mat_1314) 
summary(case_rate_fracreg_margins_1314)

# DEATH RATE
# 1913-14
DR_fracreg_1314 <- glm(COV_perc_births ~ Smallpox_death_rate_1920 * Year_numeric +
                             Persons_per_acre_1921 + 
                             Rooms_per_house_1921  +
                             COV_perc_births_1913_14, 
                           data = Data_1921_onwards, 
                           family = quasibinomial('logit')) # fracreg logit
summary(DR_fracreg_1314) # NB: Only use this output for coefficient estimates because se are non-clustered

# Compute clustered standard errors - see https://www.r-bloggers.com/2021/05/clustered-standard-errors-with-r/
# Compute covariance matrix
DR_fracreg_cl_vcov_mat_1314 <- vcovCL(DR_fracreg_1314, cluster = ~ Ward_name)
DR_fracreg_clusSE_1314 <- coeftest(DR_fracreg_1314, vcov = DR_fracreg_cl_vcov_mat_1314)
DR_fracreg_clusSE_1314

# Compute margins, passing in covariance matrix for clustered standard errors
# This gives the same AME as Stata with clustered SE
DR_fracreg_margins_years_1314 <- margins(DR_fracreg_1314, vcov = DR_fracreg_cl_vcov_mat_1314, 
                                             variables = "Smallpox_death_rate_1920", 
                                             at = list(Year_numeric = yrs))
summary(DR_fracreg_margins_years_1314)
DR_fracreg_margins_1314 <- margins(DR_fracreg_1314, vcov = DR_fracreg_cl_vcov_mat_1314) 
summary(DR_fracreg_margins_1314)

## Output this data
#######################################################################################
#             Construct data.frame for making figures
#######################################################################################

# Read in descriptive statistics for computing sd change effects
descriptive_stats <- read_excel(path = paste0("2024-Cite-Malade-Smallpox/Desc_Stat_Ward_All_TimeInvariant.xlsx"))
COV_descriptive_stats <- read_excel(path = "2024-Cite-Malade-Smallpox/DescStat_Ward_All_TimeVarying.xlsx")
# Compute mean COV rate over all years and wards 
mean_COV <- mean(COV_descriptive_stats$Mean_COV)

case_rate_fracreg_df_1314 <- compile_fracreg_outputs(Experience_var_name = "Smallpox_case_rate", 
                                                      Count_rate = "Rate",
                                                      Deaths_cases = "cases",
                                                      Model = "fracreg_1314", 
                                                      With_controls = "With",
                                                      margins_output = case_rate_fracreg_margins_1314,
                                                      margins_output_years = case_rate_fracreg_margins_years_1314,
                                                      clustered_se = case_rate_fracreg_clusSE_1314,
                                                      descriptive_stats = descriptive_stats,
                                                      COV_descriptive_stats = COV_descriptive_stats, 
                                                      mean_COV = mean_COV)

death_rate_fracreg_df_1314 <- compile_fracreg_outputs(Experience_var_name = "Smallpox_death_rate", 
                                                     Count_rate = "Rate",
                                                     Deaths_cases = "Deaths",
                                                     Model = "fracreg_1314", 
                                                     With_controls = "With",
                                                     margins_output = DR_fracreg_margins_1314,
                                                     margins_output_years = DR_fracreg_margins_years_1314,
                                                     clustered_se = DR_fracreg_clusSE_1314,
                                                     descriptive_stats = descriptive_stats,
                                                     COV_descriptive_stats = COV_descriptive_stats, 
                                                     mean_COV = mean_COV)

fracreg_df <- rbind(case_rate_fracreg_df_1314, death_rate_fracreg_df_1314)

write_xlsx(fracreg_df, paste0("2024-Cite-Malade-Smallpox/Results_DR_CR_fracreg_COV_1314_1921.xlsx"))
write.csv(x = fracreg_df, file = paste0("2024-Cite-Malade-Smallpox/Results_Wards_fracreg_Baseline.csv"))

