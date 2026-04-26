#### 
### extract best BSS and LORO models per modality for Guillermo

# Clear the environment and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load necessary libraries
library(dplyr)
library(ggplot2)

# Read the main data and models variable file
df_5k <- read.csv("df.agb_l.csv")

df_61 <- read.csv("Filtered_Models_1SE.csv")

# Helper function to count non-NA predictors
get_nvars <- function(df) {
  df %>%
    mutate(nvars = rowSums(!is.na(select(., x1, x2, x3))))
}

# Step 1: Annotate modality
df_5k <- df_5k %>%
  get_nvars() %>%
  mutate(modality = paste(Metrics_input, model_form, nvars, sep = "_"))

df_61 <- df_61 %>%
  get_nvars() %>%
  mutate(modality = paste(Metrics_input, model_form, nvars, sep = "_"))

# Step 2: Best models from df_5k based on lowest RMSE per modality
best_bss_5k <- df_5k %>%
  group_by(modality) %>%
  slice_min(order_by = rmse, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  mutate(selection = "Best_BSS")

# Step 3: Best models from df_5k based on lowest n.rmse.LORO
best_loro_5k <- df_5k %>%
  group_by(modality) %>%
  slice_min(order_by = n.rmse.LORO, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  mutate(selection = "Best_LORO_5k")

# Step 4: Best models from df_61 based on lowest n.rmse.LORO
best_loro_61 <- df_61 %>%
  group_by(modality) %>%
  slice_min(order_by = n.rmse.LORO, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  mutate(selection = "Best_LORO_61")

# Step 5: Make sure every modality from 5k is represented in LORO_61 (fill with NA if missing)
all_modalities <- unique(c(best_bss_5k$modality, best_loro_5k$modality))
best_loro_61_full <- data.frame(modality = all_modalities) %>%
  left_join(best_loro_61, by = "modality")

# Step 6: Combine all into one table
combined_table <- bind_rows(best_bss_5k, best_loro_5k, best_loro_61_full) %>%
  arrange(modality, selection)

# Reorder columns: modality and selection come first
combined_table <- combined_table %>%
  select(modality, selection, everything())

# Step 7: Export tables
write.csv(best_bss_5k, "Best_BSS_per_Modality.csv", row.names = FALSE)
write.csv(best_loro_5k, "Best_LORO_5k_per_Modality.csv", row.names = FALSE)
write.csv(best_loro_61_full, "Best_LORO_61_per_Modality.csv", row.names = FALSE)
write.csv(combined_table, "Combined_Best_Models_per_Modality.csv", row.names = FALSE)


