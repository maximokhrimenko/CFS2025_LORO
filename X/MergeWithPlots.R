### merging with PlotCalculations from CFS. Note in the code, which version of the CSV we are using.

### I will read Field Data, and rbine Lidar Data from the right, so each plot would have multiple lidar years

library(dplyr)
library(readr)
library(stringr)

setwd("C:/X/PlotsFromCFS")
CFS.all_years <- read_csv("MVI_PlotCalculations_corrected_ver03.csv")

setwd("C:/X/results")
df.lidar.all_years <- read_csv("df.lidar.all_years_v2.csv")

CFS.all_years <- inner_join(CFS.all_years, df.lidar.all_years, by = "plot.name")

remove(df.lidar.all_years)

write.csv(CFS.all_years , "CFS.all_years_v2.csv", row.names=FALSE)

remove(CFS.all_years)

## for correlation Filter(is.numeric, x)
