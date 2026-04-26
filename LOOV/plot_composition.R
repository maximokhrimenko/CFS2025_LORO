# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the main data
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")

# Ensure PLOT_CON_PERC is numeric
df$PLOT_CON_PERC <- as.numeric(df$PLOT_CON_PERC)

# Create boxplot ## see version 2 without color below
plot <- ggplot(df, aes(x = LOCATION, y = PLOT_CON_PERC, fill = LOCATION)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.6) +  # Boxplot without extreme outliers
  geom_jitter(width = 0.2, alpha = 0.4, color = "black") +  # Add scatter points
  labs(title = "Distribution of Conifer Fraction by Location",
       x = "Location",
       y = "Conifer Fraction (%)") +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",  # Remove legend since x-axis labels categories
    panel.background = element_rect(fill = "white", color = "black")  # Ensure white background
  ) +
  scale_fill_brewer(palette = "Dark2")  # Use colorblind-friendly palette

plot

# Save the figure as a high-resolution PNG
ggsave("Conifer_Fraction_Boxplot.png", plot = plot, width = 10, height = 6, dpi = 300)

# Print the plot
print(plot)


# Create boxplot version 2 without color
plot <- ggplot(df, aes(x = LOCATION, y = PLOT_CON_PERC)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.6) +  # Boxplot without extreme outliers
  geom_jitter(width = 0.2, alpha = 0.4, color = "black") +  # Add scatter points
  labs(title = "Distribution of Conifer Fraction by Location",
       x = "Location",
       y = "Conifer Fraction (%)") +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",  # Remove legend since x-axis labels categories
    panel.background = element_rect(fill = "white", color = "black")  # Ensure white background
  ) +
  scale_fill_brewer(palette = "Dark2")  # Use colorblind-friendly palette

plot

# Save the figure as a high-resolution PNG
ggsave("Conifer_Fraction_Boxplot_v2.png", plot = plot, width = 10, height = 6, dpi = 300)

# Print the plot
print(plot)

### colored like the scattered plots

plot <- ggplot(df, aes(x = LOCATION, y = PLOT_CON_PERC, fill = LOCATION)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.6) +  # Semi-transparent colored boxes
  geom_jitter(width = 0.2, alpha = 0.4, color = "black") +  # Black jitter points
  labs(title = "Distribution of Conifer Fraction by Location",
       x = "Location",
       y = "Conifer Fraction (%)") +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",  # No legend needed
    panel.background = element_rect(fill = "white", color = "black")  # White background
  )

