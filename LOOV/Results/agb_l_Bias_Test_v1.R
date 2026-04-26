# Clear environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(lmtest)      # For hypothesis testing
library(sandwich)    # For HC3 robust variance estimation
library(ggplot2)

# Read datasets
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")
models.var.cv <- read.csv("input_models_v1.csv")  # Contains x1, x2, x3 columns

# Prepare dataset: Compute `agb_l` and replace NAs
df_filtered <- df %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF  # Sum of live components
  ) %>%
  replace(is.na(.), 0)

# Unique regions in LOCATION column
locations <- unique(df_filtered$LOCATION)

# Initialize results dataframe
results <- data.frame(
  Model_ID = integer(),
  X1 = character(),
  X2 = character(),
  X3 = character(),
  RMSE_FLIARD = numeric(),
  RMSE_FPROV = numeric(),
  RMSE_FSIMP = numeric(),
  RMSE_HAYRIV = numeric(),
  Bias_FLIARD = numeric(),
  Bias_FPROV = numeric(),
  Bias_FSIMP = numeric(),
  Bias_HAYRIV = numeric(),
  Bias_StdErr_FLIARD = numeric(),
  Bias_StdErr_FPROV = numeric(),
  Bias_StdErr_FSIMP = numeric(),
  Bias_StdErr_HAYRIV = numeric(),
  Bias_pValue_FLIARD = numeric(),
  Bias_pValue_FPROV = numeric(),
  Bias_pValue_FSIMP = numeric(),
  Bias_pValue_HAYRIV = numeric(),
  Bias_StdErr_HC3_FLIARD = numeric(),
  Bias_StdErr_HC3_FPROV = numeric(),
  Bias_StdErr_HC3_FSIMP = numeric(),
  Bias_StdErr_HC3_HAYRIV = numeric(),
  Bias_pValue_HC3_FLIARD = numeric(),
  Bias_pValue_HC3_FPROV = numeric(),
  Bias_pValue_HC3_FSIMP = numeric(),
  Bias_pValue_HC3_HAYRIV = numeric()
)

# Loop through each model in `models.var.cv`
for (i in seq_len(nrow(models.var.cv))) {
  
  # Extract predictors
  vars <- c(models.var.cv$x1[i], models.var.cv$x2[i], models.var.cv$x3[i])
  vars <- vars[!is.na(vars)]  # Remove NA predictors
  
  # Skip if no valid predictors
  if (length(vars) == 0) next
  
  # Define model formula
  formula <- as.formula(paste("agb_l ~", paste(vars, collapse = " + ")))
  
  # Initialize storage for validation results
  model_results <- list(Model_ID = i, X1 = models.var.cv$x1[i], X2 = models.var.cv$x2[i], X3 = models.var.cv$x3[i])
  
  # Loop through each region for cross-validation
  for (loc in locations) {
    
    # Split dataset: Training (excluding region) & Validation (only the region)
    train_data <- df_filtered %>% filter(LOCATION != loc)
    test_data  <- df_filtered %>% filter(LOCATION == loc)
    
    # Skip if insufficient training data
    if (nrow(train_data) < length(vars) + 1) next
    
    # Fit model on training data
    model <- tryCatch(lm(formula, data = train_data), error = function(e) NULL)
    
    # Skip if model fitting failed
    if (is.null(model)) next
    
    # Predict on validation set
    test_data$predicted_agb_l <- predict(model, newdata = test_data)
    
    # Calculate residuals (errors)
    test_data$error <- test_data$predicted_agb_l - test_data$agb_l
    
    # Compute RMSE
    model_results[[paste0("RMSE_", loc)]] <- sqrt(mean(test_data$error^2, na.rm = TRUE))
    
    # Compute Bias (Mean Error)
    bias <- mean(test_data$error, na.rm = TRUE)
    model_results[[paste0("Bias_", loc)]] <- bias
    
    # Compute Standard Error of Bias
    bias_se <- sd(test_data$error, na.rm = TRUE) / sqrt(nrow(test_data))
    model_results[[paste0("Bias_StdErr_", loc)]] <- bias_se
    
    # Perform t-test for Bias significance
    t_test <- t.test(test_data$error, mu = 0)
    model_results[[paste0("Bias_pValue_", loc)]] <- t_test$p.value
    
    # --- HC3 Robust Standard Error Calculation ---
    if (nrow(test_data) > 1) {  # Ensure enough data points
      
      # Fit model on test data (since we are validating bias)
      validation_model <- tryCatch(lm(error ~ 1, data = test_data), error = function(e) NULL)
      
      if (!is.null(validation_model)) {
        # Compute HC3 robust standard error
        hc3_results <- coeftest(validation_model, vcov = vcovHC(validation_model, type = "HC3"))
        
        # Extract HC3 Standard Error and p-value
        model_results[[paste0("Bias_StdErr_HC3_", loc)]] <- hc3_results["(Intercept)", "Std. Error"]
        model_results[[paste0("Bias_pValue_HC3_", loc)]] <- hc3_results["(Intercept)", "Pr(>|t|)"]
      }
    }
  }
  
  # Append results to the dataframe
  results <- rbind(results, model_results)
}

# Save results to CSV
write.csv(results, "Regional_CV_Results_TopBSS_HC3.csv", row.names = FALSE)

print("Regional cross-validation completed. Results saved as 'Regional_CV_Results_HC3.csv'.")
