
### this is to test top BSS models for regional bias

# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(lmtest)      # For hypothesis testing
library(sandwich)    # For HC3 robust variance estimation
library(tidyverse)

# Read the main data and models variable file
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")
models.var.cv <- read.csv("input_models_v1.csv") # Contains x1, x2, x3 columns for variable combinations

# Filter the desired columns and calculate agb_l
df_filtered <- df %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF  # Sum of live and small live components
  ) %>%
  replace(is.na(.), 0) # Replace NA with 0

# Define unique locations for cross-validation
locations <- unique(df_filtered$LOCATION)

# Compute mean AGB overall and per location
mean_agb_all <- mean(df_filtered$agb_l, na.rm = TRUE)
mean_agb_by_region <- df_filtered %>%
  group_by(LOCATION) %>%
  summarize(mean_agb = mean(agb_l, na.rm = TRUE)) %>%
  pull(mean_agb)
names(mean_agb_by_region) <- locations

# Initialize an empty list to store results
results_list <- list()

# --- Loop through each model ---
for (i in seq_len(nrow(models.var.cv))) {
  
  # Extract predictors
  vars <- c(models.var.cv$x1[i], models.var.cv$x2[i], models.var.cv$x3[i])
  vars <- vars[!is.na(vars)]  # Remove NA predictors
  
  # Skip if no valid predictors
  if (length(vars) == 0) next
  
  # Define model formula
  formula <- as.formula(paste("agb_l ~", paste(vars, collapse = " + ")))
  
  # Initialize a result list with NA values
  model_results <- data.frame(
    Model_ID = i,
    Metrics_input = models.var.cv$Metrics_input[i],
    model_form = models.var.cv$model_form[i],
    rank.rmse = models.var.cv$rank.rmse[i],  # Keep rank.rmse
    rank.n.rmse.LORO = models.var.cv$rank.n.rmse.LORO[i],  # Keep rank.n.rmse.LORO
    max.VIF = models.var.cv$max.VIF[i], #keep max.VIF
    X1 = models.var.cv$x1[i],
    X2 = models.var.cv$x2[i],
    X3 = models.var.cv$x3[i],
    RMSE_input_percent = (models.var.cv$rmse[i] / mean_agb_all) * 100
  )
  
  # --- Loop through each region for cross-validation ---
  for (loc in locations) {
    
    # Split data into training and validation
    train_data <- df_filtered %>% filter(LOCATION != loc)
    test_data  <- df_filtered %>% filter(LOCATION == loc)
    
    # Skip if not enough data for training
    if (nrow(train_data) < length(vars) + 1 || nrow(test_data) == 0) next
    
    # Fit linear model
    model <- tryCatch(lm(formula, data = train_data), error = function(e) NULL)
    if (is.null(model)) next
    
    # Predict and compute errors
    test_data$predicted_agb_l <- predict(model, newdata = test_data)
    test_data$error <- test_data$predicted_agb_l - test_data$agb_l
    
    # RMSE
    rmse <- sqrt(mean(test_data$error^2, na.rm = TRUE))
    model_results[[paste0("RMSE_", loc, "_percent")]] <- (rmse / mean_agb_by_region[loc]) * 100
    
    # Bias and Standard Error
    bias <- mean(test_data$error, na.rm = TRUE)
    bias_se <- sd(test_data$error, na.rm = TRUE) / sqrt(nrow(test_data))
    
    model_results[[paste0("Bias_", loc, "_percent")]] <- (bias / mean_agb_by_region[loc]) * 100
    model_results[[paste0("Bias_StdErr_", loc, "_percent")]] <- (bias_se / mean_agb_by_region[loc]) * 100
    model_results[[paste0("Bias_pValue_", loc)]] <- t.test(test_data$error, mu = 0)$p.value
    
    # HC3 Robust Standard Error
    if (nrow(test_data) > 1) {
      validation_model <- tryCatch(lm(error ~ 1, data = test_data), error = function(e) NULL)
      if (!is.null(validation_model)) {
        hc3_results <- coeftest(validation_model, vcov = vcovHC(validation_model, type = "HC3"))
        model_results[[paste0("Bias_StdErr_HC3_", loc, "_percent")]] <- 
          (hc3_results["(Intercept)", "Std. Error"] / mean_agb_by_region[loc]) * 100
        model_results[[paste0("Bias_pValue_HC3_", loc)]] <- hc3_results["(Intercept)", "Pr(>|t|)"]
      }
    }
    
    # Robust SE
    robust_se <- (rmse / sqrt(nrow(test_data))) / mean_agb_by_region[loc] * 100
    model_results[[paste0("RobustSE_", loc, "_percent")]] <- robust_se
    
    # 1SE Test: "Pass" if Bias is within ± Robust SE
    model_results[[paste0("1SE_Test_", loc)]] <- ifelse(
      abs(model_results[[paste0("Bias_", loc, "_percent")]]) <= robust_se,
      "Pass", "Fail"
    )
  }
  
  # Append to results list
  results_list[[i]] <- model_results
}

# Combine results safely
results <- bind_rows(results_list)

# Save results to CSV
write.csv(results, "Regional_CV_TopBSS_HC3_1SE_Percent_v3.csv", row.names = FALSE)

print("Regional cross-validation completed. Results saved as 'Regional_CV_Results_HC3_1SE_Percent.csv'.")
