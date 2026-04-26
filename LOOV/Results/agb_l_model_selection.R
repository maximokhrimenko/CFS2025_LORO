### this is to select models

### the ides is to find min values of % LORO rmse, bias magnitude, max(validation rmse) and max(validation abs(bias)
### then add 2% and chose only models in the window from min+2%

rm(list = ls())

setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

library(dplyr)

df.agb_l <- read.csv("df.agb_l.csv")


### Step 2: Find the baseline values (min values for criteria)
baseline_rmse <- min(df.agb_l$X.rmse.LORO, na.rm = TRUE)
baseline_bias <- min(df.agb_l$X.bias.magnitude.LORO, na.rm = TRUE)

baseline_regional_rmse <- min(df.agb_l$X.rmse.regional.max, na.rm = TRUE)
baseline_regional_bias <- min(df.agb_l$X.bias.regional.max, na.rm = TRUE)

### Step 3: Define selection thresholds (min + 2%)
rmse_threshold <- baseline_rmse + 2.0
bias_threshold <- baseline_bias + 2.0

regional_rmse_threshold <- baseline_regional_rmse + 2.6
regional_bias_threshold <- baseline_regional_bias + 2.0

### Step 4: Print baseline and threshold values
cat("Baseline and Threshold Values:\n")
cat("Baseline %rmse.LORO:", baseline_rmse, "\n")
cat("Baseline %bias.magnitude.LORO:", baseline_bias, "\n")
cat("Baseline %rmse.regional.max:", baseline_regional_rmse, "\n")
cat("Baseline %bias.regional.max:", baseline_regional_bias, "\n\n")

cat("Threshold %rmse.LORO (min + 3%):", rmse_threshold, "\n")
cat("Threshold %bias.magnitude.LORO (min + 3%):", bias_threshold, "\n")
cat("Threshold %rmse.regional.max (min + 3%):", regional_rmse_threshold, "\n")
cat("Threshold %bias.regional.max (min + 3%):", regional_bias_threshold, "\n")


### Step 4: Filter models within the thresholds
selected_models <- df.agb_l %>%
  filter(
    X.rmse.LORO <= rmse_threshold,
    X.bias.magnitude.LORO <= bias_threshold,
    X.rmse.regional.max <= regional_rmse_threshold,
    X.bias.regional.max <= regional_bias_threshold
  )

### Step 5: Save or inspect the selected models
write.csv(selected_models, "selected_models_agb_l.csv", row.names = FALSE)

print("Selected models saved to 'selected_models_agb_l.csv'")

