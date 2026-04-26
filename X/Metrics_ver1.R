

#### setwd properly, at the moment manualy into years

## require library stringr

setwd("C:/X/2016")

lidar.year = 2016

files.list.Step6 <- list.files(path = "Step6")

### defining main.df   if you want to add metrics, add it here as well

main.df <- data.frame (
						plot.name = character(0),
						lidar.year = character(0), 
						counts.C1.all.0m = numeric(0),
						avg.C1.all.0m = numeric(0)
						
						)

for (i in 1:length(files.list.Step6)) {

plot.Step6.tmp <- plot_tmp <- read.table(paste0("Step6\\", files.list.Step6[i]), quote="\"", comment.char="")

names(plot.Step6.tmp) <- c("X", "Y", "Z", "I", "Echo.type", "Ecno.number", "NumberOfEchos", "Line")

plot.Step6.tmp$Channel <- as.character(plot.Step6.tmp$Line %% 10)

main.df[i,]$plot.name <- str_sub(files.list.Step6[i],1,-5)

main.df[i,]$lidar.year <- lidar.year

main.df[i,]$counts.C1.all.0m <- nrow(plot.Step6.tmp[plot.Step6.tmp$Channel==1,])

main.df[i,]$avg.C1.all.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1,]$Z),2)

}

write.csv(main.df, "main.df.csv")
