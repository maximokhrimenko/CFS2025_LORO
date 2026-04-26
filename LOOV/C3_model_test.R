###
#### this is to update our tables for Live Large

rm(list = ls())

setwd("D:/MyR_projects/CFS2025_LORO/LOOV")

library(dplyr)
library(ggplot2)

df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")


# Filter the desired columns
df_filtered <- df %>%
  select(plot.name,lidar.year,	LOCATION, Large_LS, Large_LF, Large_DS, Small_LS, Small_LF, Small_DS, 
         counts.C3.all.abv.0.0m, C3.h.p25.all.abv.0.0m, C2.iz2.all.abv.0.0mSqrt, C2.h.p80.all.abv.2.0m,	C2.iz.all.abv.1.0m, 
         C12.h.qav.all.abv.0.0m,	C2.iz.all.abv.0.0m
  )

df_filtered <- df_filtered %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF,  # Sum of live and small live components
    agb_lad = Large_LS + Large_DS + Large_LF + Small_LS + Small_DS + Small_LF # Includes dead components
  )

# Replace NA with 0 in df_filtered
df_filtered <- df_filtered %>%
  replace(is.na(.), 0)



library(ggplot2)

# Scatter plot: agb_l vs C2.iz2.all.abv.0.0mSqrt colorized by LOCATION
ggplot(df_filtered, aes(x = C2.iz2.all.abv.0.0mSqrt, y = agb_l, color = LOCATION)) +
  geom_point(size = 3, alpha = 0.7) + # Points with transparency
  labs(
    title = "Scatter Plot of AGB_L vs C2.iz2",
    x = "C2.iz2.all.abv.0.0mSqrt",
    y = "AGB_L",
    color = "Location"
  ) +
  theme_minimal() + # Minimal theme for a clean look
  theme(
    text = element_text(size = 12), # Adjust text size
    plot.title = element_text(hjust = 0.5) # Center-align the title
  )


# Fit linear model
model_C3 <- lm(agb_l ~ C2.iz2.all.abv.0.0mSqrt + C3.h.p25.all.abv.0.0m, data = df_filtered)

# Add model predictions to the dataframe
df_filtered <- df_filtered %>%
  mutate(
    predictions = predict(model_C3),
    point_group = ifelse(counts.C3.all.abv.0.0m < 200, "Points < 200", "Points >= 200")
  )

# Plot colorized by LOCATION
plot_C3 <- ggplot(df_filtered, aes(x = agb_l, y = predictions, color = LOCATION)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") + # Line y = x
  labs(
    title = "Linear Model: AGB_L vs Predictions (With C3)",
    x = "Observed AGB_L",
    y = "Predicted AGB_L",
    color = "Location"
  ) +
  theme_minimal()

# Plot colorized by counts.C3.all.abv.0.0m
plot_counts <- ggplot(df_filtered, aes(x = agb_l, y = predictions)) +
  geom_point(aes(color = counts.C3.all.abv.0.0m, shape = point_group), size = 3, alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") + # Line y = x
  scale_color_gradient(low = "blue", high = "red") + # Gradient color for counts
  labs(
    title = "Linear Model: AGB_L vs Predictions (with C3)",
    x = "Observed AGB_L",
    y = "Predicted AGB_L",
    color = "Counts",
    shape = "Point Group"
  ) +
  theme_minimal()

# Display the plots
print(plot_C3)
print(plot_counts)




