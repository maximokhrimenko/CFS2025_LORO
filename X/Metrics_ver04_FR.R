

#### setwd properly, at the moment manualy into years

## require library stringr (for strin manupulation in file names)

## require library moments for calculating statistical moments - std, ske, kur

setwd("C:/X/2019")
lidar.year = 2019

library(moments)
library(stringr)
library(tictoc)

files.list.Step6 <- list.files(path = "Step6")

### defining main.df   if you want to add metrics, add it here as well

main.df <- data.frame (
  
						plot.name = character(0),
						lidar.year = character(0), 
						
					
						
					##### Height metrics
						
						## C1 height metrics
						
						
						C1.h.avg.first.abv.0.0m = numeric(),
						C1.h.qav.first.abv.0.0m = numeric(),
						C1.h.std.first.abv.0.0m = numeric(),
						C1.h.ske.first.abv.0.0m = numeric(),
						C1.h.kur.first.abv.0.0m = numeric(),
						C1.h.p25.first.abv.0.0m = numeric(),
						C1.h.p50.first.abv.0.0m = numeric(),
						C1.h.p75.first.abv.0.0m = numeric(),
						C1.h.p80.first.abv.0.0m = numeric(),
						C1.h.p90.first.abv.0.0m = numeric(),
						C1.h.p95.first.abv.0.0m = numeric(),
						C1.h.p99.first.abv.0.0m = numeric(),
						
						C1.h.avg.first.abv.1.0m = numeric(),
						C1.h.qav.first.abv.1.0m = numeric(),
						C1.h.std.first.abv.1.0m = numeric(),
						C1.h.ske.first.abv.1.0m = numeric(),
						C1.h.kur.first.abv.1.0m = numeric(),
						C1.h.p25.first.abv.1.0m = numeric(),
						C1.h.p50.first.abv.1.0m = numeric(),
						C1.h.p75.first.abv.1.0m = numeric(),
						C1.h.p80.first.abv.1.0m = numeric(),
						C1.h.p90.first.abv.1.0m = numeric(),
						C1.h.p95.first.abv.1.0m = numeric(),
						C1.h.p99.first.abv.1.0m = numeric(),
						
						C1.h.avg.first.abv.2.0m = numeric(),
						C1.h.qav.first.abv.2.0m = numeric(),
						C1.h.std.first.abv.2.0m = numeric(),
						C1.h.ske.first.abv.2.0m = numeric(),
						C1.h.kur.first.abv.2.0m = numeric(),
						C1.h.p25.first.abv.2.0m = numeric(),
						C1.h.p50.first.abv.2.0m = numeric(),
						C1.h.p75.first.abv.2.0m = numeric(),
						C1.h.p80.first.abv.2.0m = numeric(),
						C1.h.p90.first.abv.2.0m = numeric(),
						C1.h.p95.first.abv.2.0m = numeric(),
						C1.h.p99.first.abv.2.0m = numeric(),
						
						C1.h.avg.first.abv.2.7m = numeric(),
						C1.h.qav.first.abv.2.7m = numeric(),
						C1.h.std.first.abv.2.7m = numeric(),
						C1.h.ske.first.abv.2.7m = numeric(),
						C1.h.kur.first.abv.2.7m = numeric(),
						C1.h.p25.first.abv.2.7m = numeric(),
						C1.h.p50.first.abv.2.7m = numeric(),
						C1.h.p75.first.abv.2.7m = numeric(),
						C1.h.p80.first.abv.2.7m = numeric(),
						C1.h.p90.first.abv.2.7m = numeric(),
						C1.h.p95.first.abv.2.7m = numeric(),
						C1.h.p99.first.abv.2.7m = numeric(),
						
						C1.h.avg.first.abv.5.0m = numeric(),
						C1.h.qav.first.abv.5.0m = numeric(),
						C1.h.std.first.abv.5.0m = numeric(),
						C1.h.ske.first.abv.5.0m = numeric(),
						C1.h.kur.first.abv.5.0m = numeric(),
						C1.h.p25.first.abv.5.0m = numeric(),
						C1.h.p50.first.abv.5.0m = numeric(),
						C1.h.p75.first.abv.5.0m = numeric(),
						C1.h.p80.first.abv.5.0m = numeric(),
						C1.h.p90.first.abv.5.0m = numeric(),
						C1.h.p95.first.abv.5.0m = numeric(),
						C1.h.p99.first.abv.5.0m = numeric(),
						
						C1.h.avg.first.abv.7.4m = numeric(),
						C1.h.qav.first.abv.7.4m = numeric(),
						C1.h.std.first.abv.7.4m = numeric(),
						C1.h.ske.first.abv.7.4m = numeric(),
						C1.h.kur.first.abv.7.4m = numeric(),
						C1.h.p25.first.abv.7.4m = numeric(),
						C1.h.p50.first.abv.7.4m = numeric(),
						C1.h.p75.first.abv.7.4m = numeric(),
						C1.h.p80.first.abv.7.4m = numeric(),
						C1.h.p90.first.abv.7.4m = numeric(),
						C1.h.p95.first.abv.7.4m = numeric(),
						C1.h.p99.first.abv.7.4m = numeric(),
						
						C1.h.avg.first.abv.20.0m = numeric(),
						C1.h.qav.first.abv.20.0m = numeric(),
						
						
						## C2 height metrics
						
												
						C2.h.avg.first.abv.0.0m = numeric(),
						C2.h.qav.first.abv.0.0m = numeric(),
						C2.h.std.first.abv.0.0m = numeric(),
						C2.h.ske.first.abv.0.0m = numeric(),
						C2.h.kur.first.abv.0.0m = numeric(),
						C2.h.p25.first.abv.0.0m = numeric(),
						C2.h.p50.first.abv.0.0m = numeric(),
						C2.h.p75.first.abv.0.0m = numeric(),
						C2.h.p80.first.abv.0.0m = numeric(),
						C2.h.p90.first.abv.0.0m = numeric(),
						C2.h.p95.first.abv.0.0m = numeric(),
						C2.h.p99.first.abv.0.0m = numeric(),
						
						C2.h.avg.first.abv.1.0m = numeric(),
						C2.h.qav.first.abv.1.0m = numeric(),
						C2.h.std.first.abv.1.0m = numeric(),
						C2.h.ske.first.abv.1.0m = numeric(),
						C2.h.kur.first.abv.1.0m = numeric(),
						C2.h.p25.first.abv.1.0m = numeric(),
						C2.h.p50.first.abv.1.0m = numeric(),
						C2.h.p75.first.abv.1.0m = numeric(),
						C2.h.p80.first.abv.1.0m = numeric(),
						C2.h.p90.first.abv.1.0m = numeric(),
						C2.h.p95.first.abv.1.0m = numeric(),
						C2.h.p99.first.abv.1.0m = numeric(),
						
						C2.h.avg.first.abv.2.0m = numeric(),
						C2.h.qav.first.abv.2.0m = numeric(),
						C2.h.std.first.abv.2.0m = numeric(),
						C2.h.ske.first.abv.2.0m = numeric(),
						C2.h.kur.first.abv.2.0m = numeric(),
						C2.h.p25.first.abv.2.0m = numeric(),
						C2.h.p50.first.abv.2.0m = numeric(),
						C2.h.p75.first.abv.2.0m = numeric(),
						C2.h.p80.first.abv.2.0m = numeric(),
						C2.h.p90.first.abv.2.0m = numeric(),
						C2.h.p95.first.abv.2.0m = numeric(),
						C2.h.p99.first.abv.2.0m = numeric(),
						
						C2.h.avg.first.abv.2.7m = numeric(),
						C2.h.qav.first.abv.2.7m = numeric(),
						C2.h.std.first.abv.2.7m = numeric(),
						C2.h.ske.first.abv.2.7m = numeric(),
						C2.h.kur.first.abv.2.7m = numeric(),
						C2.h.p25.first.abv.2.7m = numeric(),
						C2.h.p50.first.abv.2.7m = numeric(),
						C2.h.p75.first.abv.2.7m = numeric(),
						C2.h.p80.first.abv.2.7m = numeric(),
						C2.h.p90.first.abv.2.7m = numeric(),
						C2.h.p95.first.abv.2.7m = numeric(),
						C2.h.p99.first.abv.2.7m = numeric(),
						
						C2.h.avg.first.abv.5.0m = numeric(),
						C2.h.qav.first.abv.5.0m = numeric(),
						C2.h.std.first.abv.5.0m = numeric(),
						C2.h.ske.first.abv.5.0m = numeric(),
						C2.h.kur.first.abv.5.0m = numeric(),
						C2.h.p25.first.abv.5.0m = numeric(),
						C2.h.p50.first.abv.5.0m = numeric(),
						C2.h.p75.first.abv.5.0m = numeric(),
						C2.h.p80.first.abv.5.0m = numeric(),
						C2.h.p90.first.abv.5.0m = numeric(),
						C2.h.p95.first.abv.5.0m = numeric(),
						C2.h.p99.first.abv.5.0m = numeric(),
						
						C2.h.avg.first.abv.7.4m = numeric(),
						C2.h.qav.first.abv.7.4m = numeric(),
						C2.h.std.first.abv.7.4m = numeric(),
						C2.h.ske.first.abv.7.4m = numeric(),
						C2.h.kur.first.abv.7.4m = numeric(),
						C2.h.p25.first.abv.7.4m = numeric(),
						C2.h.p50.first.abv.7.4m = numeric(),
						C2.h.p75.first.abv.7.4m = numeric(),
						C2.h.p80.first.abv.7.4m = numeric(),
						C2.h.p90.first.abv.7.4m = numeric(),
						C2.h.p95.first.abv.7.4m = numeric(),
						C2.h.p99.first.abv.7.4m = numeric(),
						
						C2.h.avg.first.abv.20.0m = numeric(),
						C2.h.qav.first.abv.20.0m = numeric(),
					
					  ## C3 height metrics
					
  					  					
  					C3.h.avg.first.abv.0.0m = numeric(),
  					C3.h.qav.first.abv.0.0m = numeric(),
  					C3.h.std.first.abv.0.0m = numeric(),
  					C3.h.ske.first.abv.0.0m = numeric(),
  					C3.h.kur.first.abv.0.0m = numeric(),
  					C3.h.p25.first.abv.0.0m = numeric(),
  					C3.h.p50.first.abv.0.0m = numeric(),
  					C3.h.p75.first.abv.0.0m = numeric(),
  					C3.h.p80.first.abv.0.0m = numeric(),
  					C3.h.p90.first.abv.0.0m = numeric(),
  					C3.h.p95.first.abv.0.0m = numeric(),
  					C3.h.p99.first.abv.0.0m = numeric(),
  					
  					C3.h.avg.first.abv.1.0m = numeric(),
  					C3.h.qav.first.abv.1.0m = numeric(),
  					C3.h.std.first.abv.1.0m = numeric(),
  					C3.h.ske.first.abv.1.0m = numeric(),
  					C3.h.kur.first.abv.1.0m = numeric(),
  					C3.h.p25.first.abv.1.0m = numeric(),
  					C3.h.p50.first.abv.1.0m = numeric(),
  					C3.h.p75.first.abv.1.0m = numeric(),
  					C3.h.p80.first.abv.1.0m = numeric(),
  					C3.h.p90.first.abv.1.0m = numeric(),
  					C3.h.p95.first.abv.1.0m = numeric(),
  					C3.h.p99.first.abv.1.0m = numeric(),
  					
  					C3.h.avg.first.abv.2.0m = numeric(),
  					C3.h.qav.first.abv.2.0m = numeric(),
  					C3.h.std.first.abv.2.0m = numeric(),
  					C3.h.ske.first.abv.2.0m = numeric(),
  					C3.h.kur.first.abv.2.0m = numeric(),
  					C3.h.p25.first.abv.2.0m = numeric(),
  					C3.h.p50.first.abv.2.0m = numeric(),
  					C3.h.p75.first.abv.2.0m = numeric(),
  					C3.h.p80.first.abv.2.0m = numeric(),
  					C3.h.p90.first.abv.2.0m = numeric(),
  					C3.h.p95.first.abv.2.0m = numeric(),
  					C3.h.p99.first.abv.2.0m = numeric(),
  					
  					C3.h.avg.first.abv.2.7m = numeric(),
  					C3.h.qav.first.abv.2.7m = numeric(),
  					C3.h.std.first.abv.2.7m = numeric(),
  					C3.h.ske.first.abv.2.7m = numeric(),
  					C3.h.kur.first.abv.2.7m = numeric(),
  					C3.h.p25.first.abv.2.7m = numeric(),
  					C3.h.p50.first.abv.2.7m = numeric(),
  					C3.h.p75.first.abv.2.7m = numeric(),
  					C3.h.p80.first.abv.2.7m = numeric(),
  					C3.h.p90.first.abv.2.7m = numeric(),
  					C3.h.p95.first.abv.2.7m = numeric(),
  					C3.h.p99.first.abv.2.7m = numeric(),
  					
  					C3.h.avg.first.abv.5.0m = numeric(),
  					C3.h.qav.first.abv.5.0m = numeric(),
  					C3.h.std.first.abv.5.0m = numeric(),
  					C3.h.ske.first.abv.5.0m = numeric(),
  					C3.h.kur.first.abv.5.0m = numeric(),
  					C3.h.p25.first.abv.5.0m = numeric(),
  					C3.h.p50.first.abv.5.0m = numeric(),
  					C3.h.p75.first.abv.5.0m = numeric(),
  					C3.h.p80.first.abv.5.0m = numeric(),
  					C3.h.p90.first.abv.5.0m = numeric(),
  					C3.h.p95.first.abv.5.0m = numeric(),
  					C3.h.p99.first.abv.5.0m = numeric(),
  					
  					C3.h.avg.first.abv.7.4m = numeric(),
  					C3.h.qav.first.abv.7.4m = numeric(),
  					C3.h.std.first.abv.7.4m = numeric(),
  					C3.h.ske.first.abv.7.4m = numeric(),
  					C3.h.kur.first.abv.7.4m = numeric(),
  					C3.h.p25.first.abv.7.4m = numeric(),
  					C3.h.p50.first.abv.7.4m = numeric(),
  					C3.h.p75.first.abv.7.4m = numeric(),
  					C3.h.p80.first.abv.7.4m = numeric(),
  					C3.h.p90.first.abv.7.4m = numeric(),
  					C3.h.p95.first.abv.7.4m = numeric(),
  					C3.h.p99.first.abv.7.4m = numeric(),
  					
  					C3.h.avg.first.abv.20.0m = numeric(),
  					C3.h.qav.first.abv.20.0m = numeric(),
  					
					
					## C12 height metrics
					
									
					C12.h.avg.first.abv.0.0m = numeric(),
					C12.h.qav.first.abv.0.0m = numeric(),
					C12.h.std.first.abv.0.0m = numeric(),
					C12.h.ske.first.abv.0.0m = numeric(),
					C12.h.kur.first.abv.0.0m = numeric(),
					C12.h.p25.first.abv.0.0m = numeric(),
					C12.h.p50.first.abv.0.0m = numeric(),
					C12.h.p75.first.abv.0.0m = numeric(),
					C12.h.p80.first.abv.0.0m = numeric(),
					C12.h.p90.first.abv.0.0m = numeric(),
					C12.h.p95.first.abv.0.0m = numeric(),
					C12.h.p99.first.abv.0.0m = numeric(),
					
					C12.h.avg.first.abv.1.0m = numeric(),
					C12.h.qav.first.abv.1.0m = numeric(),
					C12.h.std.first.abv.1.0m = numeric(),
					C12.h.ske.first.abv.1.0m = numeric(),
					C12.h.kur.first.abv.1.0m = numeric(),
					C12.h.p25.first.abv.1.0m = numeric(),
					C12.h.p50.first.abv.1.0m = numeric(),
					C12.h.p75.first.abv.1.0m = numeric(),
					C12.h.p80.first.abv.1.0m = numeric(),
					C12.h.p90.first.abv.1.0m = numeric(),
					C12.h.p95.first.abv.1.0m = numeric(),
					C12.h.p99.first.abv.1.0m = numeric(),
					
					C12.h.avg.first.abv.2.0m = numeric(),
					C12.h.qav.first.abv.2.0m = numeric(),
					C12.h.std.first.abv.2.0m = numeric(),
					C12.h.ske.first.abv.2.0m = numeric(),
					C12.h.kur.first.abv.2.0m = numeric(),
					C12.h.p25.first.abv.2.0m = numeric(),
					C12.h.p50.first.abv.2.0m = numeric(),
					C12.h.p75.first.abv.2.0m = numeric(),
					C12.h.p80.first.abv.2.0m = numeric(),
					C12.h.p90.first.abv.2.0m = numeric(),
					C12.h.p95.first.abv.2.0m = numeric(),
					C12.h.p99.first.abv.2.0m = numeric(),
					
					C12.h.avg.first.abv.2.7m = numeric(),
					C12.h.qav.first.abv.2.7m = numeric(),
					C12.h.std.first.abv.2.7m = numeric(),
					C12.h.ske.first.abv.2.7m = numeric(),
					C12.h.kur.first.abv.2.7m = numeric(),
					C12.h.p25.first.abv.2.7m = numeric(),
					C12.h.p50.first.abv.2.7m = numeric(),
					C12.h.p75.first.abv.2.7m = numeric(),
					C12.h.p80.first.abv.2.7m = numeric(),
					C12.h.p90.first.abv.2.7m = numeric(),
					C12.h.p95.first.abv.2.7m = numeric(),
					C12.h.p99.first.abv.2.7m = numeric(),
					
					C12.h.avg.first.abv.5.0m = numeric(),
					C12.h.qav.first.abv.5.0m = numeric(),
					C12.h.std.first.abv.5.0m = numeric(),
					C12.h.ske.first.abv.5.0m = numeric(),
					C12.h.kur.first.abv.5.0m = numeric(),
					C12.h.p25.first.abv.5.0m = numeric(),
					C12.h.p50.first.abv.5.0m = numeric(),
					C12.h.p75.first.abv.5.0m = numeric(),
					C12.h.p80.first.abv.5.0m = numeric(),
					C12.h.p90.first.abv.5.0m = numeric(),
					C12.h.p95.first.abv.5.0m = numeric(),
					C12.h.p99.first.abv.5.0m = numeric(),
					
					C12.h.avg.first.abv.7.4m = numeric(),
					C12.h.qav.first.abv.7.4m = numeric(),
					C12.h.std.first.abv.7.4m = numeric(),
					C12.h.ske.first.abv.7.4m = numeric(),
					C12.h.kur.first.abv.7.4m = numeric(),
					C12.h.p25.first.abv.7.4m = numeric(),
					C12.h.p50.first.abv.7.4m = numeric(),
					C12.h.p75.first.abv.7.4m = numeric(),
					C12.h.p80.first.abv.7.4m = numeric(),
					C12.h.p90.first.abv.7.4m = numeric(),
					C12.h.p95.first.abv.7.4m = numeric(),
					C12.h.p99.first.abv.7.4m = numeric(),
					
					C12.h.avg.first.abv.20.0m = numeric(),
					C12.h.qav.first.abv.20.0m = numeric(),
					
					## C123 height metrics
					
										
					C123.h.avg.first.abv.0.0m = numeric(),
					C123.h.qav.first.abv.0.0m = numeric(),
					C123.h.std.first.abv.0.0m = numeric(),
					C123.h.ske.first.abv.0.0m = numeric(),
					C123.h.kur.first.abv.0.0m = numeric(),
					C123.h.p25.first.abv.0.0m = numeric(),
					C123.h.p50.first.abv.0.0m = numeric(),
					C123.h.p75.first.abv.0.0m = numeric(),
					C123.h.p80.first.abv.0.0m = numeric(),
					C123.h.p90.first.abv.0.0m = numeric(),
					C123.h.p95.first.abv.0.0m = numeric(),
					C123.h.p99.first.abv.0.0m = numeric(),
					
					C123.h.avg.first.abv.1.0m = numeric(),
					C123.h.qav.first.abv.1.0m = numeric(),
					C123.h.std.first.abv.1.0m = numeric(),
					C123.h.ske.first.abv.1.0m = numeric(),
					C123.h.kur.first.abv.1.0m = numeric(),
					C123.h.p25.first.abv.1.0m = numeric(),
					C123.h.p50.first.abv.1.0m = numeric(),
					C123.h.p75.first.abv.1.0m = numeric(),
					C123.h.p80.first.abv.1.0m = numeric(),
					C123.h.p90.first.abv.1.0m = numeric(),
					C123.h.p95.first.abv.1.0m = numeric(),
					C123.h.p99.first.abv.1.0m = numeric(),
					
					C123.h.avg.first.abv.2.0m = numeric(),
					C123.h.qav.first.abv.2.0m = numeric(),
					C123.h.std.first.abv.2.0m = numeric(),
					C123.h.ske.first.abv.2.0m = numeric(),
					C123.h.kur.first.abv.2.0m = numeric(),
					C123.h.p25.first.abv.2.0m = numeric(),
					C123.h.p50.first.abv.2.0m = numeric(),
					C123.h.p75.first.abv.2.0m = numeric(),
					C123.h.p80.first.abv.2.0m = numeric(),
					C123.h.p90.first.abv.2.0m = numeric(),
					C123.h.p95.first.abv.2.0m = numeric(),
					C123.h.p99.first.abv.2.0m = numeric(),
					
					C123.h.avg.first.abv.2.7m = numeric(),
					C123.h.qav.first.abv.2.7m = numeric(),
					C123.h.std.first.abv.2.7m = numeric(),
					C123.h.ske.first.abv.2.7m = numeric(),
					C123.h.kur.first.abv.2.7m = numeric(),
					C123.h.p25.first.abv.2.7m = numeric(),
					C123.h.p50.first.abv.2.7m = numeric(),
					C123.h.p75.first.abv.2.7m = numeric(),
					C123.h.p80.first.abv.2.7m = numeric(),
					C123.h.p90.first.abv.2.7m = numeric(),
					C123.h.p95.first.abv.2.7m = numeric(),
					C123.h.p99.first.abv.2.7m = numeric(),
					
					C123.h.avg.first.abv.5.0m = numeric(),
					C123.h.qav.first.abv.5.0m = numeric(),
					C123.h.std.first.abv.5.0m = numeric(),
					C123.h.ske.first.abv.5.0m = numeric(),
					C123.h.kur.first.abv.5.0m = numeric(),
					C123.h.p25.first.abv.5.0m = numeric(),
					C123.h.p50.first.abv.5.0m = numeric(),
					C123.h.p75.first.abv.5.0m = numeric(),
					C123.h.p80.first.abv.5.0m = numeric(),
					C123.h.p90.first.abv.5.0m = numeric(),
					C123.h.p95.first.abv.5.0m = numeric(),
					C123.h.p99.first.abv.5.0m = numeric(),
					
					C123.h.avg.first.abv.7.4m = numeric(),
					C123.h.qav.first.abv.7.4m = numeric(),
					C123.h.std.first.abv.7.4m = numeric(),
					C123.h.ske.first.abv.7.4m = numeric(),
					C123.h.kur.first.abv.7.4m = numeric(),
					C123.h.p25.first.abv.7.4m = numeric(),
					C123.h.p50.first.abv.7.4m = numeric(),
					C123.h.p75.first.abv.7.4m = numeric(),
					C123.h.p80.first.abv.7.4m = numeric(),
					C123.h.p90.first.abv.7.4m = numeric(),
					C123.h.p95.first.abv.7.4m = numeric(),
					C123.h.p99.first.abv.7.4m = numeric(),
					
					C123.h.avg.first.abv.20.0m = numeric(),
					C123.h.qav.first.abv.20.0m = numeric()
										
						
						)


