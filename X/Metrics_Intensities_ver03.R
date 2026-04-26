
##### I decided to split scripts for managable chunks

#### This one is intensities and Z*I. The Z*I is exploratory - I*Z and I*Z^2 for C1 and C2 with cut offs. May be, for C12 with and without accounting for reflectance.

#### setwd properly, at the moment manualy into years

## require library stringr (for strin manupulation in file names)

## require library moments for calculating statistical moments - std, ske, kur

## require: library(LaplacesDemon)

setwd("C:/X/2019")

lidar.year = 2019

files.list.Step6 <- list.files(path = "Step6")

### defining main.df   if you want to add metrics, add it here as well

main.df <- data.frame (
  
						plot.name = character(0),
						lidar.year = character(0), 
						
					## intensity
						
					## C1 intensity
					
					C1.int.avg.all.abv.0.0m = numeric(),
					C1.int.avg.single.abv.0.0m = numeric(),
					C1.int.avg.first.abv.0.0m = numeric(),
					
					C1.int.avg.all.abv.1.0m = numeric(),
					C1.int.avg.single.abv.1.0m = numeric(),
					C1.int.avg.first.abv.1.0m = numeric(),
					
					C1.int.avg.all.abv.2.0m = numeric(),
					C1.int.avg.single.abv.2.0m = numeric(),
					C1.int.avg.first.abv.2.0m = numeric(),
					
					C1.int.avg.all.abv.2.7m = numeric(),
					C1.int.avg.single.abv.2.7m = numeric(),
					C1.int.avg.first.abv.2.7m = numeric(),
					
					C1.int.avg.all.abv.5.0m = numeric(),
					C1.int.avg.single.abv.5.0m = numeric(),
					C1.int.avg.first.abv.5.0m = numeric(),
					
					C1.int.avg.all.abv.7.4m = numeric(),
					C1.int.avg.single.abv.7.4m = numeric(),
					C1.int.avg.first.abv.7.4m = numeric(),
					
					C1.int.avg.all.abv.20.0m = numeric(),
					C1.int.avg.single.abv.20.0m = numeric(),
					C1.int.avg.first.abv.20.0m = numeric(),
					
					## C2 intensity
					
					C2.int.avg.all.abv.0.0m = numeric(),
					C2.int.avg.single.abv.0.0m = numeric(),
					C2.int.avg.first.abv.0.0m = numeric(),
					
					C2.int.avg.all.abv.1.0m = numeric(),
					C2.int.avg.single.abv.1.0m = numeric(),
					C2.int.avg.first.abv.1.0m = numeric(),
					
					C2.int.avg.all.abv.2.0m = numeric(),
					C2.int.avg.single.abv.2.0m = numeric(),
					C2.int.avg.first.abv.2.0m = numeric(),
					
					C2.int.avg.all.abv.2.7m = numeric(),
					C2.int.avg.single.abv.2.7m = numeric(),
					C2.int.avg.first.abv.2.7m = numeric(),
					
					C2.int.avg.all.abv.5.0m = numeric(),
					C2.int.avg.single.abv.5.0m = numeric(),
					C2.int.avg.first.abv.5.0m = numeric(),
					
					C2.int.avg.all.abv.7.4m = numeric(),
					C2.int.avg.single.abv.7.4m = numeric(),
					C2.int.avg.first.abv.7.4m = numeric(),
					
					C2.int.avg.all.abv.20.0m = numeric(),
					C2.int.avg.single.abv.20.0m = numeric(),
					C2.int.avg.first.abv.20.0m = numeric(),
					
					## C3 intensity
					
					C3.int.avg.all.abv.0.0m = numeric(),
					C3.int.avg.single.abv.0.0m = numeric(),
					C3.int.avg.first.abv.0.0m = numeric(),
					
					C3.int.avg.all.abv.1.0m = numeric(),
					C3.int.avg.single.abv.1.0m = numeric(),
					C3.int.avg.first.abv.1.0m = numeric(),
					
					C3.int.avg.all.abv.2.0m = numeric(),
					C3.int.avg.single.abv.2.0m = numeric(),
					C3.int.avg.first.abv.2.0m = numeric(),
					
					C3.int.avg.all.abv.2.7m = numeric(),
					C3.int.avg.single.abv.2.7m = numeric(),
					C3.int.avg.first.abv.2.7m = numeric(),
					
					C3.int.avg.all.abv.5.0m = numeric(),
					C3.int.avg.single.abv.5.0m = numeric(),
					C3.int.avg.first.abv.5.0m = numeric(),
					
					C3.int.avg.all.abv.7.4m = numeric(),
					C3.int.avg.single.abv.7.4m = numeric(),
					C3.int.avg.first.abv.7.4m = numeric(),
					
					C3.int.avg.all.abv.20.0m = numeric(),
					C3.int.avg.single.abv.20.0m = numeric(),
					C3.int.avg.first.abv.20.0m = numeric(),
					
					
					## I*Z family
						
					C1.iz.all.abv.0.0m = numeric(),
					C1.iz.all.abv.1.0m = numeric(),
					C1.iz.all.abv.2.0m = numeric(),
					C1.iz.all.abv.2.7m = numeric(),
					C1.iz.all.abv.5.0m = numeric(),
					C1.iz.all.abv.7.4m = numeric(),
					C1.iz.all.abv.20.0m = numeric(),
					
					C1.iz2.all.abv.0.0m = numeric(),
					C1.iz2.all.abv.1.0m = numeric(),
					C1.iz2.all.abv.2.0m = numeric(),
					C1.iz2.all.abv.2.7m = numeric(),
					C1.iz2.all.abv.5.0m = numeric(),
					C1.iz2.all.abv.7.4m = numeric(),
					C1.iz2.all.abv.20.0m = numeric(),
					
					C2.iz.all.abv.0.0m = numeric(),
					C2.iz.all.abv.1.0m = numeric(),
					C2.iz.all.abv.2.0m = numeric(),
					C2.iz.all.abv.2.7m = numeric(),
					C2.iz.all.abv.5.0m = numeric(),
					C2.iz.all.abv.7.4m = numeric(),
					C2.iz.all.abv.20.0m = numeric(),
					
					C2.iz2.all.abv.0.0m = numeric(),
					C2.iz2.all.abv.1.0m = numeric(),
					C2.iz2.all.abv.2.0m = numeric(),
					C2.iz2.all.abv.2.7m = numeric(),
					C2.iz2.all.abv.5.0m = numeric(),
					C2.iz2.all.abv.7.4m = numeric(),
					C2.iz2.all.abv.20.0m = numeric(),
					
					C12.iz.all.abv.0.0m = numeric(),
					C12.iz.all.abv.1.0m = numeric(),
					C12.iz.all.abv.2.0m = numeric(),
					C12.iz.all.abv.2.7m = numeric(),
					C12.iz.all.abv.5.0m = numeric(),
					C12.iz.all.abv.7.4m = numeric(),
					C12.iz.all.abv.20.0m = numeric(),
					
					C12.iz2.all.abv.0.0m = numeric(),
					C12.iz2.all.abv.1.0m = numeric(),
					C12.iz2.all.abv.2.0m = numeric(),
					C12.iz2.all.abv.2.7m = numeric(),
					C12.iz2.all.abv.5.0m = numeric(),
					C12.iz2.all.abv.7.4m = numeric(),
					C12.iz2.all.abv.20.0m = numeric()

				## This is for normolized intensity - C1 normolazed to C2. However, I can recalculate it with counts and what I have above in the big table. 
				##	C12n.iz.all.abv.0.0m = numeric(),
				##	C12n.iz.all.abv.1.0m = numeric(),
				##	C12n.iz.all.abv.2.0m = numeric(),
				##	C12n.iz.all.abv.2.7m = numeric(),
				##	C12n.iz.all.abv.5.0m = numeric(),
				##	C12n.iz.all.abv.7.4m = numeric(),
				##	C12n.iz.all.abv.20.0m = numeric(),
					
				##	C12n.iz2.all.abv.0.0m = numeric(),
				##	C12n.iz2.all.abv.1.0m = numeric(),
				##	C12n.iz2.all.abv.2.0m = numeric(),
				##	C12n.iz2.all.abv.2.7m = numeric(),
				##	C12n.iz2.all.abv.5.0m = numeric(),
				##	C12n.iz2.all.abv.7.4m = numeric(),
				##	C12n.iz2.all.abv.20.0m = numeric()
					
						)


