# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(ggplot2)
library(pls)     # For PLS regression
library(caret)   # For cross-validation

# Read the main data and metrics list
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")
metrics_list <- read.csv("MetricsList_C2.v6.txt", header = FALSE, col.names = c("metric"))

# Filter and prepare the dataset
df_filtered <- df %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF,  # Sum of live and small live components
    agb_lad = Large_LS + Large_DS + Large_LF + Small_LS + Small_DS + Small_LF # Includes dead components
  ) %>%
  select(plot.name, lidar.year, LOCATION, agb_l, all_of(metrics_list$metric)) %>%
  replace(is.na(.), 0) # Replace NA with 0

# Set up cross-validation parameters
set.seed(42)
folds <- createFolds(df_filtered$agb_l, k = 4, list = TRUE, returnTrain = TRUE)

# Prepare storage for cross-validation results
cv_results <- data.frame(
  n_components = integer(),
  RMSE = numeric(),
  R2 = numeric()
)

# Define the predictors explicitly
predictors <- metrics_list$metric

# Loop through 1 to 10 components for PLS
max_components <- min(30, length(predictors)) # Limit components to the number of predictors
for (n_comp in 1:max_components) {
  fold_rmse <- c()
  fold_r2 <- c()
  
  for (fold in folds) {
    # Split the data into training and testing sets
    train_data <- df_filtered[fold, c("agb_l", predictors)]
    test_data <- df_filtered[-fold, c("agb_l", predictors)]
    
    # Ensure the column names in training and testing match exactly
    train_data <- train_data[, colnames(test_data)]
    
    # Fit the PLS model with the specified number of components
    pls_model <- plsr(agb_l ~ ., data = train_data, ncomp = n_comp, validation = "none")
    
    # Make predictions on the test set
    predictions <- predict(pls_model, newdata = test_data[, predictors], ncomp = n_comp) %>% as.vector()
    
    # Calculate RMSE and R2 for this fold
    rmse <- sqrt(mean((test_data$agb_l - predictions)^2))
    r2 <- cor(test_data$agb_l, predictions)^2
    
    fold_rmse <- c(fold_rmse, rmse)
    fold_r2 <- c(fold_r2, r2)
  }
  
  # Store the mean RMSE and R2 for this number of components
  cv_results <- cv_results %>%
    add_row(
      n_components = n_comp,
      RMSE = mean(fold_rmse),
      R2 = mean(fold_r2)
    )
}

# Find the optimal number of components
optimal_components <- cv_results %>% filter(RMSE == min(RMSE)) %>% pull(n_components)

# Fit the final PLS model with the optimal number of components
final_pls_model <- plsr(agb_l ~ ., data = df_filtered[, c("agb_l", predictors)], 
                        ncomp = optimal_components, validation = "none")

# Fit the single-component full model
full_model_1comp <- plsr(agb_l ~ ., data = df_filtered[, c("agb_l", predictors)], 
                         ncomp = 1, validation = "none")

# Calculate \( R^2 \) and RMSE for the full single-component model
pred_full_model_1comp <- predict(full_model_1comp, newdata = df_filtered[, predictors], ncomp = 1) %>% as.vector()
r2_full_1comp <- cor(df_filtered$agb_l, pred_full_model_1comp)^2
rmse_full_1comp <- sqrt(mean((df_filtered$agb_l - pred_full_model_1comp)^2))

# Save summaries of both models
summary_file <- "PLS_Model_Summary_agb_l.txt"
capture.output(
  {
    cat("Optimal Number of Components:", optimal_components, "\n\n")
    summary(final_pls_model)
    cat("\nFull Model (1 Component) Summary:\n")
    summary(full_model_1comp)
    cat("\nFull Model (1 Component) Metrics:\n")
    cat("R-squared:", r2_full_1comp, "\n")
    cat("RMSE:", rmse_full_1comp, "\n")
  },
  file = summary_file
)

# Add predictions to the dataframe for the final model
df_filtered <- df_filtered %>%
  mutate(predictions_optimal = predict(final_pls_model, newdata = df_filtered[, predictors], 
                                       ncomp = optimal_components) %>% as.vector(),
         predictions_1comp = pred_full_model_1comp)

# Plot predicted vs observed for the optimal model
plot_optimal <- ggplot(df_filtered, aes(x = agb_l, y = predictions_optimal, color = LOCATION)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") +
  labs(
    title = paste0(
      "PLS Regression: Predicted vs Observed (Optimal: ", optimal_components, " Components)\n",
      "R2 = ", round(cor(df_filtered$agb_l, df_filtered$predictions_optimal)^2, 3),
      ", RMSE = ", round(sqrt(mean((df_filtered$agb_l - df_filtered$predictions_optimal)^2)), 3)
    ),
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

# Save the optimal components plot
ggsave(filename = "PLS_Model_Predicted_vs_Observed_Optimal_agb_l.png", plot = plot_optimal, width = 8, height = 6)

# Plot predicted vs observed for the single-component full model
plot_1comp <- ggplot(df_filtered, aes(x = agb_l, y = predictions_1comp, color = LOCATION)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") +
  labs(
    title = paste0(
      "PLS Regression: Predicted vs Observed (1 Component)\n",
      "R2 = ", round(r2_full_1comp, 3),
      ", RMSE = ", round(rmse_full_1comp, 3)
    ),
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

# Save the single-component plot
ggsave(filename = "PLS_Model_Predicted_vs_Observed_1Component_agb_l.png", plot = plot_1comp, width = 8, height = 6)

# Save cross-validation results
write.csv(cv_results, "PLS_CrossValidation_Results_agb_l.csv", row.names = FALSE)

print("PLS modeling completed. Results and plots saved.")
