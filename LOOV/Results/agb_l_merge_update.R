###
#### this is to update our tables for Live Large

rm(list = ls())

setwd("LOOV/Results")

library(dplyr)



df_Linear <- read.csv("2025.LOOV.agb_l.Linear.v6.csv")
df_loglog <- read.csv("2025.LOOV.agb_l.LogLog.v7.csv")

df.agb_l <- rbind(df_Linear, df_loglog)


## remove initial ranking
df.agb_l <- df.agb_l %>% select(-X, -model.number)

## rename LOOV into LORO
df.agb_l <- df.agb_l %>%
  rename(
    rmse.LORO = rmse.LOOV,
    bias.LORO = bias.LOOV,
    bias.magnitude.LORO = bias.abs.LOOV,
    score.LORO = LOOV.score
  )


# Calculate max.VIF and replace NA with 0
df.agb_l <- df.agb_l %>%
  mutate( 
    max.VIF = pmax(VIF1, VIF2, VIF3, na.rm = TRUE), # Calculate maximum
    max.VIF = ifelse(is.na(max.VIF), 0, max.VIF)    # Replace NA with 0
  )

df.agb_l <- df.agb_l %>% filter(max.VIF < 10) # Remove rows with max.VIF >= 10

# Define mean AGB values for each region
mean_AGB <- list(
  FLIARD = 168.9,
  FPROV = 84.5,
  FSIMP = 153.3,
  HAYRIV = 128.9
)


# Calculate %rmse and %bias for each region
df.agb_l <- df.agb_l %>%
  mutate(
    `%rmse.FPROV` = rmse.FPROV / mean_AGB$FPROV * 100,
    `%bias.FPROV` = bias.FPROV / mean_AGB$FPROV * 100,
    `%rmse.FLIARD` = rmse.FLIARD / mean_AGB$FLIARD * 100,
    `%bias.FLIARD` = bias.FLIARD / mean_AGB$FLIARD * 100,
    `%rmse.FSIMP` = rmse.FSIMP / mean_AGB$FSIMP * 100,
    `%bias.FSIMP` = bias.FSIMP / mean_AGB$FSIMP * 100,
    `%rmse.HAYRIV` = rmse.HAYRIV / mean_AGB$HAYRIV * 100,
    `%bias.HAYRIV` = bias.HAYRIV / mean_AGB$HAYRIV * 100,
    
    # Calculate LORO metrics
    `%rmse.LORO` = (`%rmse.FPROV` + `%rmse.FLIARD` + `%rmse.FSIMP` + `%rmse.HAYRIV`) / 4,
    `%bias.LORO` = (`%bias.FPROV` + `%bias.FLIARD` + `%bias.FSIMP` + `%bias.HAYRIV`) / 4,
    `%bias.magnitude.LORO` = (abs(`%bias.FPROV`) + abs(`%bias.FLIARD`) + abs(`%bias.FSIMP`) + abs(`%bias.HAYRIV`)) / 4,
    
    # Calculate %score.LORO as the sum of %rmse.LORO, abs(%bias.LORO), and %bias.magnitude.LORO
    `%score.LORO` = `%rmse.LORO` + abs(`%bias.LORO`) + `%bias.magnitude.LORO`
  )



# Calculate maximum %rmse.regional.max and %bias.regional.max using absolute values for bias
df.agb_l <- df.agb_l %>%
  mutate(
    `%rmse.regional.max` = pmax(`%rmse.FLIARD`, `%rmse.FPROV`, `%rmse.FSIMP`, `%rmse.HAYRIV`, na.rm = TRUE),
    `%bias.regional.max` = pmax(abs(`%bias.FLIARD`), abs(`%bias.FPROV`), abs(`%bias.FSIMP`), abs(`%bias.HAYRIV`), na.rm = TRUE)
  )





# Create new columns for ranks
df.agb_l <- df.agb_l %>%
  mutate(
    rank.rmse = rank(rmse, ties.method = "min"),
    rank.rmse.LORO = rank(rmse.LORO, ties.method = "min"),
    rank.bias.LORO = rank(abs(bias.LORO), ties.method = "min"),
    rank.bias.magnitude.LORO = rank(bias.magnitude.LORO, ties.method = "min"),
    rank.score.LORO = rank(score.LORO, ties.method = "min")
  )



write.csv(df.agb_l, "df.agb_l.csv", row.names = FALSE)