for (i in 1:length(files.list.Step6)) {
  
  if (i==1) {tic()} ### just a timer start

plot.Step6.tmp <- read.table(paste0("Step6\\", files.list.Step6[i]), quote="\"", comment.char="")

names(plot.Step6.tmp) <- c("X", "Y", "Z", "I", "Echo.type", "Ecno.number", "NumberOfEchos", "Line")

plot.Step6.tmp$Channel <- as.character(plot.Step6.tmp$Line %% 10)

plot.Step6.tmp$IZ <- plot.Step6.tmp$I * plot.Step6.tmp$Z

plot.Step6.tmp$IZ2 <- plot.Step6.tmp$I * plot.Step6.tmp$Z^2

main.df[i,]$plot.name <- str_sub(files.list.Step6[i],1,-5)

main.df[i,]$lidar.year <- lidar.year

###### Intensity metrics

	## C1 with cut offs
  
	main.df[i,]$C1.int.avg.all.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1,]$I), 2)
	main.df[i,]$C1.int.avg.single.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$NumberOfEchos==1,]$I), 2)
	main.df[i,]$C1.int.avg.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$I), 2)
	  
	main.df[i,]$C1.int.avg.all.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 1.0,]$I), 2)
	main.df[i,]$C1.int.avg.single.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 1.0,]$I), 2)
	main.df[i,]$C1.int.avg.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$I), 2)
	  
	main.df[i,]$C1.int.avg.all.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 2.0,]$I), 2)
	main.df[i,]$C1.int.avg.single.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 2.0,]$I), 2)
	main.df[i,]$C1.int.avg.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$I), 2)
  
	main.df[i,]$C1.int.avg.all.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 2.7,]$I), 2)
	main.df[i,]$C1.int.avg.single.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 2.7,]$I), 2)
	main.df[i,]$C1.int.avg.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$I), 2)

	main.df[i,]$C1.int.avg.all.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 5.0,]$I), 2)
	main.df[i,]$C1.int.avg.single.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 5.0,]$I), 2)
	main.df[i,]$C1.int.avg.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$I), 2)

	main.df[i,]$C1.int.avg.all.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 7.4,]$I), 2)
	main.df[i,]$C1.int.avg.single.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 7.4,]$I), 2)
	main.df[i,]$C1.int.avg.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$I), 2)

	main.df[i,]$C1.int.avg.all.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 20.0,]$I), 2)
	main.df[i,]$C1.int.avg.single.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 20.0,]$I), 2)
	main.df[i,]$C1.int.avg.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$I), 2)

	## C2 with cut offs
  
	main.df[i,]$C2.int.avg.all.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2,]$I), 2)
	main.df[i,]$C2.int.avg.single.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$NumberOfEchos==1,]$I), 2)
	main.df[i,]$C2.int.avg.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$I), 2)
	  
	main.df[i,]$C2.int.avg.all.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 1.0,]$I), 2)
	main.df[i,]$C2.int.avg.single.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 1.0,]$I), 2)
	main.df[i,]$C2.int.avg.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$I), 2)
	  
	main.df[i,]$C2.int.avg.all.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 2.0,]$I), 2)
	main.df[i,]$C2.int.avg.single.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 2.0,]$I), 2)
	main.df[i,]$C2.int.avg.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$I), 2)
  
	main.df[i,]$C2.int.avg.all.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 2.7,]$I), 2)
	main.df[i,]$C2.int.avg.single.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 2.7,]$I), 2)
	main.df[i,]$C2.int.avg.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$I), 2)

	main.df[i,]$C2.int.avg.all.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 5.0,]$I), 2)
	main.df[i,]$C2.int.avg.single.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 5.0,]$I), 2)
	main.df[i,]$C2.int.avg.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$I), 2)

	main.df[i,]$C2.int.avg.all.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 7.4,]$I), 2)
	main.df[i,]$C2.int.avg.single.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 7.4,]$I), 2)
	main.df[i,]$C2.int.avg.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$I), 2)

	main.df[i,]$C2.int.avg.all.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 20.0,]$I), 2)
	main.df[i,]$C2.int.avg.single.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 20.0,]$I), 2)
	main.df[i,]$C2.int.avg.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$I), 2)
  
	## C3 with cut offs
  
	main.df[i,]$C3.int.avg.all.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3,]$I), 2)
	main.df[i,]$C3.int.avg.single.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$NumberOfEchos==1,]$I), 2)
	main.df[i,]$C3.int.avg.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$I), 2)
	  
	main.df[i,]$C3.int.avg.all.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Z > 1.0,]$I), 2)
	main.df[i,]$C3.int.avg.single.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 1.0,]$I), 2)
	main.df[i,]$C3.int.avg.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$I), 2)
	  
	main.df[i,]$C3.int.avg.all.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Z > 2.0,]$I), 2)
	main.df[i,]$C3.int.avg.single.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 2.0,]$I), 2)
	main.df[i,]$C3.int.avg.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$I), 2)
  
	main.df[i,]$C3.int.avg.all.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Z > 2.7,]$I), 2)
	main.df[i,]$C3.int.avg.single.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 2.7,]$I), 2)
	main.df[i,]$C3.int.avg.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$I), 2)

	main.df[i,]$C3.int.avg.all.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Z > 5.0,]$I), 2)
	main.df[i,]$C3.int.avg.single.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 5.0,]$I), 2)
	main.df[i,]$C3.int.avg.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$I), 2)

	main.df[i,]$C3.int.avg.all.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Z > 7.4,]$I), 2)
	main.df[i,]$C3.int.avg.single.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 7.4,]$I), 2)
	main.df[i,]$C3.int.avg.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$I), 2)

	main.df[i,]$C3.int.avg.all.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Z > 20.0,]$I), 2)
	main.df[i,]$C3.int.avg.single.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$NumberOfEchos==1 & plot.Step6.tmp$Z > 20.0,]$I), 2)
	main.df[i,]$C3.int.avg.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$I), 2)  
	
	

