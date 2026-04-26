### I will read data frames with all merged metrics per each year and bind rows creating one data frame for all years

library(dplyr)
library(readr)
library(stringr)


setwd("C:/X/2016")
df.lidar.all_years <- read_csv("main.df.merged.2016_v2.csv")

setwd("C:/X/2018")
df.lidar.2018 <- read_csv("main.df.merged.2018_v2.csv")
df.lidar.all_years <- bind_rows(df.lidar.all_years, df.lidar.2018)
remove(df.lidar.2018)

setwd("C:/X/2019")
df.lidar.2019 <- read_csv("main.df.merged.2019_v2.csv")
df.lidar.all_years <- bind_rows(df.lidar.all_years, df.lidar.2019)
remove(df.lidar.2019)

setwd("C:/X/2021")
df.lidar.2021 <- read_csv("main.df.merged.2021_v2.csv")
df.lidar.all_years <- bind_rows(df.lidar.all_years, df.lidar.2021)
remove(df.lidar.2021)


setwd("C:/X/results")
write.csv(df.lidar.all_years , "df.lidar.all_years_v2.csv", row.names=FALSE)

remove(df.lidar.all_years)
