### this is to test top BSS models for regional bias

# Clear the environment and working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(lmtest)      # For hypothesis testing
library(sandwich)    # For HC3 robust variance estimation
library(tidyverse)
library(boot)


# Read the main data and models variable file
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")
models.var.cv <- read.csv("input_models_v1.csv") # Contains x1, x2, x3 columns

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
  if (length(vars) == 0) next
  
  # Define model formula
  formula <- as.formula(paste("agb_l ~", paste(vars, collapse = " + ")))
  
  # Initialize a result data.frame
  model_results <- data.frame(
    Model_ID = i,
    Metrics_input = models.var.cv$Metrics_input[i],
    model_form = models.var.cv$model_form[i],
    rank.rmse = models.var.cv$rank.rmse[i],
    rank.n.rmse.LORO = models.var.cv$rank.n.rmse.LORO[i],
    max.VIF = models.var.cv$max.VIF[i],
    X1 = models.var.cv$x1[i],
    X2 = models.var.cv$x2[i],
    X3 = models.var.cv$x3[i],
    RMSE_input_percent = (models.var.cv$rmse[i] / mean_agb_all) * 100
  )
  
  # --- Loop through each region for cross-validation ---
  for (loc in locations) {
    
    # Split data
    train_data <- df_filtered %>% filter(LOCATION != loc)
    test_data  <- df_filtered %>% filter(LOCATION == loc)
    if (nrow(train_data) < length(vars) + 1 || nrow(test_data) < 3) next
    
    # Fit model and predict
    model <- tryCatch(lm(formula, data = train_data), error = function(e) NULL)
    if (is.null(model)) next
    test_data$predicted_agb_l <- predict(model, newdata = test_data)
    test_data$error <- test_data$predicted_agb_l - test_data$agb_l
    
    # RMSE and Bias
    rmse <- sqrt(mean(test_data$error^2, na.rm = TRUE))
    bias <- mean(test_data$error, na.rm = TRUE)
    bias_se <- sd(test_data$error, na.rm = TRUE) / sqrt(nrow(test_data))
    
    # Store performance metrics
    model_results[[paste0("RMSE_", loc, "_percent")]]        <- (rmse / mean_agb_by_region[loc]) * 100
    model_results[[paste0("Bias_", loc, "_percent")]]        <- (bias / mean_agb_by_region[loc]) * 100
    model_results[[paste0("Bias_StdErr_", loc, "_percent")]] <- (bias_se / mean_agb_by_region[loc]) * 100
    
    # Classic one‐sample t-test
    model_results[[paste0("Bias_pValue_", loc)]] <- t.test(test_data$error, mu = 0)$p.value
    
    # HC3 robust t-test
    validation_model <- lm(error ~ 1, data = test_data)
    hc3_results <- coeftest(validation_model,
                            vcov = vcovHC(validation_model, type = "HC3"))
    model_results[[paste0("Bias_StdErr_HC3_", loc, "_percent")]] <-
      (hc3_results["(Intercept)", "Std. Error"] / mean_agb_by_region[loc]) * 100
    model_results[[paste0("Bias_pValue_HC3_", loc)]]       <- hc3_results["(Intercept)", "Pr(>|t|)"]
    
    # Robust SE heuristic and 1SE pass/fail
    robust_se <- (rmse / sqrt(nrow(test_data))) / mean_agb_by_region[loc] * 100
    model_results[[paste0("RobustSE_", loc, "_percent")]] <- robust_se
    model_results[[paste0("1SE_Test_", loc)]] <- ifelse(
      abs(model_results[[paste0("Bias_", loc, "_percent")]]) <= robust_se,
      "Pass", "Fail"
    )
    
    # ───────── Shapiro–Wilk Normality Test ─────────
    # only valid when 3 ≤ n ≤ 5000
    sw <- shapiro.test(test_data$error)
    model_results[[paste0("ShapiroW_", loc, "_W")]]    <- sw$statistic
    model_results[[paste0("ShapiroW_", loc, "_p")]]    <- sw$p.value
    
    # Wilcoxon signed‐rank (nonparametric) test
    wt <- wilcox.test(test_data$error, mu = 0)
    model_results[[paste0("Wilcox_statistic_", loc)]] <- wt$statistic
    model_results[[paste0("Wilcox_pValue_", loc)]]    <- wt$p.value
    
    # ───────── Hodges–Lehmann CI for Median (Wilcoxon) ─────────
    # 3) Hodges–Lehmann CI for the median (nonparametric CI)
    wt_ci <- wilcox.test(
      test_data$error,
      mu       = 0,
      conf.int = TRUE,
      conf.level = 0.95
    )
    
    # if conf.int exists, extract it; otherwise set to NA
    if (!is.null(wt_ci$conf.int)) {
      hl_ci_low  <- wt_ci$conf.int[1]
      hl_ci_high <- wt_ci$conf.int[2]
    } else {
      hl_ci_low  <- NA
      hl_ci_high <- NA
    }
    
    model_results[[paste0("Bias_HLmedian_CI_low_",  loc, "_percent")]]  <-
      hl_ci_low  / mean_agb_by_region[loc] * 100
    model_results[[paste0("Bias_HLmedian_CI_high_", loc, "_percent")]]  <-
      hl_ci_high / mean_agb_by_region[loc] * 100
    
    # ───────── Bootstrap CI & p‐value for the Mean ─────────
    # (requires library(boot) up front)
    set.seed(123)  # for reproducibility
    
    # 1) define statistic
    boot_mean <- function(d, i) mean(d[i])
    
    # 2) run bootstrap once (e.g. R = 2000)
    b <- boot::boot(test_data$error, statistic = boot_mean, R = 2000)
    
    # 3) percentile CI
    ci_perc <- boot::boot.ci(b, type = "perc")$percent[4:5]
    model_results[[paste0("Bias_bootMean_CI_low_",  loc, "_percent")]] <-
      ci_perc[1] / mean_agb_by_region[loc] * 100
    model_results[[paste0("Bias_bootMean_CI_high_", loc, "_percent")]] <-
      ci_perc[2] / mean_agb_by_region[loc] * 100
    
    # 4) empirical p‐value: proportion of bootstrap means as extreme as observed
    boot_means <- b$t
    obs_mean   <- mean(test_data$error)
    p_val_boot <- mean(abs(boot_means) >= abs(obs_mean))
    model_results[[paste0("Boot_pValue_", loc)]] <- p_val_boot
  }
  
  # Append results
  results_list[[i]] <- model_results
}

# Combine and save
results <- bind_rows(results_list)
write.csv(results, "Regional_CV_TopBSS_HC3_1SE_Shapiro_Percent_v5.csv", row.names = FALSE)

print("Regional cross-validation (with Shapiro–Wilk) completed.")
