# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the main data and models variable file
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")

# Filter the desired columns and compute agb_l
df_filtered <- df %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF  # Sum of live and small live components
  ) %>%
  replace(is.na(.), 0) # Replace NA with 0

# Compute the 10th percentile threshold across all regions
p10_threshold <- quantile(df_filtered$agb_l, probs = 0.10, na.rm = TRUE)

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

# Compute summary for the Below 10th Percentile category
below_10p <- df_filtered %>%
  filter(agb_l < p10_threshold) %>%  # Filter rows below 10th percentile
  summarise(
    LOCATION = "Below 10th Percentile",
    avg = mean(agb_l, na.rm = TRUE),
    min = min(agb_l, na.rm = TRUE),
    max = max(agb_l, na.rm = TRUE),
    SD = sd(agb_l, na.rm = TRUE),
    n_plots = n() # Count of plots below 10th percentile
  )

# Combine all summaries
final_summary <- bind_rows(summary_table, all_regions, below_10p)

# Save as CSV
write.csv(final_summary, "agb_l_Summary_v2.csv", row.names = FALSE)

# Print summary to check
print(final_summary)
