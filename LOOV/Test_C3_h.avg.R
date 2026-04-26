# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(ggplot2)
library(dplyr)
library(tidyr)  # For reshaping data

# Read the main data and models variable file
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")



# Select only the relevant columns (C1, C2, C3, C12, C123)
df_long <- df %>%
  select(C1.h.avg.all.abv.0.0m, C2.h.avg.all.abv.0.0m, C3.h.avg.all.abv.0.0m, 
         C12.h.avg.all.abv.0.0m, C123.h.avg.all.abv.0.0m) %>%
  pivot_longer(cols = everything(), names_to = "Category", values_to = "Value")

# Clean category names to remove ".h.avg.all.abv.0.0m" suffix
df_long$Category <- gsub("\\.h\\.avg\\.all\\.abv\\.0\\.0m", "", df_long$Category)

# Convert Category to factor for ordered plotting
df_long$Category <- factor(df_long$Category, levels = c("C1", "C2", "C3", "C12", "C123"))

# Create the plot
ggplot(df_long, aes(x = Category, y = Value, fill = Category)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.6) +  # Boxplot without extreme outliers
  geom_jitter(width = 0.2, alpha = 0.4, color = "black") +  # Add scatter points
  labs(title = "Comparison of h.avg.all.abv.0.0m Across Channels",
       x = "Category",
       y = "h.avg.all.abv.0.0m") +
  theme_minimal() +
  theme(legend.position = "none")  # Remove legend since x-axis already labels categories

# Create the plot with a white background
plot <- ggplot(df_long, aes(x = Category, y = Value, fill = Category)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.6) +  # Boxplot without extreme outliers
  geom_jitter(width = 0.2, alpha = 0.4, color = "black") +  # Add scatter points
  labs(title = "Comparison of h.avg.all.abv.0.0m Across Channels",
       x = "Category",
       y = "h.avg.all.abv.0.0m") +
  theme_classic(base_size = 14) +  # White background with classic theme
  theme(legend.position = "none")  # Remove legend since x-axis already labels categories

# Save the figure as a PNG file (high resolution) with a white background
ggsave(filename = "Comparison_h_avg_all_abv_0_0m.png",
       plot = plot, 
       width = 8, height = 6, dpi = 300, 
       bg = "white")  # Ensure white background in saved file

print("Figure saved as 'Comparison_h_avg_all_abv_0_0m.png' with a white background.")
