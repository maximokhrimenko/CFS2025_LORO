# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the main data
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")

# Create a folder to save plots and summaries if it doesn't exist
if (!dir.exists("models_l_C3")) {
  dir.create("models_l_C3")
}

	

# Define predictors for the single linear model
predictors <- c("C3.h.p25.all.abv.0.0m", "C2.iz2.all.abv.0.0mSqrt")

# Check if predictors exist in the dataset
missing_vars <- setdiff(predictors, colnames(df))
if (length(missing_vars) > 0) {
  stop("Missing variables in dataset: ", paste(missing_vars, collapse = ", "))
}

# Prepare data by calculating agb_l (live components sum) and replacing NA values
df_filtered <- df %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF  # Sum of live components
  ) %>%
  replace(is.na(.), 0) # Replace NA with 0

# Create formula for the linear model
formula <- as.formula(paste("agb_l ~", paste(predictors, collapse = " + ")))

# Fit the linear model
model <- lm(formula, data = df_filtered)
summary_model <- summary(model)

# Compute predictions and residuals
df_filtered <- df_filtered %>%
  mutate(
    predictions = predict(model),
    residuals = agb_l - predictions
  )

# Identify the 10th percentile lowest observed agb_l
agb_10th_percentile <- quantile(df_filtered$agb_l, probs = 0.10, na.rm = TRUE)
df_low_10th <- df_filtered %>% filter(agb_l <= agb_10th_percentile)

# Perform a t-test on residuals for the lowest 10th percentile
t_test_results <- t.test(df_low_10th$residuals, mu = 0, alternative = "two.sided")

# Save the model summary and t-test results into a text file
summary_file_path <- file.path("models_l_C3", "Single_Model.txt")
capture.output(
  {
    cat("Model Summary:\n")
    print(summary_model)
    cat("\nResiduals T-Test (10th Percentile Lowest agb_l):\n")
    print(t_test_results)
  },
  file = summary_file_path
)

# Create scatter plot of observed vs predicted values
plot <- ggplot(df_filtered, aes(x = agb_l, y = predictions, color = LOCATION)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") + # Line y = x
  labs(
    title = paste("Linear Model: ", paste(predictors, collapse = " + ")),
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

# Save the plot
ggsave(filename = "models_l_C3/Single_Model.png", plot = plot, width = 8, height = 6)

print("Single model summary and plot saved in the 'models_l' folder.")



# Define the variable for the histogram
hist_var <- "C1.h.p25.all.abv.0.0m"

# Create histogram
hist_plot <- ggplot(df_filtered, aes(x = .data[[hist_var]])) +
  geom_histogram(binwidth = 0.1, fill = "darkblue", color = "black", alpha = 0.7) +
  labs(
    title = paste("Histogram of", hist_var),
    x = hist_var,
    y = "Frequency"
  ) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "white", color = "black"),  # White panel background
    plot.background = element_rect(fill = "white", color = NA),       # White plot background
    panel.grid.major = element_line(color = "gray90"),                # Light gridlines
    panel.grid.minor = element_blank()                                # Remove minor gridlines
  )

hist_plot

# Save the histogram plot
hist_filename <- "models_l_C3/Histogram_C1_h_p25_all_abv_0_0m.png"
ggsave(filename = hist_filename, plot = hist_plot, width = 8, height = 6, dpi = 300)