###
#### this is to update our tables for Live Large

rm(list = ls())

setwd("LOOV/Results")

library(dplyr)



df_Linear <- read.csv("2025.LOOV.agb_lad.Linear.v8.csv")
df_loglog <- read.csv("2025.LOOV.agb_lad.LogLog.v8.csv")

df.agb_lad <- rbind(df_Linear, df_loglog)


## remove initial ranking
df.agb_lad <- df.agb_lad %>% select(-X, -model.number)

## rename LOOV into LORO
df.agb_lad <- df.agb_lad %>%
  rename(
    rmse.LORO = rmse.LOOV,
    bias.LORO = bias.LOOV,
    bias.magnitude.LORO = bias.abs.LOOV,
    score.LORO = LOOV.score
  )


# Calculate max.VIF and replace NA with 0
df.agb_lad <- df.agb_lad %>%
  mutate( 
    max.VIF = pmax(VIF1, VIF2, VIF3, na.rm = TRUE), # Calculate maximum
    max.VIF = ifelse(is.na(max.VIF), 0, max.VIF)    # Replace NA with 0
  )

df.agb_lad <- df.agb_lad %>% filter(max.VIF < 10) # Remove rows with max.VIF >= 10

# Define mean AGB values for each region
mean_AGB <- list(
  FLIARD = 168.9,
  FPROV = 84.5,
  FSIMP = 153.3,
  HAYRIV = 128.9
)


# Calculate %rmse and %bias for each region
df.agb_lad <- df.agb_lad %>%
  mutate(
    n.rmse.FPROV = rmse.FPROV / mean_AGB$FPROV * 100,
    n.bias.FPROV = bias.FPROV / mean_AGB$FPROV * 100,
    n.rmse.FLIARD = rmse.FLIARD / mean_AGB$FLIARD * 100,
    n.bias.FLIARD = bias.FLIARD / mean_AGB$FLIARD * 100,
    n.rmse.FSIMP = rmse.FSIMP / mean_AGB$FSIMP * 100,
    n.bias.FSIMP = bias.FSIMP / mean_AGB$FSIMP * 100,
    n.rmse.HAYRIV = rmse.HAYRIV / mean_AGB$HAYRIV * 100,
    n.bias.HAYRIV = bias.HAYRIV / mean_AGB$HAYRIV * 100,
    
    # Calculate LORO metrics
    n.rmse.LORO = (n.rmse.FPROV + n.rmse.FLIARD + n.rmse.FSIMP + n.rmse.HAYRIV) / 4,
    n.bias.LORO = (n.bias.FPROV + n.bias.FLIARD + n.bias.FSIMP + n.bias.HAYRIV) / 4,
    n.bias.magnitude.LORO = (abs(n.bias.FPROV) + abs(n.bias.FLIARD) + abs(n.bias.FSIMP) + abs(n.bias.HAYRIV)) / 4,
    
    # Calculate %score.LORO as the sum of %rmse.LORO, abs(%bias.LORO), and %bias.magnitude.LORO
    n.score.LORO = n.rmse.LORO + abs(n.bias.LORO) + n.bias.magnitude.LORO
  )



# Calculate maximum %rmse.regional.max and %bias.regional.max using absolute values for bias
df.agb_lad <- df.agb_lad %>%
  mutate(
    n.rmse.regional.max = pmax(n.rmse.FLIARD, n.rmse.FPROV, n.rmse.FSIMP, n.rmse.HAYRIV, na.rm = TRUE),
    n.bias.regional.max = pmax(abs(n.bias.FLIARD), abs(n.bias.FPROV), abs(n.bias.FSIMP), abs(n.bias.HAYRIV), na.rm = TRUE)
  )



# Create new columns for ranks
df.agb_lad <- df.agb_lad %>%
  mutate(
    rank.rmse = rank(rmse, ties.method = "min"),
    rank.n.rmse.LORO = rank(n.rmse.LORO, ties.method = "min"),
    rank.n.bias.magnitude.LORO = rank(n.bias.magnitude.LORO, ties.method = "min"),
    rank.n.rmse.regional.max = rank(n.rmse.regional.max, ties.method = "min"),
    rank.n.bias.regional.max = rank(n.bias.regional.max, ties.method = "min")
  )



write.csv(df.agb_lad, "df.agb_lad.csv", row.names = FALSE)






