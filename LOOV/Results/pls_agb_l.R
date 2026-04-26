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
max_components <- min(10, length(predictors)) # Limit components to the number of predictors
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

# Save summary of the final model
summary_file <- "PLS_Model_Summary_agb_l.txt"
capture.output(
  {
    cat("Optimal Number of Components:", optimal_components, "\n\n")
    summary(final_pls_model)
  },
  file = summary_file
)

# Add predictions to the dataframe
df_filtered <- df_filtered %>%
  mutate(predictions = predict(final_pls_model, newdata = df_filtered[, predictors], 
                               ncomp = optimal_components) %>% as.vector())

# Plot predicted vs observed
plot <- ggplot(df_filtered, aes(x = agb_l, y = predictions, color = LOCATION)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") +
  labs(
    title = paste("PLS Regression: Predicted vs Observed (", optimal_components, " Components)", sep = ""),
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
ggsave(filename = "PLS_Model_Predicted_vs_Observed_agb_l.png", plot = plot, width = 8, height = 6)

# Save cross-validation results
write.csv(cv_results, "PLS_CrossValidation_Results_agb_l.csv", row.names = FALSE)

print("PLS modeling completed. Results saved.")
