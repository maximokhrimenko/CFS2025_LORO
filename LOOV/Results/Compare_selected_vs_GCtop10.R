# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the main data and models variable file
models.agb_l <- read.csv("selected_models_agb_l.csv") # Contains x1, x2, x3 and rank
models.agb_l_GC <- read.csv("selected_models_agb_l_GC.csv") # Contains x1, x2, x3 and rankSUMA

# Function to convert predictors into unique sets and retain ranking
get_model_set <- function(df, rank_col) {
  df %>%
    select(x1, x2, x3, !!rank_col) %>%  # Select predictors and ranking column
    mutate(model_set = apply(select(., x1, x2, x3), 1, function(x) paste(sort(x), collapse = ","))) %>%
    select(model_set, !!rank_col) # Keep ranking column
}

# Process both dataframes with appropriate rank columns
models_agb_l_sets <- get_model_set(models.agb_l, rank_col = "rank")
models_agb_l_GC_sets <- get_model_set(models.agb_l_GC, rank_col = "rankSUMA")

# Find common models (same predictor sets)
common_models <- inner_join(models_agb_l_sets, models_agb_l_GC_sets, by = "model_set", suffix = c("_agb_l", "_agb_l_GC"))

# Display results
if (nrow(common_models) > 0) {
  print("Common models found with rankings:")
  print(common_models)
} else {
  print("No common models found.")
}

# Save results to a CSV file
write.csv(common_models, "common_selected_models_with_ranks.csv", row.names = FALSE)
print("Common models saved as 'common_selected_models_with_ranks.csv'.")