###### I*Z-family metrics

	## I*Z and I*Z2 C1 with cut offs
  
	main.df[i,]$C1.iz.all.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1,]$IZ ), 2)
	main.df[i,]$C1.iz.all.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 1.0,]$IZ ), 2)
	main.df[i,]$C1.iz.all.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 2.0,]$IZ ), 2)
	main.df[i,]$C1.iz.all.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 2.7,]$IZ ), 2)
	main.df[i,]$C1.iz.all.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 5.0,]$IZ ), 2)
	main.df[i,]$C1.iz.all.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 7.4,]$IZ ), 2)
	main.df[i,]$C1.iz.all.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 20.0,]$IZ ), 2)	
	
	main.df[i,]$C1.iz2.all.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1,]$IZ2 ), 2)
	main.df[i,]$C1.iz2.all.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 1.0,]$IZ2 ), 2)
	main.df[i,]$C1.iz2.all.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 2.0,]$IZ2 ), 2)
	main.df[i,]$C1.iz2.all.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 2.7,]$IZ2 ), 2)
	main.df[i,]$C1.iz2.all.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 5.0,]$IZ2 ), 2)
	main.df[i,]$C1.iz2.all.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 7.4,]$IZ2 ), 2)
	main.df[i,]$C1.iz2.all.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Z > 20.0,]$IZ2 ), 2)
  
  
	## I*Z and I*Z2 C2 with cut offs
  
	main.df[i,]$C2.iz.all.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2,]$IZ ), 2)
	main.df[i,]$C2.iz.all.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 1.0,]$IZ ), 2)
	main.df[i,]$C2.iz.all.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 2.0,]$IZ ), 2)
	main.df[i,]$C2.iz.all.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 2.7,]$IZ ), 2)
	main.df[i,]$C2.iz.all.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 5.0,]$IZ ), 2)
	main.df[i,]$C2.iz.all.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 7.4,]$IZ ), 2)
	main.df[i,]$C2.iz.all.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 20.0,]$IZ ), 2)	
	
	main.df[i,]$C2.iz2.all.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2,]$IZ2 ), 2)
	main.df[i,]$C2.iz2.all.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 1.0,]$IZ2 ), 2)
	main.df[i,]$C2.iz2.all.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 2.0,]$IZ2 ), 2)
	main.df[i,]$C2.iz2.all.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 2.7,]$IZ2 ), 2)
	main.df[i,]$C2.iz2.all.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 5.0,]$IZ2 ), 2)
	main.df[i,]$C2.iz2.all.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 7.4,]$IZ2 ), 2)
	main.df[i,]$C2.iz2.all.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Z > 20.0,]$IZ2 ), 2)
  
  ## I*Z and I*Z2 C12 with cut offs
  
	main.df[i,]$C12.iz.all.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3,]$IZ ), 2)
	main.df[i,]$C12.iz.all.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 1.0,]$IZ ), 2)
	main.df[i,]$C12.iz.all.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 2.0,]$IZ ), 2)
	main.df[i,]$C12.iz.all.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 2.7,]$IZ ), 2)
	main.df[i,]$C12.iz.all.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 5.0,]$IZ ), 2)
	main.df[i,]$C12.iz.all.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 7.4,]$IZ ), 2)
	main.df[i,]$C12.iz.all.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 20.0,]$IZ ), 2)	
	
	main.df[i,]$C12.iz2.all.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3,]$IZ2 ), 2)
	main.df[i,]$C12.iz2.all.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 1.0,]$IZ2 ), 2)
	main.df[i,]$C12.iz2.all.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 2.0,]$IZ2 ), 2)
	main.df[i,]$C12.iz2.all.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 2.7,]$IZ2 ), 2)
	main.df[i,]$C12.iz2.all.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 5.0,]$IZ2 ), 2)
	main.df[i,]$C12.iz2.all.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 7.4,]$IZ2 ), 2)
	main.df[i,]$C12.iz2.all.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Z > 20.0,]$IZ2 ), 2)
  
  
  if (i==length(files.list.Step6)) {toc()} ### just a timer stop
}


write.csv(main.df, "main.df.intensities.csv", row.names=FALSE)
