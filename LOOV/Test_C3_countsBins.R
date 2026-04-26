# Clear environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/ms_channels_test")

# Read the dataset
CFS.DF.Unique.v3 <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")

# Load necessary libraries
library(ggplot2)
library(tidyr)
library(dplyr)

# Replace NA values in counts.C3.all.abv.0.0m with 0
CFS.DF.Unique.v3$counts.C3.all.abv.0.0m[is.na(CFS.DF.Unique.v3$counts.C3.all.abv.0.0m)] <- 0

# Define bin ranges
bins <- c(0, 200, 400, 600, Inf)
labels <- c("0-200", "200-400", "400-600", "600+")

# Apply binning to C1, C2, and C3 counts
CFS.DF.Unique.v3 <- CFS.DF.Unique.v3 %>%
  mutate(
    C1_bin = cut(counts.C1.all.abv.0.0m, breaks = bins, labels = labels, right = FALSE),
    C2_bin = cut(counts.C2.all.abv.0.0m, breaks = bins, labels = labels, right = FALSE),
    C3_bin = cut(counts.C3.all.abv.0.0m, breaks = bins, labels = labels, right = FALSE)
  )

# Create summary table
counts_table <- CFS.DF.Unique.v3 %>%
  summarise(
    C1 = c(sum(C1_bin == "0-200", na.rm = TRUE),
           sum(C1_bin == "200-400", na.rm = TRUE),
           sum(C1_bin == "400-600", na.rm = TRUE),
           sum(C1_bin == "600+", na.rm = TRUE)),
    
    C2 = c(sum(C2_bin == "0-200", na.rm = TRUE),
           sum(C2_bin == "200-400", na.rm = TRUE),
           sum(C2_bin == "400-600", na.rm = TRUE),
           sum(C2_bin == "600+", na.rm = TRUE)),
    
    C3 = c(sum(C3_bin == "0-200", na.rm = TRUE),
           sum(C3_bin == "200-400", na.rm = TRUE),
           sum(C3_bin == "400-600", na.rm = TRUE),
           sum(C3_bin == "600+", na.rm = TRUE))
  ) %>%
  mutate(Bin = labels, .before = C1) # Add bin labels as row names

# Display the table
print(counts_table)

# Save the table as a CSV file
write.csv(counts_table, "counts_bins_summary.csv", row.names = FALSE)

print("Counts bin summary saved as 'counts_bins_summary.csv'.")
