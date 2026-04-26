###
#### this is to plot best models

rm(list = ls())

setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Resutls")

library(dplyr)
library(ggplot2)

df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")


# Filter the desired columns
df_filtered <- df %>%
  select(plot.name,lidar.year,	LOCATION, Large_LS, Large_LF, Large_DS, Small_LS, Small_LF, Small_DS, 
         C12.h.qav.all.abv.0.0m, C2.iz2.all.abv.0.0mSqrt
  )
         

df_filtered <- df_filtered %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF,  # Sum of live and small live components
    agb_lad = Large_LS + Large_DS + Large_LF + Small_LS + Small_DS + Small_LF # Includes dead components
  )

# Replace NA with 0 in df_filtered
df_filtered <- df_filtered %>%
  replace(is.na(.), 0)



# Fit linear model
model_X <- lm(agb_l ~ C12.h.qav.all.abv.0.0m + C2.iz2.all.abv.0.0mSqrt, data = df_filtered)
sum.model_X <- summary(model_X)
sum.model_X

# Add model predictions to the dataframe
df_filtered <- df_filtered %>%
  mutate(
    predictions = predict(model_X)
  )

# Plot colorized by LOCATION
plot_X <- ggplot(df_filtered, aes(x = agb_l, y = predictions, color = LOCATION)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") + # Line y = x
  labs(
    title = "Linear Model: AGB_L vs Predictions (#856 rmse rank)",
    x = "Observed AGB_L",
    y = "Predicted AGB_L",
    color = "Location"
  ) +
  theme_minimal()


print(plot_X)



