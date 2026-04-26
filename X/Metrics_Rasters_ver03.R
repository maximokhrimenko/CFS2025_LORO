### "Raster metics" - volume under the CHM, and area slices

#### setwd properly, at the moment manualy into years

### set path to Step4

## require library stringr (for strin manupulation in file names)



setwd("C:/X/2019")

lidar.year = 2019

files.list.Step4 <- list.files(path = "Step4")

### defining main.df   if you want to add metrics, add it here as well

main.df <- data.frame (
  
						plot.name = character(0),
						lidar.year = character(0), 
						
					## Area
						
						area.0.0m = numeric(0), 	### total area
						area.20.0m = numeric(0), 	### area of a cross-section at 20.0 m
						area.7.4m = numeric(0),		### area of a cross-section at 7.4 m	
						area.5.0m = numeric(0),
						area.2.7m = numeric(0),
						area.2.0m = numeric(0),
						area.1.0m = numeric(0),
						
						
						
					## Volume under CHM
						
						volume.0.0m = numeric(0), 	### total volume under CHM
						volume.20.0m = numeric(0), 	### volume under a 20.0 m cut off
						volume.7.4m = numeric(0),	### volume under a 7.4 m cut off
						volume.5.0m = numeric(0),
						volume.2.7m = numeric(0),
						volume.2.0m = numeric(0),
						volume.1.0m = numeric(0),
						
					## Volume under CHM^2
						
						qvol.0.0m = numeric(0), 	### total volume under CHM^2
						qvol.20.0m = numeric(0), 	### volume under CHM^2 under a 20.0 m cut off
						qvol.7.4m = numeric(0),		### volume under CHM^2 under a 7.4 m cut off
						qvol.5.0m = numeric(0),
						qvol.2.7m = numeric(0),
						qvol.2.0m = numeric(0),
						qvol.1.0m = numeric(0)
					
						)

library(tictoc)
library(stringr)

for (i in 1:length(files.list.Step4)) {
  
  if (i==1) {tic()} ### just a timer start

plot.Step4.tmp <- read.table(paste0("Step4\\", files.list.Step4[i]), quote="\"", comment.char="", sep = ",")

names(plot.Step4.tmp) <- c("X", "Y", "Z")

## plot.Step4.tmp$Channel <- as.character(plot.Step4.tmp$Line %% 10)

main.df[i,]$plot.name <- str_sub(files.list.Step4[i],1,-12)

main.df[i,]$lidar.year <- lidar.year

###### Area

  main.df[i,]$area.0.0m <- nrow(plot.Step4.tmp)
  main.df[i,]$area.20.0m <- nrow(plot.Step4.tmp[plot.Step4.tmp$Z > 20.0,])
  main.df[i,]$area.7.4m <- nrow(plot.Step4.tmp[plot.Step4.tmp$Z > 7.4,])
  main.df[i,]$area.5.0m <- nrow(plot.Step4.tmp[plot.Step4.tmp$Z > 5.0,])
  main.df[i,]$area.2.7m <- nrow(plot.Step4.tmp[plot.Step4.tmp$Z > 2.7,])
  main.df[i,]$area.2.0m <- nrow(plot.Step4.tmp[plot.Step4.tmp$Z > 2.0,])
  main.df[i,]$area.1.0m <- nrow(plot.Step4.tmp[plot.Step4.tmp$Z > 1.0,])
  
###### Volume under CHM

  main.df[i,]$volume.0.0m <- sum(plot.Step4.tmp$Z)
  main.df[i,]$volume.20.0m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 20.0,]$Z)
  main.df[i,]$volume.7.4m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 7.4,]$Z)
  main.df[i,]$volume.5.0m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 5.0,]$Z)
  main.df[i,]$volume.2.7m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 2.7,]$Z)
  main.df[i,]$volume.2.0m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 2.0,]$Z)
  main.df[i,]$volume.1.0m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 1.0,]$Z)
  
###### Volume under CHM^2

  main.df[i,]$qvol.0.0m <- sum(plot.Step4.tmp$Z^2)
  main.df[i,]$qvol.20.0m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 20.0,]$Z^2)
  main.df[i,]$qvol.7.4m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 7.4,]$Z^2)
  main.df[i,]$qvol.5.0m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 5.0,]$Z^2)
  main.df[i,]$qvol.2.7m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 2.7,]$Z^2)
  main.df[i,]$qvol.2.0m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 2.0,]$Z^2)
  main.df[i,]$qvol.1.0m <- sum(plot.Step4.tmp[plot.Step4.tmp$Z > 1.0,]$Z^2)  
  
  
  if (i==length(files.list.Step6)) {toc()} ### just a timer stop
}


write.csv(main.df, "main.df_rasters.csv", row.names=FALSE)
