# Clear environment
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load libraries
library(dplyr)
library(sandwich)  # For robust standard errors
library(lmtest)    # Hypothesis testing
library(tidyr)     # Handling missing values

# Read main dataset
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")

# Compute agb_l and replace NA values with 0
df_filtered <- df %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF
  ) %>%
  replace(is.na(.), 0)  # Replace NA with 0

# Read models variable file
models_var_cv <- read.csv("Filtered_Models_1SE_ttest_v2.csv")

# Ensure required columns exist
required_cols <- c("model_form", "x1", "x2", "x3")
missing_cols <- setdiff(required_cols, names(models_var_cv))
if (length(missing_cols) > 0) {
  stop(paste("Error: Missing columns in models_var_cv:", paste(missing_cols, collapse = ", ")))
}

# Sort models based on RMSE ranking
models_var_cv <- models_var_cv %>%
  arrange(final.rank.n.rmse.LORO)

# Explicitly create **only** the required columns (NO dynamic column creation)
models_var_cv <- models_var_cv %>%
  mutate(
    coef_intercept = NA_real_, StEr_HC3_intercept = NA_real_, p_value_intercept = NA_real_,
    coef_x1 = NA_real_, StEr_HC3_x1 = NA_real_, p_value_x1 = NA_real_,
    coef_x2 = NA_real_, StEr_HC3_x2 = NA_real_, p_value_x2 = NA_real_,
    coef_x3 = NA_real_, StEr_HC3_x3 = NA_real_, p_value_x3 = NA_real_
  )

# Loop through each model row
for (i in seq_len(nrow(models_var_cv))) {
  
  # Skip if model is not "linear"
  if (tolower(models_var_cv$model_form[i]) != "linear") next
  
  # Extract **only** x1, x2, x3
  vars <- c(models_var_cv$x1[i], models_var_cv$x2[i], models_var_cv$x3[i])
  vars <- vars[!is.na(vars)]  # Remove NAs
  
  # Ensure at least one predictor exists
  if (length(vars) == 0) next
  
  # Define formula dynamically
  formula <- as.formula(paste("agb_l ~", paste(vars, collapse = " + ")))
  
  # Fit model safely (skip errors)
  model <- tryCatch(lm(formula, data = df_filtered), error = function(e) NULL)
  
  # Skip if model fitting failed
  if (is.null(model)) next
  
  # Compute robust standard errors (HC3)
  hc3_results <- coeftest(model, vcov = vcovHC(model, type = "HC3"))
  
  # Store Intercept results (if present)
  if ("(Intercept)" %in% rownames(hc3_results)) {
    models_var_cv$coef_intercept[i] <- hc3_results["(Intercept)", "Estimate"]
    models_var_cv$StEr_HC3_intercept[i] <- hc3_results["(Intercept)", "Std. Error"]
    models_var_cv$p_value_intercept[i] <- hc3_results["(Intercept)", "Pr(>|t|)"]
  }
  
  # Store results only for x1, x2, x3
  for (j in seq_along(vars)) {
    var_name <- vars[j]
    if (var_name %in% rownames(hc3_results)) {
      models_var_cv[i, paste0("coef_x", j)] <- hc3_results[var_name, "Estimate"]
      models_var_cv[i, paste0("StEr_HC3_x", j)] <- hc3_results[var_name, "Std. Error"]
      models_var_cv[i, paste0("p_value_x", j)] <- hc3_results[var_name, "Pr(>|t|)"]
    }
  }
}

# Save updated dataframe
write.csv(models_var_cv, "Filtered_Models_1SE_ttest_HC3.csv", row.names = FALSE)

print("Updated table saved as 'Filtered_Models_1SE_ttest_HC3.csv'.")
