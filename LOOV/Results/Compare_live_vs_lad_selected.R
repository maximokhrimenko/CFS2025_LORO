# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the main data and models variable file
models.agb_l <- read.csv("selected_models_agb_l.csv") # Contains x1, x2, x3 and rmse
models.agb_lad <- read.csv("selected_models_agb_lad.csv") # Contains x1, x2, x3 and rmse

# Compute relative RMSE for agb_l
models.agb_l <- models.agb_l %>%
  mutate(relative.rmse = 100 * rmse / 135.4546)

# Compute relative RMSE for agb_lad
models.agb_lad <- models.agb_lad %>%
  mutate(relative.rmse = 100 * rmse / 160.3262)

# Function to convert predictors into unique sets
get_model_set <- function(df) {
  df %>%
    select(x1, x2, x3, relative.rmse) %>%  # Include relative RMSE in selection
    mutate(model_set = apply(select(., x1, x2, x3), 1, function(x) paste(sort(x), collapse = ","))) %>%
    select(model_set, relative.rmse) # Keep RMSE for reference
}

# Process both dataframes
models_agb_l_sets <- get_model_set(models.agb_l)
models_agb_lad_sets <- get_model_set(models.agb_lad)

# Find common models (same predictor sets)
common_models <- inner_join(models_agb_l_sets, models_agb_lad_sets, by = "model_set", suffix = c("_agb_l", "_agb_lad"))

# Display results
if (nrow(common_models) > 0) {
  print("Common models found with relative RMSE:")
  print(common_models)
} else {
  print("No common models found.")
}

# Save results to a CSV file
write.csv(common_models, "common_selected_models_with_rmse.csv", row.names = FALSE)
print("Common models saved as 'common_selected_models_with_rmse.csv'.")
