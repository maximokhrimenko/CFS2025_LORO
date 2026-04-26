###
#### this is to update our tables for Live Large

library(dplyr)

df_LiveLarge <- read.csv("D:/MyR_projects/CFS2025_LORO/LiveLarge_AGB.models_03Dec2022_VIFcleaned.csv")

# Define the updated pattern for filtering
pattern <- "h\\..*first\\..*(1\\.0m|2\\.0m|2\\.7m|5\\.0m|7\\.4m|20\\.0m)(Sqrt)?$"

# Remove rows that match the pattern
df_LiveLarge <- df_LiveLarge %>%
  filter(
    rowSums(sapply(select(., x1, x2, x3), function(col) grepl(pattern, col))) == 0
  )

## remove initial ranking
df_LiveLarge <- df_LiveLarge %>% select(-X, -model.number)

## rename LOOV into LORO
df_LiveLarge <- df_LiveLarge %>%
  rename(
    rmse.LORO = rmse.LOOV,
    bias.LORO = bias.LOOV,
    bias.magnitude.LORO = bias.abs.LOOV,
    score.LORO = LOOV.score
  )

### old bias was not divided by 4
df_LiveLarge <- df_LiveLarge %>%
  mutate(bias.LORO = bias.LORO / 4)

# Recalculate score.LORO
df_LiveLarge <- df_LiveLarge %>%
  mutate(score.LORO = rmse.LORO + abs(bias.LORO) + bias.magnitude.LORO)

# Create new columns for ranks
df_LiveLarge <- df_LiveLarge %>%
  mutate(
    rank.rmse = rank(rmse, ties.method = "min"),
    rank.rmse.LORO = rank(rmse.LORO, ties.method = "min"),
    rank.bias.LORO = rank(abs(bias.LORO), ties.method = "min"),
    rank.bias.magnitude.LORO = rank(bias.magnitude.LORO, ties.method = "min"),
    rank.score.LORO = rank(score.LORO, ties.method = "min")
  )



# Calculate max.VIF and replace NA with 0
df_LiveLarge <- df_LiveLarge %>%
  mutate(
    max.VIF = pmax(VIF1, VIF2, VIF3, na.rm = TRUE), # Calculate maximum
    max.VIF = ifelse(is.na(max.VIF), 0, max.VIF)    # Replace NA with 0
  )

# Define mean AGB values for each region
mean_AGB <- list(
  FLIARD = 168.9,
  FPROV = 84.5,
  FSIMP = 153.3,
  HAYRIV = 128.9
)


# Calculate %rmse and %bias for each region
df_LiveLarge <- df_LiveLarge %>%
  mutate(
    `%rmse.FPROV` = rmse.FPROV / mean_AGB$FPROV * 100,
    `%bias.FPROV` = bias.FPROV / mean_AGB$FPROV * 100,
    `%rmse.FLIARD` = rmse.FLIARD / mean_AGB$FLIARD * 100,
    `%bias.FLIARD` = bias.FLIARD / mean_AGB$FLIARD * 100,
    `%rmse.FSIMP` = rmse.FSIMP / mean_AGB$FSIMP * 100,
    `%bias.FSIMP` = bias.FSIMP / mean_AGB$FSIMP * 100,
    `%rmse.HAYRIV` = rmse.HAYRIV / mean_AGB$HAYRIV * 100,
    `%bias.HAYRIV` = bias.HAYRIV / mean_AGB$HAYRIV * 100
  )

# Calculate %rmse.regional.max and %bias.regional.max using absolute values for bias
df_LiveLarge <- df_LiveLarge %>%
  mutate(
    `%rmse.regional.max` = pmax(`%rmse.FLIARD`, `%rmse.FPROV`, `%rmse.FSIMP`, `%rmse.HAYRIV`, na.rm = TRUE),
    `%bias.regional.max` = pmax(abs(`%bias.FLIARD`), abs(`%bias.FPROV`), abs(`%bias.FSIMP`), abs(`%bias.HAYRIV`), na.rm = TRUE)
  )



# Filter rows where Metrics_input is "C1", "C2", or "C12"
df_LiveLarge_C1C2C12 <- df_LiveLarge %>%
  filter(Metrics_input %in% c("C1,C2,C12"))


write.csv(df_LiveLarge_C1C2C12, "df_LiveLarge_C1C2C12.csv", row.names = FALSE)
write.csv(df_LiveLarge, "df_LiveLarge.csv", row.names = FALSE)


