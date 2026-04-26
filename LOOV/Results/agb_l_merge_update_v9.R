###
#### this is to update our tables for Live Large

rm(list = ls())

setwd("LOOV/Results")

library(dplyr)
library(tidyverse)

# Read the main data and models variable file
df <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")
# Filter the desired columns and calculate agb_l and agb_lad
df_filtered <- df %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF,  # Sum of live and small live components
    agb_lad = Large_LS + Large_DS + Large_LF + Small_LS + Small_DS + Small_LF # Includes dead components
  )

# Calculate mean agb_l for each region in the LOCATION column
mean_AGB <- df_filtered %>%
  group_by(LOCATION) %>%  # Group by LOCATION
  summarise(mean_agb_l = mean(agb_l, na.rm = TRUE))  # Calculate mean agb_l, ignoring NA values

# Convert the result to a named list
mean_AGB_list <- mean_AGB %>%
  deframe()  # Convert the grouped result into a named list



df_Linear <- read.csv("2025.LOOV.agb_l.Linear.v8.csv")
df_loglog <- read.csv("2025.LOOV.agb_l.LogLog.v8.csv")
df_Sqrt <- read.csv("2025.LOOV.agb_l.Sqrt.v9.csv")

df.agb_l <- rbind(df_Linear, df_loglog, df_Sqrt)


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


df.agb_l <- df.agb_l %>%
  mutate(
    n.rmse.FPROV = rmse.FPROV / mean_AGB_list["FPROV"] * 100,
    n.bias.FPROV = bias.FPROV / mean_AGB_list["FPROV"] * 100,
    n.rmse.FLIARD = rmse.FLIARD / mean_AGB_list["FLIARD"] * 100,
    n.bias.FLIARD = bias.FLIARD / mean_AGB_list["FLIARD"] * 100,
    n.rmse.FSIMP = rmse.FSIMP / mean_AGB_list["FSIMP"] * 100,
    n.bias.FSIMP = bias.FSIMP / mean_AGB_list["FSIMP"] * 100,
    n.rmse.HAYRIV = rmse.HAYRIV / mean_AGB_list["HAYRIV"] * 100,
    n.bias.HAYRIV = bias.HAYRIV / mean_AGB_list["HAYRIV"] * 100,
    
    # Calculate LORO metrics
    n.rmse.LORO = (n.rmse.FPROV + n.rmse.FLIARD + n.rmse.FSIMP + n.rmse.HAYRIV) / 4,
    n.bias.LORO = (n.bias.FPROV + n.bias.FLIARD + n.bias.FSIMP + n.bias.HAYRIV) / 4,
    n.bias.magnitude.LORO = (abs(n.bias.FPROV) + abs(n.bias.FLIARD) + abs(n.bias.FSIMP) + abs(n.bias.HAYRIV)) / 4,
    
    # Calculate %score.LORO
    n.score.LORO = n.rmse.LORO + abs(n.bias.LORO) + n.bias.magnitude.LORO
  )




# Calculate maximum %rmse.regional.max and %bias.regional.max using absolute values for bias
df.agb_l <- df.agb_l %>%
  mutate(
    n.rmse.regional.max = pmax(n.rmse.FLIARD, n.rmse.FPROV, n.rmse.FSIMP, n.rmse.HAYRIV, na.rm = TRUE),
    n.bias.regional.max = pmax(abs(n.bias.FLIARD), abs(n.bias.FPROV), abs(n.bias.FSIMP), abs(n.bias.HAYRIV), na.rm = TRUE)
  )



# Create new columns for ranks
df.agb_l <- df.agb_l %>%
  mutate(
    rank.rmse = rank(rmse, ties.method = "min"),
    rank.n.rmse.LORO = rank(n.rmse.LORO, ties.method = "min"),
    rank.n.bias.magnitude.LORO = rank(n.bias.magnitude.LORO, ties.method = "min"),
    rank.n.rmse.regional.max = rank(n.rmse.regional.max, ties.method = "min"),
    rank.n.bias.regional.max = rank(n.bias.regional.max, ties.method = "min")
  )



write.csv(df.agb_l, "df.agb_l_v3.csv", row.names = FALSE)






