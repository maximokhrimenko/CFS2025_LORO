
#### this code is to update wrong metrics (height with first returns)
####  in ald DF: CFS.DF.Unique.v3.csv
#### from new DF: combined.df.FR.csv    Note, the combined has all years. 

library(dplyr)


CFS.DF.Unique.v3 <- read.csv("D:/MyR_projects/CFS2025_LORO/CFS.DF.Unique.v3.csv")
combined.df.FR <- read.csv("D:/MyR_projects/CFS2025_LORO/combined.df.FR.csv")


library(dplyr)

# Ensure matching key column types
CFS.DF.Unique.v3$plot.name <- as.character(CFS.DF.Unique.v3$plot.name)
CFS.DF.Unique.v3$lidar.year <- as.numeric(CFS.DF.Unique.v3$lidar.year)

combined.df.FR$plot.name <- as.character(combined.df.FR$plot.name)
combined.df.FR$lidar.year <- as.numeric(combined.df.FR$lidar.year)

# a) Filter rows in combined.df.FR based on matching keys in CFS.DF.Unique.v3
filtered_combined <- combined.df.FR %>%
  semi_join(CFS.DF.Unique.v3, by = c("plot.name", "lidar.year"))

# b) Remove columns from CFS.DF.Unique.v3 that are in combined.df.FR, except key columns
key_columns <- c("plot.name", "lidar.year")
columns_to_remove <- setdiff(names(filtered_combined), key_columns)

CFS.DF.Unique.v3_cleaned <- CFS.DF.Unique.v3 %>%
  select(-all_of(columns_to_remove))

# c) Join the cleaned first df with the filtered second df
CFS.DF.Unique.v4 <- CFS.DF.Unique.v3_cleaned %>%
  left_join(filtered_combined, by = key_columns)

# Remove specific columns
CFS.DF.Unique.v4 <- CFS.DF.Unique.v4 %>%
  select(-X.2, -X.1, -X)

write.csv(CFS.DF.Unique.v4, "CFS.DF.Unique.v4_Jan2025v1.csv", row.names = F)


#### test
detach(CFS.DF.Unique.v3_cleaned)
detach(CFS.DF.Unique.v3)
attach(CFS.DF.Unique.v4)

plot(C1.h.avg.all.abv.2.0m, C1.h.avg.first.abv.2.0m)
