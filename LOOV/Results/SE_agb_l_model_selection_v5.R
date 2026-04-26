####
### this is to select models based on |bias| < 1*SErobust

rm(list = ls())

setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")


# Load necessary libraries
library(dplyr)

# Read data
df.agb_l <- read.csv("df.agb_l.csv")

# Define number of plots per location
n_plots <- data.frame(
  LOCATION = c("FPROV", "FLIARD", "FSIMP", "HAYRIV"),
  n = c(43, 47, 34, 39)
)

# Compute SE_robust using sqrt(n) for each location
df.agb_l <- df.agb_l %>%
  mutate(
    n.SE_robust.FPROV = n.rmse.FPROV / sqrt(n_plots$n[n_plots$LOCATION == "FPROV"]),
    n.SE_robust.FLIARD = n.rmse.FLIARD / sqrt(n_plots$n[n_plots$LOCATION == "FLIARD"]),
    n.SE_robust.FSIMP = n.rmse.FSIMP / sqrt(n_plots$n[n_plots$LOCATION == "FSIMP"]),
    n.SE_robust.HAYRIV = n.rmse.HAYRIV / sqrt(n_plots$n[n_plots$LOCATION == "HAYRIV"])
  )

# Filter rows based on the condition |bias| < 1 * SE_robust
df_filtered <- df.agb_l %>%
  filter(
    abs(n.bias.FPROV) < n.SE_robust.FPROV,
    abs(n.bias.FLIARD) < n.SE_robust.FLIARD,
    abs(n.bias.FSIMP) < n.SE_robust.FSIMP,
    abs(n.bias.HAYRIV) < n.SE_robust.HAYRIV
  )

# Remove "ms" rows if an identical "C2" row exists
df_filtered <- df_filtered %>%
  group_by(across(-Metrics_input)) %>%  # Group by all columns except Metrics_input
  filter(!(Metrics_input == "ms" & "C2" %in% Metrics_input)) %>%
  ungroup()

# Create r.rmse column (100 * rmse / 135.4546) and place it after rmse
df_filtered <- df_filtered %>%
  mutate(r.rmse = 100 * rmse / 135.4546) %>%
  relocate(r.rmse, .after = rmse)

# Rank observations based on n.rmse.LORO (low to high)
df_filtered <- df_filtered %>%
  mutate(final.rank.n.rmse.LORO = rank(n.rmse.LORO, ties.method = "min"))

# Save the filtered and modified data
write.csv(df_filtered, "Filtered_Models_1SE_v2.csv", row.names = FALSE)

# Print the first few rows of the final dataset
print(head(df_filtered))

