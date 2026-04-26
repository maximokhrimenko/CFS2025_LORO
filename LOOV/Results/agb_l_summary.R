# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the main data and models variable file
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")


# Filter the desired columns
df_filtered <- df %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF  # Sum of live and small live components
    
  ) %>%
  replace(is.na(.), 0) # Replace NA with 0


# Summarize data by LOCATION
summary_table <- df_filtered %>%
  group_by(LOCATION) %>%
  summarise(
    avg = mean(agb_l, na.rm = TRUE),
    min = min(agb_l, na.rm = TRUE),
    max = max(agb_l, na.rm = TRUE),
    SD = sd(agb_l, na.rm = TRUE),
    n_plots = n() # Count number of plots per LOCATION
  ) %>%
  ungroup()

# Compute summary for all regions
all_regions <- df_filtered %>%
  summarise(
    LOCATION = "All Regions",
    avg = mean(agb_l, na.rm = TRUE),
    min = min(agb_l, na.rm = TRUE),
    max = max(agb_l, na.rm = TRUE),
    SD = sd(agb_l, na.rm = TRUE),
    n_plots = n() # Total number of plots
  )

# Combine data
final_summary <- bind_rows(summary_table, all_regions)

# Save as CSV
write.csv(final_summary, "agb_l_Summary.csv", row.names = FALSE)

# Print summary to check
print(final_summary)
