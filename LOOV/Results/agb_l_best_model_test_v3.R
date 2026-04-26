# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the main data and models variable file
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")
models.var.cv <- read.csv("selected_models_agb_l.csv") # Contains x1, x2, x3 columns for variable combinations

# Create a folder to save plots and summaries if it doesn't exist
if (!dir.exists("models_l")) {
  dir.create("models_l")
}

# Filter the desired columns
df_filtered <- df %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF,  # Sum of live and small live components
    agb_lad = Large_LS + Large_DS + Large_LF + Small_LS + Small_DS + Small_LF # Includes dead components
  ) %>%
  replace(is.na(.), 0) # Replace NA with 0

# Loop through each row in the models.var.cv file to fit and plot models
for (i in 1:nrow(models.var.cv)) {
  # Extract variable names from the current row
  vars <- models.var.cv[i, c("x1", "x2", "x3")] %>% unlist() %>% na.omit()
  
  # Create a formula for the current model
  formula <- as.formula(paste("agb_l ~", paste(vars, collapse = " + ")))
  
  # Fit the linear model
  model <- lm(formula, data = df_filtered)
  summary_model <- summary(model)
  
  # Calculate residuals
  df_filtered <- df_filtered %>%
    mutate(residuals = agb_l - predict(model))
  
  # Identify the 25th percentile lowest observed agb_lad
  agb_10th_percentile <- quantile(df_filtered$agb_lad, probs = 0.10, na.rm = TRUE)
  
  # Subset the data for the lowest 25th percentile
  df_low_10th <- df_filtered %>% filter(agb_lad <= agb_10th_percentile)
  
  # Perform a t-test on residuals for the lowest 25th percentile
  t_test_results <- t.test(df_low_10th$residuals, mu = 0, alternative = "two.sided")
  
  # Save the model summary and t-test results into a text file
  summary_file_path <- file.path("models_l", paste0("Model_", i, ".txt"))
  capture.output(
    {
      cat("Model Summary:\n")
      print(summary_model)
      cat("\nResiduals T-Test (10th Percentile Lowest agb_lad):\n")
      print(t_test_results)
    },
    file = summary_file_path
  )
  
  # Add predictions to the dataframe
  df_filtered <- df_filtered %>%
    mutate(predictions = predict(model))
  
  # Create a plot for the current model
  plot <- ggplot(df_filtered, aes(x = agb_l, y = predictions, color = LOCATION)) +
    geom_point(size = 3, alpha = 0.7) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") + # Line y = x
    labs(
      title = paste("Linear:", paste(vars, collapse = " + "), "(#", i, ")"),
      x = "Observed agb_l",
      y = "Predicted agb_l",
      color = "Location"
    ) +
    theme_minimal() +
    theme(
      panel.background = element_rect(fill = "white", color = "black"),  # White panel background
      plot.background = element_rect(fill = "white", color = NA),       # White plot background
      panel.grid.major = element_line(color = "gray90"),                # Light gridlines
      panel.grid.minor = element_blank()                                # Remove minor gridlines
    ) +
    coord_equal() +  # Ensure 1:1 scaling on x and y axes
    scale_x_continuous(limits = c(0, 450), expand = c(0, 0)) +  # Force x-axis to start at 0
    scale_y_continuous(limits = c(0, 450), expand = c(0, 0))    # Force y-axis to start at 0
  
  # Save the plot in the "models" folder
  ggsave(filename = paste0("models_l/model_", i, ".png"), plot = plot, width = 8, height = 6)
}

print("Plots and summaries saved for all models in the 'models_lad' folder.")
