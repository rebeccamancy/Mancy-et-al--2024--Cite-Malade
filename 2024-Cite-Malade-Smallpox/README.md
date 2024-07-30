# Conscientious_Objection to vaccination in Glasgow, 1921-1931
Code and data for:

Mancy, R., Stewart, G., Schroeder, M., Lazarakis, S., & Angelopoulos, K. (2024). The legacy of epidemics: Influenza and smallpox in the early 20th century in Glasgow, UK. In S. Juillet-Garzón, S. Pech-Pelletier, & S. Perez (Eds.), La Cité malade : émotions, cultures et pouvoirs dans les villes en période d’épidémie (16e-19e siècles). Jérôme Millon.

# Files included and file structure
Input data are in 'Smallpox_data_1911_onwards.xlsx'.
Data are sourced from Medical Officer of Health Reports and reports of the Registrar General for Scotland. Data are all transcribed to the ward structures that existed in Glasgow 1903-1920, as described in the text.

For Figure 4 code to run, Shapefiles are required. The files for these should be downloaded from https://doi.org/10.5281/zenodo.11118884 and put into a folder named "shp" one level below 2024-Cite-Malade-Smallpox. The required files are for the Shapefiles named Wards_1912, Subway, Rivers (including auxiliary files with these names, i.e. all extensions).

# Running the code
Start by running the following scripts in the order below.
        
## Statistical analysis files

1_Compute_descriptive_statistics_smallpox_wards.R reads in the data from Smallpox_data_1911_onwards.xlsx and computes statistics used in the later analysis.

2_Compute_CR_DR_fracreg_from_1921.R reads in data from Smallpox_data_1911_onwards.xlsx and descriptive statistics files and conducts analysis of the 1920 smallpox outbreak on vaccine refusal 1921 onwards using fractional regression. This script also uses the function in R/compile_fracreg_outputs_1920.R to produce the required output.

## Create figures
All figures can be found in /Smallpox_Figs.

Fig4_Map_smallpox_outbreak.R uses data from Smallpox_data_1911_onwards.xlsx and various shape files to create maps of the smallpox case and death rate per thousand population (shading) in municipal wards of Glasgow over the period February 1920 - December 1920 (the main epidemic period); wards with zero cases or deaths are shown in white. The Belvidere Smallpox Hospital is indicated with a blue cross, the Robroyston Hospital with a red cross, the River Clyde and River Kelvin are shown in blue and the route of the Glasgow Subway is indicated with a dashed black line. The shapefile for the map was constructed by Mancy (2023). Case and death rates from November 1920 onwards were reported using the new post-1920 ward structure; for consistency, these have been mapped back to the earlier ward structure using the conversion method discussed in Angelopoulos, Stewart, and Mancy (2023) and using the 1920 shapefile by Stewart (2023).

Fig5_COV_rates_1919_1920.R uses data from Smallpox_data_1911_onwards.xlsx and shows the change in the vaccination refusal rate in municipal wards of Glasgow in 1919 (prior to the smallpox outbreak, in white) and 1920 (during the smallpox outbreak, in black).

Scripts to make remaining figures use output from 2_Compute_CR_DR_fracreg_from_1921.R (Results_DR_CR_fracreg_COV_1314_1921.xlsx) to generate the following figures:

Fig6_CR_DR_from_1921.R plots the estimated marginal effect of the smallpox case and death rate during the 1920 epidemic on the vaccine refusal rate in each year 1921-1931, with 95% confidence intervals, for our nonlinear (fractional regression) model. The marginal effects are calculated as the effect of an increase of one unit in the smallpox case or death rate on the vaccine refusal rate for the year shown on the x-axis. For additional details, see Angelopoulos, Stewart, and Mancy (2023).

Fig7_smallpox1920_CR_DR_reduction.R plots (A) Percent reduction in vaccine refusal rate given a one standard deviation increase in the smallpox case or death rate during the 1920 epidemic, for the fractional regression model. The effects are expressed as the percent reduction in vaccine refusal relative to the average vaccine refusal rate in the corresponding year; and (B) Percent reduction in vaccine refusal rate given a one standard deviation increase in the independent variable shown on the x-axis. The effects are expressed as percent reduction in vaccine refusal relative to the average vaccine refusal rate across all years.
