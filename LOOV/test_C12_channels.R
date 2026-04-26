####
#### this is for the paper to show that we ok with C12 instead of C1 and C2

rm(list = ls())

library(dplyr)
library(ggplot2)

# Load data
CFS.DF <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")

# Replace NA with 0
CFS.DF <- CFS.DF %>% replace(is.na(.), 0)

# Select relevant columns
channels <- c("C12.h.avg.all.abv.0.0m",
              "C1.h.avg.all.abv.0.0m", 
              "C2.h.avg.all.abv.0.0m", 
              "C3.h.avg.all.abv.0.0m"
)

# Compute correlation matrix
cor_matrix <- cor(CFS.DF[, channels])
print("Correlation Matrix:")
print(cor_matrix)

write.csv(round(cor_matrix, 3), "ms_h.avg.all.abv.0.0m_cor_matrix.csv")

max_C12 <- max(max(CFS.DF$C1.h.avg.all.abv.0.0m), max(CFS.DF$C2.h.avg.all.abv.0.0m))

# Function to create scatter plots with correlation coefficient and white background
plot_scatter <- function(df, x_col, y_col, color = "blue") {
  # Compute correlation coefficient
  cor_val <- cor(df[[x_col]], df[[y_col]], use = "complete.obs")
  
  # Get the maximum value from C12 for consistent axis scaling
  max_value <- max_C12
  
  ggplot(df, aes_string(x = x_col, y = y_col)) +
    geom_point(alpha = 0.7, color = color) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "darkgrey") + 
    labs(x = x_col, y = y_col) +
    theme_minimal() +
    coord_equal() +  # Ensure 1:1 aspect ratio
    scale_x_continuous(limits = c(0, max_value), expand = c(0, 0)) +
    scale_y_continuous(limits = c(0, max_value), expand = c(0, 0)) +
    # Ensure background is fully white
    theme(
      panel.background = element_rect(fill = "white", color = "white"),  # White panel
      plot.background = element_rect(fill = "white", color = "white"),   # White plot area
      panel.grid.major = element_line(color = "grey90"),  # Light grid lines
      panel.grid.minor = element_blank()  # Remove minor grid lines
    ) +
    # Add correlation annotation in the upper-left corner
    annotate("text", 
             x = 0.05 * max_value,  # Slightly offset from 0
             y = 0.95 * max_value,  # Near the top
             label = paste0("R = ", round(cor_val, 3)), 
             hjust = 0, vjust = 1, 
             size = 5, color = "black")
}


# Generate scatter plots
plot_C12_C1 <- plot_scatter(CFS.DF, "C12.h.avg.all.abv.0.0m", "C1.h.avg.all.abv.0.0m", color = "blue")
plot_C12_C2 <- plot_scatter(CFS.DF, "C12.h.avg.all.abv.0.0m", "C2.h.avg.all.abv.0.0m", color = "blue")
plot_C1_C2 <- plot_scatter(CFS.DF, "C1.h.avg.all.abv.0.0m", "C2.h.avg.all.abv.0.0m", color = "blue")

# Print plots
print(plot_C12_C1)
print(plot_C12_C2)
print(plot_C1_C2)

# Save plots
ggsave("scatter_C12_vs_C1.png", plot_C12_C1, width = 8, height = 6)
ggsave("scatter_C12_vs_C2.png", plot_C12_C2, width = 8, height = 6)
ggsave("scatter_C1_vs_C2.png", plot_C1_C2, width = 8, height = 6)




##################################################################################
#### same for sd

# Select relevant columns
channels_std <- c("C12.h.std.all.abv.0.0m",
              "C1.h.std.all.abv.0.0m", 
              "C2.h.std.all.abv.0.0m", 
              "C3.h.std.all.abv.0.0m"
)

# Compute correlation matrix
cor_matrix_std <- cor(CFS.DF[, channels_std])
print("Correlation Matrix:")
print(cor_matrix_std)

write.csv(round(cor_matrix_std, 3), "ms_h.std.all.abv.0.0m_cor_matrix.csv")

max_C12_std <- max(max(CFS.DF$C1.h.std.all.abv.0.0m), max(CFS.DF$C2.h.std.all.abv.0.0m))

# Function to create scatter plots with correlation coefficient and white background
plot_scatter <- function(df, x_col, y_col, color = "blue") {
  # Compute correlation coefficient
  cor_val <- cor(df[[x_col]], df[[y_col]], use = "complete.obs")
  
  # Get the maximum value from C12 for consistent axis scaling
  max_value <- max_C12_std
  
  ggplot(df, aes_string(x = x_col, y = y_col)) +
    geom_point(alpha = 0.7, color = color) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "darkgrey") + 
    labs(x = x_col, y = y_col) +
    theme_minimal() +
    coord_equal() +  # Ensure 1:1 aspect ratio
    scale_x_continuous(limits = c(0, max_value), expand = c(0, 0)) +
    scale_y_continuous(limits = c(0, max_value), expand = c(0, 0)) +
    # Ensure background is fully white
    theme(
      panel.background = element_rect(fill = "white", color = "white"),  # White panel
      plot.background = element_rect(fill = "white", color = "white"),   # White plot area
      panel.grid.major = element_line(color = "grey90"),  # Light grid lines
      panel.grid.minor = element_blank()  # Remove minor grid lines
    ) +
    # Add correlation annotation in the upper-left corner
    annotate("text", 
             x = 0.05 * max_value,  # Slightly offset from 0
             y = 0.95 * max_value,  # Near the top
             label = paste0("R = ", round(cor_val, 3)), 
             hjust = 0, vjust = 1, 
             size = 5, color = "black")
}


# Generate scatter plots
plot_C12_C1_std <- plot_scatter(CFS.DF, "C12.h.std.all.abv.0.0m", "C1.h.std.all.abv.0.0m", color = "blue")
plot_C12_C2_std <- plot_scatter(CFS.DF, "C12.h.std.all.abv.0.0m", "C2.h.std.all.abv.0.0m", color = "blue")
plot_C1_C2_std <- plot_scatter(CFS.DF, "C1.h.std.all.abv.0.0m", "C2.h.std.all.abv.0.0m", color = "blue")

# Print plots
print(plot_C12_C1_std)
print(plot_C12_C2_std)
print(plot_C1_C2_std)

# Save plots
ggsave("scatter_C12_vs_C1_std.png", plot_C12_C1_std, width = 8, height = 6)
ggsave("scatter_C12_vs_C2_std.png", plot_C12_C2_std, width = 8, height = 6)
ggsave("scatter_C1_vs_C2_std.png", plot_C1_C2_std, width = 8, height = 6)




# Perform a paired t-test
t_test_result <- t.test(CFS.DF$C12.h.avg.all.abv.1.0m, 
                        CFS.DF$C12.h.avg.all.abv.2.0m, 
                        paired = TRUE)

# Print the results
print(t_test_result)

cor(CFS.DF$C12.h.avg.all.abv.7.4m, 
       CFS.DF$C12.h.avg.all.abv.5.0m)


