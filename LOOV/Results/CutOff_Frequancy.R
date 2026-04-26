####
### this is to calculate the frequancy of the cut-offs in the 153-list

# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results/models_l_1SE_rev")

# Load libraries
library(dplyr)
library(tidyr)
library(stringr)
library(readr)

# Read data
df <- read_csv("Filtered_Models_1SE_ttest_v9.csv")

# Combine x1, x2, x3 into one column and extract cut-offs
cutoff_freq <- df %>%
  select(x1, x2, x3) %>%
  pivot_longer(cols = everything(), values_to = "metric") %>%
  filter(!is.na(metric) & metric != "") %>%
  mutate(cutoff = str_extract(metric, "(?<=abv\\.)[0-9.]+m")) %>%
  count(cutoff, sort = TRUE)

# Print the frequency table
print(cutoff_freq)

# Save to CSV
write_csv(cutoff_freq, "CutOff_frequancy.csv")
