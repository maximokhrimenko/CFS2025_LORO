rm(list = ls())

setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

library(dplyr)

df.agb_l <- read.csv("df.agb_l.csv")

### Step 2: Find the baseline values (min values for criteria)
baseline_rmse <- min(df.agb_l$n.rmse.LORO, na.rm = TRUE)
baseline_bias <- min(df.agb_l$n.bias.magnitude.LORO, na.rm = TRUE)
baseline_regional_rmse <- min(df.agb_l$n.rmse.regional.max, na.rm = TRUE)
baseline_regional_bias <- min(df.agb_l$n.bias.regional.max, na.rm = TRUE)

### Step 3: Define selection thresholds (min + 2% or 3%)
rmse_threshold <- baseline_rmse + 2.0
bias_threshold <- baseline_bias + 2.0
regional_rmse_threshold <- baseline_regional_rmse + 3.0
regional_bias_threshold <- baseline_regional_bias + 2.0

### Step 4: Save baseline and threshold values to a text file
threshold_file <- "selected_models_agb_l_baselines_and_thresholds.txt"
capture.output({
  cat("Baseline and Threshold Values:\n")
  cat("Baseline %rmse.LORO:", baseline_rmse, "\n")
  cat("Baseline %bias.magnitude.LORO:", baseline_bias, "\n")
  cat("Baseline %rmse.regional.max:", baseline_regional_rmse, "\n")
  cat("Baseline %bias.regional.max:", baseline_regional_bias, "\n\n")
  cat("Threshold %rmse.LORO (min + 2%):", rmse_threshold, "\n")
  cat("Threshold %bias.magnitude.LORO (min + 2%):", bias_threshold, "\n")
  cat("Threshold %rmse.regional.max (min + 3%):", regional_rmse_threshold, "\n")
  cat("Threshold %bias.regional.max (min + 2%):", regional_bias_threshold, "\n")
}, file = threshold_file)
message("Baselines and thresholds saved to: ", threshold_file)

### Step 5: Filter models within the thresholds
selected_models <- df.agb_l %>%
  filter(
    n.rmse.LORO <= rmse_threshold,
    n.bias.magnitude.LORO <= bias_threshold,
    n.rmse.regional.max <= regional_rmse_threshold,
    n.bias.regional.max <= regional_bias_threshold
  )

### Step 6: Add rank column based on n.score.LORO
selected_models <- selected_models %>%
  mutate(rank = rank(n.score.LORO, ties.method = "min")) %>%
  arrange(rank)  # Arrange rows by rank in ascending order

### Step 7: Save filtered models with rank
filtered_models_file <- "selected_models_agb_l.csv"
write.csv(selected_models, filtered_models_file, row.names = FALSE)
message("Selected models with ranks saved to: ", filtered_models_file)