for (i in 1:length(files.list.Step6)) {
  
  if (i==1) {tic()} ### just a timer start

plot.Step6.tmp <- read.table(paste0("Step6\\", files.list.Step6[i]), quote="\"", comment.char="")

names(plot.Step6.tmp) <- c("X", "Y", "Z", "I", "Echo.type", "Ecno.number", "NumberOfEchos", "Line")

plot.Step6.tmp$Channel <- as.character(plot.Step6.tmp$Line %% 10)

main.df[i,]$plot.name <- str_sub(files.list.Step6[i],1,-5)

main.df[i,]$lidar.year <- lidar.year

  
###### Height metrics  
  
  #### C1
  
  #### C1 first returns
  
  # no cut off (0.0m)  
  main.df[i,]$C1.h.avg.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C1.h.qav.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z^2), 2)
  main.df[i,]$C1.h.std.first.abv.0.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z)), 2)
  main.df[i,]$C1.h.ske.first.abv.0.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C1.h.kur.first.abv.0.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C1.h.p25.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.25)[[1]]
  main.df[i,]$C1.h.p50.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.50)[[1]]
  main.df[i,]$C1.h.p75.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.75)[[1]]
  main.df[i,]$C1.h.p80.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.80)[[1]]
  main.df[i,]$C1.h.p90.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.90)[[1]]
  main.df[i,]$C1.h.p95.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.95)[[1]]
  main.df[i,]$C1.h.p99.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.99)[[1]]
  # 1.0m cut off
  main.df[i,]$C1.h.avg.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C1.h.qav.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z^2), 2)
  main.df[i,]$C1.h.std.first.abv.1.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0 ,]$Z)), 2)
  main.df[i,]$C1.h.ske.first.abv.1.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C1.h.kur.first.abv.1.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C1.h.p25.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z, 0.25)[[1]]
  main.df[i,]$C1.h.p50.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z, 0.50)[[1]]
  main.df[i,]$C1.h.p75.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z, 0.75)[[1]]
  main.df[i,]$C1.h.p80.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z, 0.80)[[1]]
  main.df[i,]$C1.h.p90.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z, 0.90)[[1]]
  main.df[i,]$C1.h.p95.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z, 0.95)[[1]]
  main.df[i,]$C1.h.p99.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 1.0,]$Z, 0.99)[[1]]
  # 2.0m cut off
  main.df[i,]$C1.h.avg.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C1.h.qav.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z^2), 2)
  main.df[i,]$C1.h.std.first.abv.2.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z)), 2)
  main.df[i,]$C1.h.ske.first.abv.2.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C1.h.kur.first.abv.2.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C1.h.p25.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z, 0.25)[[1]]
  main.df[i,]$C1.h.p50.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z, 0.50)[[1]]
  main.df[i,]$C1.h.p75.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z, 0.75)[[1]]
  main.df[i,]$C1.h.p80.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z, 0.80)[[1]]
  main.df[i,]$C1.h.p90.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z, 0.90)[[1]]
  main.df[i,]$C1.h.p95.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z, 0.95)[[1]]
  main.df[i,]$C1.h.p99.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.0,]$Z, 0.99)[[1]]
  # 2.7m cut off
  main.df[i,]$C1.h.avg.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C1.h.qav.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z^2), 2)
  main.df[i,]$C1.h.std.first.abv.2.7m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z)), 2)
  main.df[i,]$C1.h.ske.first.abv.2.7m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C1.h.kur.first.abv.2.7m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C1.h.p25.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z, 0.25)[[1]]
  main.df[i,]$C1.h.p50.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z, 0.50)[[1]]
  main.df[i,]$C1.h.p75.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z, 0.75)[[1]]
  main.df[i,]$C1.h.p80.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z, 0.80)[[1]]
  main.df[i,]$C1.h.p90.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z, 0.90)[[1]]
  main.df[i,]$C1.h.p95.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z, 0.95)[[1]]
  main.df[i,]$C1.h.p99.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 2.7,]$Z, 0.99)[[1]]
  # 5.0m cut off
  main.df[i,]$C1.h.avg.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C1.h.qav.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z^2), 2)
  main.df[i,]$C1.h.std.first.abv.5.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z)), 2)
  main.df[i,]$C1.h.ske.first.abv.5.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C1.h.kur.first.abv.5.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C1.h.p25.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z, 0.25)[[1]]
  main.df[i,]$C1.h.p50.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z, 0.50)[[1]]
  main.df[i,]$C1.h.p75.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z, 0.75)[[1]]
  main.df[i,]$C1.h.p80.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z, 0.80)[[1]]
  main.df[i,]$C1.h.p90.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z, 0.90)[[1]]
  main.df[i,]$C1.h.p95.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z, 0.95)[[1]]
  main.df[i,]$C1.h.p99.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 5.0,]$Z, 0.99)[[1]]
  # 7.4m cut off
  main.df[i,]$C1.h.avg.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C1.h.qav.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z^2), 2)
  main.df[i,]$C1.h.std.first.abv.7.4m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z)), 2)
  main.df[i,]$C1.h.ske.first.abv.7.4m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C1.h.kur.first.abv.7.4m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C1.h.p25.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z, 0.25)[[1]]
  main.df[i,]$C1.h.p50.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z, 0.50)[[1]]
  main.df[i,]$C1.h.p75.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z, 0.75)[[1]]
  main.df[i,]$C1.h.p80.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z, 0.80)[[1]]
  main.df[i,]$C1.h.p90.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z, 0.90)[[1]]
  main.df[i,]$C1.h.p95.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z, 0.95)[[1]]
  main.df[i,]$C1.h.p99.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 7.4,]$Z, 0.99)[[1]]
  # 20.0m cut off
  main.df[i,]$C1.h.avg.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 20.0,]$Z), 2)
  main.df[i,]$C1.h.qav.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==1 & plot.Step6.tmp$Ecno.number==1& plot.Step6.tmp$Z > 20.0,]$Z^2), 2)

  #### C2
  
  #### C2 first returns
  
  # no cut off (0.0m)  
  main.df[i,]$C2.h.avg.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C2.h.qav.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z^2), 2)
  main.df[i,]$C2.h.std.first.abv.0.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z)), 2)
  main.df[i,]$C2.h.ske.first.abv.0.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C2.h.kur.first.abv.0.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C2.h.p25.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.25)[[1]]
  main.df[i,]$C2.h.p50.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.50)[[1]]
  main.df[i,]$C2.h.p75.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.75)[[1]]
  main.df[i,]$C2.h.p80.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.80)[[1]]
  main.df[i,]$C2.h.p90.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.90)[[1]]
  main.df[i,]$C2.h.p95.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.95)[[1]]
  main.df[i,]$C2.h.p99.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.99)[[1]]
  # 1.0m cut off
  main.df[i,]$C2.h.avg.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C2.h.qav.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z^2), 2)
  main.df[i,]$C2.h.std.first.abv.1.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z)), 2)
  main.df[i,]$C2.h.ske.first.abv.1.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C2.h.kur.first.abv.1.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C2.h.p25.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.25)[[1]]
  main.df[i,]$C2.h.p50.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.50)[[1]]
  main.df[i,]$C2.h.p75.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.75)[[1]]
  main.df[i,]$C2.h.p80.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.80)[[1]]
  main.df[i,]$C2.h.p90.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.90)[[1]]
  main.df[i,]$C2.h.p95.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.95)[[1]]
  main.df[i,]$C2.h.p99.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.99)[[1]]
  # 2.0m cut off
  main.df[i,]$C2.h.avg.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C2.h.qav.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z^2), 2)
  main.df[i,]$C2.h.std.first.abv.2.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z)), 2)
  main.df[i,]$C2.h.ske.first.abv.2.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C2.h.kur.first.abv.2.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C2.h.p25.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.25)[[1]]
  main.df[i,]$C2.h.p50.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.50)[[1]]
  main.df[i,]$C2.h.p75.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.75)[[1]]
  main.df[i,]$C2.h.p80.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.80)[[1]]
  main.df[i,]$C2.h.p90.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.90)[[1]]
  main.df[i,]$C2.h.p95.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.95)[[1]]
  main.df[i,]$C2.h.p99.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.99)[[1]]
  # 2.7m cut off
  main.df[i,]$C2.h.avg.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C2.h.qav.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z^2), 2)
  main.df[i,]$C2.h.std.first.abv.2.7m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z)), 2)
  main.df[i,]$C2.h.ske.first.abv.2.7m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C2.h.kur.first.abv.2.7m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C2.h.p25.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.25)[[1]]
  main.df[i,]$C2.h.p50.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.50)[[1]]
  main.df[i,]$C2.h.p75.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.75)[[1]]
  main.df[i,]$C2.h.p80.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.80)[[1]]
  main.df[i,]$C2.h.p90.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.90)[[1]]
  main.df[i,]$C2.h.p95.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.95)[[1]]
  main.df[i,]$C2.h.p99.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.99)[[1]]
  # 5.0m cut off
  main.df[i,]$C2.h.avg.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C2.h.qav.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z^2), 2)
  main.df[i,]$C2.h.std.first.abv.5.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z)), 2)
  main.df[i,]$C2.h.ske.first.abv.5.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C2.h.kur.first.abv.5.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C2.h.p25.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.25)[[1]]
  main.df[i,]$C2.h.p50.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.50)[[1]]
  main.df[i,]$C2.h.p75.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.75)[[1]]
  main.df[i,]$C2.h.p80.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.80)[[1]]
  main.df[i,]$C2.h.p90.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.90)[[1]]
  main.df[i,]$C2.h.p95.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.95)[[1]]
  main.df[i,]$C2.h.p99.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.99)[[1]]
  # 7.4m cut off
  main.df[i,]$C2.h.avg.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C2.h.qav.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z^2), 2)
  main.df[i,]$C2.h.std.first.abv.7.4m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z)), 2)
  main.df[i,]$C2.h.ske.first.abv.7.4m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C2.h.kur.first.abv.7.4m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C2.h.p25.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.25)[[1]]
  main.df[i,]$C2.h.p50.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.50)[[1]]
  main.df[i,]$C2.h.p75.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.75)[[1]]
  main.df[i,]$C2.h.p80.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.80)[[1]]
  main.df[i,]$C2.h.p90.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.90)[[1]]
  main.df[i,]$C2.h.p95.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.95)[[1]]
  main.df[i,]$C2.h.p99.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.99)[[1]]
  # 20.0m cut off
  main.df[i,]$C2.h.avg.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$Z), 2)
  main.df[i,]$C2.h.qav.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==2 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$Z^2), 2)
  
  #### C3
  
  #### C3 first returns
  
  # no cut off (0.0m)  
  main.df[i,]$C3.h.avg.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C3.h.qav.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z^2), 2)
  main.df[i,]$C3.h.std.first.abv.0.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z)), 2)
  main.df[i,]$C3.h.ske.first.abv.0.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C3.h.kur.first.abv.0.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C3.h.p25.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.25)[[1]]
  main.df[i,]$C3.h.p50.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.50)[[1]]
  main.df[i,]$C3.h.p75.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.75)[[1]]
  main.df[i,]$C3.h.p80.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.80)[[1]]
  main.df[i,]$C3.h.p90.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.90)[[1]]
  main.df[i,]$C3.h.p95.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.95)[[1]]
  main.df[i,]$C3.h.p99.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.99)[[1]]
  # 1.0m cut off
  main.df[i,]$C3.h.avg.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C3.h.qav.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z^2), 2)
  main.df[i,]$C3.h.std.first.abv.1.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z)), 2)
  main.df[i,]$C3.h.ske.first.abv.1.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C3.h.kur.first.abv.1.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C3.h.p25.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.25)[[1]]
  main.df[i,]$C3.h.p50.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.50)[[1]]
  main.df[i,]$C3.h.p75.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.75)[[1]]
  main.df[i,]$C3.h.p80.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.80)[[1]]
  main.df[i,]$C3.h.p90.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.90)[[1]]
  main.df[i,]$C3.h.p95.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.95)[[1]]
  main.df[i,]$C3.h.p99.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.99)[[1]]
  # 2.0m cut off
  main.df[i,]$C3.h.avg.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C3.h.qav.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z^2), 2)
  main.df[i,]$C3.h.std.first.abv.2.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z)), 2)
  main.df[i,]$C3.h.ske.first.abv.2.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C3.h.kur.first.abv.2.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C3.h.p25.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.25)[[1]]
  main.df[i,]$C3.h.p50.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.50)[[1]]
  main.df[i,]$C3.h.p75.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.75)[[1]]
  main.df[i,]$C3.h.p80.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.80)[[1]]
  main.df[i,]$C3.h.p90.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.90)[[1]]
  main.df[i,]$C3.h.p95.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.95)[[1]]
  main.df[i,]$C3.h.p99.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.99)[[1]]
  # 2.7m cut off
  main.df[i,]$C3.h.avg.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C3.h.qav.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z^2), 2)
  main.df[i,]$C3.h.std.first.abv.2.7m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z)), 2)
  main.df[i,]$C3.h.ske.first.abv.2.7m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C3.h.kur.first.abv.2.7m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C3.h.p25.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.25)[[1]]
  main.df[i,]$C3.h.p50.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.50)[[1]]
  main.df[i,]$C3.h.p75.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.75)[[1]]
  main.df[i,]$C3.h.p80.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.80)[[1]]
  main.df[i,]$C3.h.p90.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.90)[[1]]
  main.df[i,]$C3.h.p95.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.95)[[1]]
  main.df[i,]$C3.h.p99.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.99)[[1]]
  # 5.0m cut off
  main.df[i,]$C3.h.avg.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C3.h.qav.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z^2), 2)
  main.df[i,]$C3.h.std.first.abv.5.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z)), 2)
  main.df[i,]$C3.h.ske.first.abv.5.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C3.h.kur.first.abv.5.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C3.h.p25.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.25)[[1]]
  main.df[i,]$C3.h.p50.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.50)[[1]]
  main.df[i,]$C3.h.p75.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.75)[[1]]
  main.df[i,]$C3.h.p80.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.80)[[1]]
  main.df[i,]$C3.h.p90.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.90)[[1]]
  main.df[i,]$C3.h.p95.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.95)[[1]]
  main.df[i,]$C3.h.p99.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.99)[[1]]
  # 7.4m cut off
  main.df[i,]$C3.h.avg.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C3.h.qav.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z^2), 2)
  main.df[i,]$C3.h.std.first.abv.7.4m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z)), 2)
  main.df[i,]$C3.h.ske.first.abv.7.4m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C3.h.kur.first.abv.7.4m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C3.h.p25.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.25)[[1]]
  main.df[i,]$C3.h.p50.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.50)[[1]]
  main.df[i,]$C3.h.p75.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.75)[[1]]
  main.df[i,]$C3.h.p80.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.80)[[1]]
  main.df[i,]$C3.h.p90.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.90)[[1]]
  main.df[i,]$C3.h.p95.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.95)[[1]]
  main.df[i,]$C3.h.p99.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.99)[[1]]
  # 20.0m cut off
  main.df[i,]$C3.h.avg.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$Z), 2)
  main.df[i,]$C3.h.qav.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel==3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$Z^2), 2)
  
  #### C12
  
  #### C12 first returns
  
  # no cut off (0.0m)  
  main.df[i,]$C12.h.avg.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C12.h.qav.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z^2), 2)
  main.df[i,]$C12.h.std.first.abv.0.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z)), 2)
  main.df[i,]$C12.h.ske.first.abv.0.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C12.h.kur.first.abv.0.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C12.h.p25.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.25)[[1]]
  main.df[i,]$C12.h.p50.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.50)[[1]]
  main.df[i,]$C12.h.p75.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.75)[[1]]
  main.df[i,]$C12.h.p80.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.80)[[1]]
  main.df[i,]$C12.h.p90.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.90)[[1]]
  main.df[i,]$C12.h.p95.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.95)[[1]]
  main.df[i,]$C12.h.p99.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.99)[[1]]
  # 1.0m cut off
  main.df[i,]$C12.h.avg.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C12.h.qav.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z^2), 2)
  main.df[i,]$C12.h.std.first.abv.1.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z)), 2)
  main.df[i,]$C12.h.ske.first.abv.1.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C12.h.kur.first.abv.1.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C12.h.p25.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.25)[[1]]
  main.df[i,]$C12.h.p50.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.50)[[1]]
  main.df[i,]$C12.h.p75.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.75)[[1]]
  main.df[i,]$C12.h.p80.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.80)[[1]]
  main.df[i,]$C12.h.p90.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.90)[[1]]
  main.df[i,]$C12.h.p95.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.95)[[1]]
  main.df[i,]$C12.h.p99.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.99)[[1]]
  # 2.0m cut off
  main.df[i,]$C12.h.avg.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C12.h.qav.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z^2), 2)
  main.df[i,]$C12.h.std.first.abv.2.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z)), 2)
  main.df[i,]$C12.h.ske.first.abv.2.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C12.h.kur.first.abv.2.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C12.h.p25.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.25)[[1]]
  main.df[i,]$C12.h.p50.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.50)[[1]]
  main.df[i,]$C12.h.p75.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.75)[[1]]
  main.df[i,]$C12.h.p80.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.80)[[1]]
  main.df[i,]$C12.h.p90.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.90)[[1]]
  main.df[i,]$C12.h.p95.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.95)[[1]]
  main.df[i,]$C12.h.p99.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.99)[[1]]
  # 2.7m cut off
  main.df[i,]$C12.h.avg.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C12.h.qav.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z^2), 2)
  main.df[i,]$C12.h.std.first.abv.2.7m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z)), 2)
  main.df[i,]$C12.h.ske.first.abv.2.7m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C12.h.kur.first.abv.2.7m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C12.h.p25.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.25)[[1]]
  main.df[i,]$C12.h.p50.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.50)[[1]]
  main.df[i,]$C12.h.p75.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.75)[[1]]
  main.df[i,]$C12.h.p80.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.80)[[1]]
  main.df[i,]$C12.h.p90.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.90)[[1]]
  main.df[i,]$C12.h.p95.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.95)[[1]]
  main.df[i,]$C12.h.p99.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.99)[[1]]
  # 5.0m cut off
  main.df[i,]$C12.h.avg.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C12.h.qav.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z^2), 2)
  main.df[i,]$C12.h.std.first.abv.5.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z)), 2)
  main.df[i,]$C12.h.ske.first.abv.5.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C12.h.kur.first.abv.5.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C12.h.p25.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.25)[[1]]
  main.df[i,]$C12.h.p50.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.50)[[1]]
  main.df[i,]$C12.h.p75.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.75)[[1]]
  main.df[i,]$C12.h.p80.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.80)[[1]]
  main.df[i,]$C12.h.p90.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.90)[[1]]
  main.df[i,]$C12.h.p95.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.95)[[1]]
  main.df[i,]$C12.h.p99.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.99)[[1]]
  # 7.4m cut off
  main.df[i,]$C12.h.avg.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C12.h.qav.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z^2), 2)
  main.df[i,]$C12.h.std.first.abv.7.4m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z)), 2)
  main.df[i,]$C12.h.ske.first.abv.7.4m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C12.h.kur.first.abv.7.4m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C12.h.p25.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.25)[[1]]
  main.df[i,]$C12.h.p50.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.50)[[1]]
  main.df[i,]$C12.h.p75.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.75)[[1]]
  main.df[i,]$C12.h.p80.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.80)[[1]]
  main.df[i,]$C12.h.p90.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.90)[[1]]
  main.df[i,]$C12.h.p95.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.95)[[1]]
  main.df[i,]$C12.h.p99.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.99)[[1]]
  # 20.0m cut off
  main.df[i,]$C12.h.avg.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$Z), 2)
  main.df[i,]$C12.h.qav.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=3 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$Z^2), 2)
  
  #### C123
  
  #### C123 first returns
  
  # no cut off (0.0m)  
  main.df[i,]$C123.h.avg.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C123.h.qav.first.abv.0.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z^2), 2)
  main.df[i,]$C123.h.std.first.abv.0.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z)), 2)
  main.df[i,]$C123.h.ske.first.abv.0.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C123.h.kur.first.abv.0.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z), 2)
  main.df[i,]$C123.h.p25.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.25)[[1]]
  main.df[i,]$C123.h.p50.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.50)[[1]]
  main.df[i,]$C123.h.p75.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.75)[[1]]
  main.df[i,]$C123.h.p80.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.80)[[1]]
  main.df[i,]$C123.h.p90.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.90)[[1]]
  main.df[i,]$C123.h.p95.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.95)[[1]]
  main.df[i,]$C123.h.p99.first.abv.0.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1,]$Z, 0.99)[[1]]
  # 1.0m cut off
  main.df[i,]$C123.h.avg.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C123.h.qav.first.abv.1.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z^2), 2)
  main.df[i,]$C123.h.std.first.abv.1.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z)), 2)
  main.df[i,]$C123.h.ske.first.abv.1.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C123.h.kur.first.abv.1.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z), 2)
  main.df[i,]$C123.h.p25.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.25)[[1]]
  main.df[i,]$C123.h.p50.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.50)[[1]]
  main.df[i,]$C123.h.p75.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.75)[[1]]
  main.df[i,]$C123.h.p80.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.80)[[1]]
  main.df[i,]$C123.h.p90.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.90)[[1]]
  main.df[i,]$C123.h.p95.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.95)[[1]]
  main.df[i,]$C123.h.p99.first.abv.1.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 1.0,]$Z, 0.99)[[1]]
  # 2.0m cut off
  main.df[i,]$C123.h.avg.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C123.h.qav.first.abv.2.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z^2), 2)
  main.df[i,]$C123.h.std.first.abv.2.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z)), 2)
  main.df[i,]$C123.h.ske.first.abv.2.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C123.h.kur.first.abv.2.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z), 2)
  main.df[i,]$C123.h.p25.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.25)[[1]]
  main.df[i,]$C123.h.p50.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.50)[[1]]
  main.df[i,]$C123.h.p75.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.75)[[1]]
  main.df[i,]$C123.h.p80.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.80)[[1]]
  main.df[i,]$C123.h.p90.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.90)[[1]]
  main.df[i,]$C123.h.p95.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.95)[[1]]
  main.df[i,]$C123.h.p99.first.abv.2.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.0,]$Z, 0.99)[[1]]
  # 2.7m cut off
  main.df[i,]$C123.h.avg.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C123.h.qav.first.abv.2.7m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z^2), 2)
  main.df[i,]$C123.h.std.first.abv.2.7m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z)), 2)
  main.df[i,]$C123.h.ske.first.abv.2.7m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C123.h.kur.first.abv.2.7m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z), 2)
  main.df[i,]$C123.h.p25.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.25)[[1]]
  main.df[i,]$C123.h.p50.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.50)[[1]]
  main.df[i,]$C123.h.p75.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.75)[[1]]
  main.df[i,]$C123.h.p80.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.80)[[1]]
  main.df[i,]$C123.h.p90.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.90)[[1]]
  main.df[i,]$C123.h.p95.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.95)[[1]]
  main.df[i,]$C123.h.p99.first.abv.2.7m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 2.7,]$Z, 0.99)[[1]]
  # 5.0m cut off
  main.df[i,]$C123.h.avg.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C123.h.qav.first.abv.5.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z^2), 2)
  main.df[i,]$C123.h.std.first.abv.5.0m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z)), 2)
  main.df[i,]$C123.h.ske.first.abv.5.0m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C123.h.kur.first.abv.5.0m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z), 2)
  main.df[i,]$C123.h.p25.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.25)[[1]]
  main.df[i,]$C123.h.p50.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.50)[[1]]
  main.df[i,]$C123.h.p75.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.75)[[1]]
  main.df[i,]$C123.h.p80.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.80)[[1]]
  main.df[i,]$C123.h.p90.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.90)[[1]]
  main.df[i,]$C123.h.p95.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.95)[[1]]
  main.df[i,]$C123.h.p99.first.abv.5.0m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 5.0,]$Z, 0.99)[[1]]
  # 7.4m cut off
  main.df[i,]$C123.h.avg.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C123.h.qav.first.abv.7.4m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z^2), 2)
  main.df[i,]$C123.h.std.first.abv.7.4m <- round(sqrt(var(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z)), 2)
  main.df[i,]$C123.h.ske.first.abv.7.4m <- round(skewness(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C123.h.kur.first.abv.7.4m <- round(kurtosis(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z), 2)
  main.df[i,]$C123.h.p25.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.25)[[1]]
  main.df[i,]$C123.h.p50.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.50)[[1]]
  main.df[i,]$C123.h.p75.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.75)[[1]]
  main.df[i,]$C123.h.p80.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.80)[[1]]
  main.df[i,]$C123.h.p90.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.90)[[1]]
  main.df[i,]$C123.h.p95.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.95)[[1]]
  main.df[i,]$C123.h.p99.first.abv.7.4m <- quantile(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 7.4,]$Z, 0.99)[[1]]
  # 20.0m cut off
  main.df[i,]$C123.h.avg.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$Z), 2)
  main.df[i,]$C123.h.qav.first.abv.20.0m <- round(mean(plot.Step6.tmp[plot.Step6.tmp$Channel!=0 & plot.Step6.tmp$Ecno.number==1 & plot.Step6.tmp$Z > 20.0,]$Z^2), 2)
  
  if (i==length(files.list.Step6)) {toc()} ### just a timer stop
}


write.csv(main.df, "main.df.csv", row.names=FALSE)
