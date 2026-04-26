### "Voxel metics" - volume with cuts

#### setwd properly, at the moment manualy into years

### set path to Step5 for Voxels with 0.5m sides

## require library stringr (for strin manupulation in file names)

## require library tictoc for timing code



setwd("C:/X/2019")

lidar.year = 2019

files.list.Step5 <- list.files(path = "Step5_1m")

### defining main.df   if you want to add metrics, add it here as well

main.df <- data.frame (
  
						plot.name = character(0),
						lidar.year = character(0), 
						
					## Voxel volumes at 1m voxels
						
						VoxVolAt1m.0.0m = numeric(0), 	### total area
						VoxVolAt1m.20.0m = numeric(0), 	### area of a cross-section at 20.0 m
						VoxVolAt1m.7.4m = numeric(0),		### area of a cross-section at 7.4 m	
						VoxVolAt1m.5.0m = numeric(0),
						VoxVolAt1m.2.7m = numeric(0),
						VoxVolAt1m.2.0m = numeric(0),
						VoxVolAt1m.1.0m = numeric(0)
						
						)

library(tictoc)
library(stringr)

for (i in 1:length(files.list.Step5)) {
  
  if (i==1) {tic()} ### just a timer start

plot.Step5.tmp <- read.table(paste0("Step5_1m\\", files.list.Step5[i]), quote="\"", comment.char="", sep = " ")

names(plot.Step5.tmp) <- c("X", "Y", "Z")

## plot.Step5.tmp$Channel <- as.character(plot.Step5.tmp$Line %% 10)

main.df[i,]$plot.name <- str_sub(files.list.Step5[i],1,-11)

main.df[i,]$lidar.year <- lidar.year

###### Voxel Volume

  main.df[i,]$VoxVolAt1m.0.0m <- nrow(plot.Step5.tmp)
  main.df[i,]$VoxVolAt1m.20.0m <- nrow(plot.Step5.tmp[plot.Step5.tmp$Z > 20.0,])
  main.df[i,]$VoxVolAt1m.7.4m <- nrow(plot.Step5.tmp[plot.Step5.tmp$Z > 7.4,])
  main.df[i,]$VoxVolAt1m.5.0m <- nrow(plot.Step5.tmp[plot.Step5.tmp$Z > 5.0,])
  main.df[i,]$VoxVolAt1m.2.7m <- nrow(plot.Step5.tmp[plot.Step5.tmp$Z > 2.7,])
  main.df[i,]$VoxVolAt1m.2.0m <- nrow(plot.Step5.tmp[plot.Step5.tmp$Z > 2.0,])
  main.df[i,]$VoxVolAt1m.1.0m <- nrow(plot.Step5.tmp[plot.Step5.tmp$Z > 1.0,])
  

  
  
  if (i==length(files.list.Step6)) {toc()} ### just a timer stop
}


write.csv(main.df, "main.df_voxels_1.0m.csv", row.names=FALSE)
