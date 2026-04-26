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

# Introduce average count of C1 and C2 first returns
CFS.DF.Unique.v3 <- CFS.DF.Unique.v3 %>%
  mutate(
    avg.C1.C2.first = (counts.C1.first.abv.0.0m + counts.C2.first.abv.0.0m) / 2,
    ratio.C1 = counts.C1.all.abv.0.0m / avg.C1.C2.first,
    ratio.C2 = counts.C2.all.abv.0.0m / avg.C1.C2.first,
    ratio.C3 = counts.C3.all.abv.0.0m / avg.C1.C2.first
  )

# Reshape data into long format for plotting
df_long_ratios <- CFS.DF.Unique.v3 %>%
  select(ratio.C1, ratio.C2, ratio.C3) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Channel",
    values_to = "Ratio"
  )

# Define color mapping
channel_colors <- c("ratio.C1" = "blue", "ratio.C2" = "red", "ratio.C3" = "green")

# Calculate median and 95th percentile values **only for C3**, and add 'Channel' column
summary_stats_C3 <- df_long_ratios %>%
  filter(Channel == "ratio.C3") %>%
  summarize(
    median = median(Ratio, na.rm = TRUE),
    p95 = quantile(Ratio, 0.95, na.rm = TRUE)
  ) %>%
  mutate(Channel = "ratio.C3")  # Fix: Add 'Channel' so geom_text() recognizes it

# Create probability density plot for the ratios
# Create probability density plot for the ratios
plot <- ggplot(df_long_ratios, aes(x = Ratio, fill = Channel, color = Channel)) +
  geom_density(alpha = 0.2) +
  scale_fill_manual(values = channel_colors) +
  scale_color_manual(values = channel_colors) +
  geom_vline(data = summary_stats_C3, aes(xintercept = median),
             color = "black", linetype = "dashed", size = 0.7, alpha = 0.8) +  # Median (C3)
  geom_vline(data = summary_stats_C3, aes(xintercept = p95),
             color = "black", linetype = "dotted", size = 0.7, alpha = 0.8) +  # 95th Percentile (C3)
  geom_text(data = summary_stats_C3, aes(x = median, y = 0.02, 
                                         label = paste0("Median = ", round(median, 2))),
            angle = 90, vjust = -0.5, hjust = -0.1, color = "black", size = 4) +  # Vertical label for median
  geom_text(data = summary_stats_C3, aes(x = p95, y = 0.02, 
                                         label = paste0("95% = ", round(p95, 2))),
            angle = 90, vjust = -0.5, hjust = -0.1, color = "black", size = 4) +  # Vertical label for 95%
  labs(
    title = "Probability Density of Channel Echo-to-Pulse Ratios",
    x = "Ratio",
    y = "Density",
    fill = "Channel",
    color = "Channel"
  ) +
  theme_minimal(base_size = 14) + 
  theme(
    legend.position = "top",
    panel.background = element_rect(fill = "white", color = NA),  # Ensure white background
    plot.background = element_rect(fill = "white", color = NA)    # Ensure white background
  )

plot
# Save the plot as a PNG file with white background
ggsave("channel_ratios_density.png", plot = plot, width = 10, height = 6, dpi = 300, bg = "white")
