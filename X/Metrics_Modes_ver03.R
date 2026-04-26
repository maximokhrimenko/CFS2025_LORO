
##### I decided to split scripts for managable chunks
#### This one is for modes. This is exploratory, sor I will count only C123 modes with 0m and 2.7m cutoffs, and will consider adding other modes later. 

#### setwd properly, at the moment manualy into years

## require library stringr (for strin manupulation in file names)

## require library LaplacesDemon for calculating Modes

## require: library(LaplacesDemon)

setwd("C:/X/2021")

lidar.year = 2021

files.list.Step6 <- list.files(path = "Step6")


### defining main.df   if you want to add metrics, add it here as well


main.df <- data.frame (
  
						plot.name = character(0),
						lidar.year = character(0), 
						
					## modes
						
						modes.C123.all.abv.0.0m.number = numeric(0),
						
					  modes.C123.all.abv.0.0m.mode1.h = numeric(0),
  					modes.C123.all.abv.0.0m.mode1.dens = numeric(0),
  					modes.C123.all.abv.0.0m.mode1.size = numeric(0),
					
  					modes.C123.all.abv.0.0m.mode2.h = numeric(0),
  					modes.C123.all.abv.0.0m.mode2.dens = numeric(0),
  					modes.C123.all.abv.0.0m.mode2.size = numeric(0),
  					
  					modes.C123.all.abv.0.0m.mode3.h = numeric(0),
  					modes.C123.all.abv.0.0m.mode3.dens = numeric(0),
  					modes.C123.all.abv.0.0m.mode3.size = numeric(0),
  					
  					modes.C123.all.abv.0.0m.mode4.h = numeric(0),
  					modes.C123.all.abv.0.0m.mode4.dens = numeric(0),
  					modes.C123.all.abv.0.0m.mode4.size = numeric(0),
  					
					
					
						modes.C123.all.abv.2.7m.number = numeric(0),
						
  					modes.C123.all.abv.2.7m.mode1.h = numeric(0),
  					modes.C123.all.abv.2.7m.mode1.dens = numeric(0),
  					modes.C123.all.abv.2.7m.mode1.size = numeric(0),	
  						
  					modes.C123.all.abv.2.7m.mode2.h = numeric(0),
  					modes.C123.all.abv.2.7m.mode2.dens = numeric(0),
  					modes.C123.all.abv.2.7m.mode2.size = numeric(0),	
  					
  					modes.C123.all.abv.2.7m.mode3.h = numeric(0),
  					modes.C123.all.abv.2.7m.mode3.dens = numeric(0),
  					modes.C123.all.abv.2.7m.mode3.size = numeric(0)	
  				
						)


library(LaplacesDemon)
library(stringr)
library(tictoc)


for (i in 1:length(files.list.Step6)) {
  
  if (i==1) {tic()} ### just a timer start

plot.Step6.tmp <- read.table(paste0("Step6\\", files.list.Step6[i]), quote="\"", comment.char="")

names(plot.Step6.tmp) <- c("X", "Y", "Z", "I", "Echo.type", "Ecno.number", "NumberOfEchos", "Line")

plot.Step6.tmp$Channel <- as.character(plot.Step6.tmp$Line %% 10)

main.df[i,]$plot.name <- str_sub(files.list.Step6[i],1,-5)

main.df[i,]$lidar.year <- lidar.year

###### Modes

  ## C123 modes with 0 cut offs. Room for 4 modes. 
  main.df[i,]$modes.C123.all.abv.0.0m.number <- length(Modes(plot.Step6.tmp$Z, min.size = 0.1)$modes)
  
  main.df[i,]$modes.C123.all.abv.0.0m.mode1.h <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$modes[1]
  main.df[i,]$modes.C123.all.abv.0.0m.mode1.dens <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$mode.dens[1]
  main.df[i,]$modes.C123.all.abv.0.0m.mode1.size <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$size[1]
  
  main.df[i,]$modes.C123.all.abv.0.0m.mode2.h <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$modes[2]
  main.df[i,]$modes.C123.all.abv.0.0m.mode2.dens <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$mode.dens[2]
  main.df[i,]$modes.C123.all.abv.0.0m.mode2.size <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$size[2]
  
  main.df[i,]$modes.C123.all.abv.0.0m.mode3.h <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$modes[3]
  main.df[i,]$modes.C123.all.abv.0.0m.mode3.dens <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$mode.dens[3]
  main.df[i,]$modes.C123.all.abv.0.0m.mode3.size <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$size[3]
  
  main.df[i,]$modes.C123.all.abv.0.0m.mode4.h <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$modes[4]
  main.df[i,]$modes.C123.all.abv.0.0m.mode4.dens <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$mode.dens[4]
  main.df[i,]$modes.C123.all.abv.0.0m.mode4.size <- Modes(plot.Step6.tmp$Z, min.size = 0.1)$size[4]
    
  ### C123 with 2.7 m cut off. Room for 3 modes
  main.df[i,]$modes.C123.all.abv.2.7m.number <- length(Modes(plot.Step6.tmp[plot.Step6.tmp$Z>2.7,]$Z, min.size = 0.1)$modes)
  
  main.df[i,]$modes.C123.all.abv.2.7m.mode1.h <- Modes(plot.Step6.tmp[plot.Step6.tmp$Z>2.7,]$Z, min.size = 0.1)$modes[1]
  main.df[i,]$modes.C123.all.abv.2.7m.mode1.dens <- Modes(plot.Step6.tmp[plot.Step6.tmp$Z>2.7,]$Z, min.size = 0.1)$mode.dens[1]
  main.df[i,]$modes.C123.all.abv.2.7m.mode1.size <- Modes(plot.Step6.tmp[plot.Step6.tmp$Z>2.7,]$Z, min.size = 0.1)$size[1]
  
  main.df[i,]$modes.C123.all.abv.2.7m.mode2.h <- Modes(plot.Step6.tmp[plot.Step6.tmp$Z>2.7,]$Z, min.size = 0.1)$modes[2]
  main.df[i,]$modes.C123.all.abv.2.7m.mode2.dens <- Modes(plot.Step6.tmp[plot.Step6.tmp$Z>2.7,]$Z, min.size = 0.1)$mode.dens[2]
  main.df[i,]$modes.C123.all.abv.2.7m.mode2.size <- Modes(plot.Step6.tmp[plot.Step6.tmp$Z>2.7,]$Z, min.size = 0.1)$size[2]
  
  main.df[i,]$modes.C123.all.abv.2.7m.mode3.h <- Modes(plot.Step6.tmp[plot.Step6.tmp$Z>2.7,]$Z, min.size = 0.1)$modes[3]
  main.df[i,]$modes.C123.all.abv.2.7m.mode3.dens <- Modes(plot.Step6.tmp[plot.Step6.tmp$Z>2.7,]$Z, min.size = 0.1)$mode.dens[3]
  main.df[i,]$modes.C123.all.abv.2.7m.mode3.size <- Modes(plot.Step6.tmp[plot.Step6.tmp$Z>2.7,]$Z, min.size = 0.1)$size[3]
  
  
 
  
  if (i==length(files.list.Step6)) {toc()} ### just a timer stop
}


write.csv(main.df, "main.df.modes.csv", row.names=FALSE)
