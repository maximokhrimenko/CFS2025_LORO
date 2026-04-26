

setwd("C:/X/2019")

library(tidyverse)
library(readr)
library(stringr)


df.merged <- read_csv("main.df.csv")

df.intensities <- read_csv("main.df.intensities.csv")
df.modes <- read_csv("main.df.modes.csv")
## ver 2
df.rasters <- read_csv("main.df_rasters.csv")
df.voxels_0.5m <- read_csv("main.df_voxels_0.5m.csv")
df.voxels_1.0m <- read_csv("main.df_voxels_1.0m.csv")

df.merged <- left_join(df.merged, df.intensities, by = c("plot.name", "lidar.year"))
df.merged <- left_join(df.merged, df.modes, by = c("plot.name", "lidar.year"))
## not for 2021
df.merged <- left_join(df.merged, df.rasters, by = c("plot.name", "lidar.year"))
df.merged <- left_join(df.merged, df.voxels_0.5m, by = c("plot.name", "lidar.year"))
df.merged <- left_join(df.merged, df.voxels_1.0m, by = c("plot.name", "lidar.year"))


## dont forget to change file name    !!!!!
write.csv(df.merged , "main.df.merged.2019.csv", row.names=FALSE)
