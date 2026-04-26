
library(dplyr)

CFS.DF <- read.csv("CFS.DF.Unique.v4_Jan2025v2.csv")

write.csv(names(CFS.DF), "names.metrics.csv")

CFS.DF  <- CFS.DF  %>% replace(is.na(.), 0)

cor(CFS.DF$C1.h.avg.all.abv.0.0m, CFS.DF$C2.h.avg.all.abv.0.0m)

cor(CFS.DF$C1.h.avg.all.abv.0.0m, CFS.DF$C3.h.avg.all.abv.0.0m)


cor(CFS.DF$C12.h.avg.all.abv.0.0m, CFS.DF$C2.h.avg.all.abv.0.0m)^2
cor(CFS.DF$C12.h.avg.all.abv.0.0m, CFS.DF$C1.h.avg.all.abv.0.0m)
cor(CFS.DF$C1.h.avg.all.abv.0.0m, CFS.DF$C2.h.avg.all.abv.0.0m)
cor(CFS.DF$C12.h.avg.all.abv.0.0m, CFS.DF$C3.h.avg.all.abv.0.0m)
cor(CFS.DF$C123.h.avg.all.abv.0.0m, CFS.DF$C1.h.avg.all.abv.0.0m)

cor(CFS.DF$C1.h.std.all.abv.0.0m, CFS.DF$C2.h.std.all.abv.0.0m)^2
cor(CFS.DF$C12.h.avg.all.abv.0.0m, CFS.DF$C1.h.avg.all.abv.0.0m)
cor(CFS.DF$C1.h.avg.all.abv.0.0m, CFS.DF$C2.h.avg.all.abv.0.0m)
cor(CFS.DF$C12.h.std.all.abv.0.0m, CFS.DF$C3.h.std.all.abv.0.0m)
cor(CFS.DF$C1.h.std.all.abv.0.0m, CFS.DF$C12.h.std.all.abv.0.0m)


cor(CFS.DF$C12.cov.abv.1.0m, CFS.DF$C2.cov.abv.1.0m)
cor(CFS.DF$C1.cov.abv.5.0m, CFS.DF$C2.cov.abv.5.0m)

cor(CFS.DF$C12.ndns.abv.1.0m, CFS.DF$C2.ndns.abv.1.0m)
cor(CFS.DF$C12.cov.abv.5.0m, CFS.DF$C2.cov.abv.5.0m)



cor(CFS.DF$C3.h.avg.all.abv.0.0m, CFS.DF$C3.h.avg.first.abv.0.0m)
cor(CFS.DF$C1.h.avg.all.abv.0.0m, CFS.DF$C2.h.avg.all.abv.0.0m)
cor(CFS.DF$C12.h.avg.all.abv.0.0m, CFS.DF$C3.h.avg.all.abv.0.0m)
cor(CFS.DF$C123.h.avg.all.abv.0.0m, CFS.DF$C1.h.avg.all.abv.0.0m
    
    
cor(CFS.DF$C1.h.qav.all.abv.1.0m, CFS.DF$C1.h.qav.first.abv.1.0m)

hist(C123.h.qav.first.abv.5.0m)

