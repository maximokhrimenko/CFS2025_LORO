# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the main data and models variable file
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")
models.var.cv <- read.csv("Filtered_Models_1SE_v8.csv") # Contains x1, x2, x3, model_form

# Sort the dataframe based on final.rank.n.rmse.LORO (ascending order)
models.var.cv <- models.var.cv %>% arrange(final.rank.n.rmse.LORO)

# Create a folder to save plots and summaries if it doesn't exist
out_dir <- "models_l_1SE_rev"
if (!dir.exists(out_dir)) dir.create(out_dir)

# Filter the desired columns and calculate agb_l and agb_lad
df_filtered <- df %>%
  mutate(
    agb_l  = Large_LS + Large_LF + Small_LS + Small_LF,
    agb_lad = Large_LS + Large_DS + Large_LF + Small_LS + Small_DS + Small_LF
  ) %>%
  replace(is.na(.), 0) # keep your NA -> 0 rule

# Create an empty dataframe to store t-test results
t_test_summary <- data.frame(
  model_id = integer(),
  mean_residuals = numeric(),
  p_value = numeric(),
  agb_10th_percentile_mean = numeric(),
  stringsAsFactors = FALSE
)

# Loop through each row in the models.var.cv file to fit and plot models
for (i in 1:nrow(models.var.cv)) {
  # Extract variable names and model form from the current row
  vars <- models.var.cv[i, c("x1", "x2", "x3")] %>% unlist() %>% na.omit() %>% as.character()
  model_form_raw <- models.var.cv$model_form[i]
  model_form <- tolower(model_form_raw)  # case-insensitive matching
  
  # Check if variables exist
  if (length(vars) == 0) {
    cat("Skipping model", i, "- no variables defined.\n")
    next
  }
  
  # Verify variables are present in df_filtered
  missing_vars <- vars[!vars %in% colnames(df_filtered)]
  if (length(missing_vars) > 0) {
    cat("Skipping model", i, "- missing variables:", paste(missing_vars, collapse = ", "), "\n")
    next
  }
  
  # Build formula and fit the model
  if (model_form == "loglog") {
    # Create log-transformed predictors as needed
    for (var in vars) {
      log_var <- paste0(var, "_log")
      if (!log_var %in% colnames(df_filtered)) {
        df_filtered[[log_var]] <- log(df_filtered[[var]])
      }
    }
    # Create log response if needed
    if (!"log_agb_l" %in% colnames(df_filtered)) {
      df_filtered$log_agb_l <- log(df_filtered$agb_l)
    }
    log_vars <- paste0(vars, "_log")
    formula <- as.formula(paste("log_agb_l ~", paste(log_vars, collapse = " + ")))
    
    model <- lm(formula, data = df_filtered)
    sm <- summary(model)
    
    # Predictions in AGB units with multiplicative bias correction
    df_filtered$log_predictions <- predict(model)
    df_filtered$predictions <- exp(df_filtered$log_predictions) * exp(0.5 * sm$sigma^2)
    df_filtered$residuals <- df_filtered$agb_l - df_filtered$predictions
    
  } else if (model_form == "linear") {
    formula <- as.formula(paste("agb_l ~", paste(vars, collapse = " + ")))
    
    model <- lm(formula, data = df_filtered)
    # Predictions in AGB units (linear)
    df_filtered$predictions <- predict(model)
    df_filtered$residuals <- df_filtered$agb_l - df_filtered$predictions
    
  } else if (model_form == "sqrt") {  # <-- NEW third model form
    # Response on sqrt scale; predictors raw
    if (!"sqrt_agb_l" %in% colnames(df_filtered)) {
      df_filtered$sqrt_agb_l <- sqrt(df_filtered$agb_l)
    }
    formula <- as.formula(paste("sqrt_agb_l ~", paste(vars, collapse = " + ")))
    
    model <- lm(formula, data = df_filtered)
    sm <- summary(model)
    
    # Predictions back-transformed to AGB units with parametric correction
    df_filtered$sqrt_predictions <- predict(model)        # ŷ_* on sqrt scale
    df_filtered$predictions <- (df_filtered$sqrt_predictions^2) + (sm$sigma^2)
    df_filtered$residuals <- df_filtered$agb_l - df_filtered$predictions
    
  } else {
    cat("Unknown model form for row", i, "(", model_form_raw, ") - skipping.\n")
    next
  }
  
  # Identify the 10th percentile lowest observed agb_l
  agb_10th_percentile <- quantile(df_filtered$agb_l, probs = 0.10, na.rm = TRUE)
  df_low_10th <- df_filtered %>% filter(agb_l <= agb_10th_percentile)
  
  # Compute mean value of agb_10th_percentile subset
  agb_10th_percentile_mean <- mean(df_low_10th$agb_l, na.rm = TRUE)
  
  # Perform a t-test on residuals for the lowest 10th percentile
  t_test_results <- t.test(df_low_10th$residuals, mu = 0, alternative = "two.sided")
  
  # Store t-test results
  t_test_summary <- rbind(
    t_test_summary,
    data.frame(
      model_id = i,
      mean_residuals = unname(t_test_results$estimate),  # mean of residuals in the low 10%
      p_value = t_test_results$p.value,
      agb_10th_percentile_mean = agb_10th_percentile_mean
    )
  )
  
  # Save the model summary and t-test results into a text file
  summary_file_path <- file.path(out_dir, paste0("Model_", i, ".txt"))
  capture.output(
    {
      cat("Model form:", model_form_raw, "\n")
      cat("Variables:", paste(vars, collapse = " + "), "\n\n")
      cat("Model Summary:\n")
      print(summary(model))
      cat("\nResiduals T-Test (lowest 10% of observed agb_l):\n")
      print(t_test_results)
    },
    file = summary_file_path
  )
  
  # Create the plot (Predicted vs Observed) in AGB units
  plot <- ggplot(df_filtered, aes(x = agb_l, y = predictions, color = LOCATION)) +
    geom_point(size = 3, alpha = 0.7) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") +
    labs(
      title = paste(model_form_raw, ":", paste(vars, collapse = " + "), "(#", i, ")"),
      x = "Observed agb_l",
      y = "Predicted agb_l",
      color = "Location"
    ) +
    theme_minimal() +
    theme(
      panel.background = element_rect(fill = "white", color = "black"),
      plot.background = element_rect(fill = "white", color = NA),
      panel.grid.major = element_line(color = "gray90"),
      panel.grid.minor = element_blank()
    ) +
    coord_equal() +
    scale_x_continuous(limits = c(0, 450), expand = c(0, 0)) +
    scale_y_continuous(limits = c(0, 450), expand = c(0, 0))
  
  # Save the plot
  ggsave(filename = file.path(out_dir, paste0("model_", i, ".png")), plot = plot, width = 8, height = 6)
}

# Save t-test results to a CSV file
write.csv(t_test_summary, "t_test_results_1SE_v8.csv", row.names = FALSE)

# Join the two dataframes based on final.rank.n.rmse.LORO = model_id
models_var_cv_joined <- models.var.cv %>%
  left_join(t_test_summary, by = c("final.rank.n.rmse.LORO" = "model_id"))

# Add the new column: 1 if p-value > 0.05, else 0
models_var_cv_joined <- models_var_cv_joined %>%
  mutate(low.ttest.passed = ifelse(p_value > 0.05, 1, 0))

# Save the merged dataframe to a new CSV
write.csv(models_var_cv_joined, "Filtered_Models_1SE_ttest_v8.csv", row.names = FALSE)
