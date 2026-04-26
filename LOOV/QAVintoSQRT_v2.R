#
# this script is to correct Sqrt quadratic metrics for first returns with cut offs - qav

### also calculate C12.h.max

rm(list = ls())

setwd("LOOV")

CFS.DF.Unique.v2 <- read.csv("CFS.DF.Unique.v4_Jan2025v2.csv")


## first qav
CFS.DF.Unique.v2$C1.h.qav.first.abv.0.0mSqrt = CFS.DF.Unique.v2$C1.h.qav.first.abv.0.0m^0.5
CFS.DF.Unique.v2$C1.h.qav.first.abv.1.0mSqrt = CFS.DF.Unique.v2$C1.h.qav.first.abv.1.0m^0.5
CFS.DF.Unique.v2$C1.h.qav.first.abv.2.0mSqrt = CFS.DF.Unique.v2$C1.h.qav.first.abv.2.0m^0.5
CFS.DF.Unique.v2$C1.h.qav.first.abv.2.7mSqrt = CFS.DF.Unique.v2$C1.h.qav.first.abv.2.7m^0.5
CFS.DF.Unique.v2$C1.h.qav.first.abv.5.0mSqrt = CFS.DF.Unique.v2$C1.h.qav.first.abv.5.0m^0.5
CFS.DF.Unique.v2$C1.h.qav.first.abv.7.4mSqrt = CFS.DF.Unique.v2$C1.h.qav.first.abv.7.4m^0.5
CFS.DF.Unique.v2$C1.h.qav.first.abv.20.0mSqrt = CFS.DF.Unique.v2$C1.h.qav.first.abv.20.0m^0.5

CFS.DF.Unique.v2$C2.h.qav.first.abv.0.0mSqrt = CFS.DF.Unique.v2$C2.h.qav.first.abv.0.0m^0.5
CFS.DF.Unique.v2$C2.h.qav.first.abv.1.0mSqrt = CFS.DF.Unique.v2$C2.h.qav.first.abv.1.0m^0.5
CFS.DF.Unique.v2$C2.h.qav.first.abv.2.0mSqrt = CFS.DF.Unique.v2$C2.h.qav.first.abv.2.0m^0.5
CFS.DF.Unique.v2$C2.h.qav.first.abv.2.7mSqrt = CFS.DF.Unique.v2$C2.h.qav.first.abv.2.7m^0.5
CFS.DF.Unique.v2$C2.h.qav.first.abv.5.0mSqrt = CFS.DF.Unique.v2$C2.h.qav.first.abv.5.0m^0.5
CFS.DF.Unique.v2$C2.h.qav.first.abv.7.4mSqrt = CFS.DF.Unique.v2$C2.h.qav.first.abv.7.4m^0.5
CFS.DF.Unique.v2$C2.h.qav.first.abv.20.0mSqrt = CFS.DF.Unique.v2$C2.h.qav.first.abv.20.0m^0.5

CFS.DF.Unique.v2$C3.h.qav.first.abv.0.0mSqrt = CFS.DF.Unique.v2$C3.h.qav.first.abv.0.0m^0.5
CFS.DF.Unique.v2$C3.h.qav.first.abv.1.0mSqrt = CFS.DF.Unique.v2$C3.h.qav.first.abv.1.0m^0.5
CFS.DF.Unique.v2$C3.h.qav.first.abv.2.0mSqrt = CFS.DF.Unique.v2$C3.h.qav.first.abv.2.0m^0.5
CFS.DF.Unique.v2$C3.h.qav.first.abv.2.7mSqrt = CFS.DF.Unique.v2$C3.h.qav.first.abv.2.7m^0.5
CFS.DF.Unique.v2$C3.h.qav.first.abv.5.0mSqrt = CFS.DF.Unique.v2$C3.h.qav.first.abv.5.0m^0.5
CFS.DF.Unique.v2$C3.h.qav.first.abv.7.4mSqrt = CFS.DF.Unique.v2$C3.h.qav.first.abv.7.4m^0.5
CFS.DF.Unique.v2$C3.h.qav.first.abv.20.0mSqrt = CFS.DF.Unique.v2$C3.h.qav.first.abv.20.0m^0.5

CFS.DF.Unique.v2$C12.h.qav.first.abv.0.0mSqrt = CFS.DF.Unique.v2$C12.h.qav.first.abv.0.0m^0.5
CFS.DF.Unique.v2$C12.h.qav.first.abv.1.0mSqrt = CFS.DF.Unique.v2$C12.h.qav.first.abv.1.0m^0.5
CFS.DF.Unique.v2$C12.h.qav.first.abv.2.0mSqrt = CFS.DF.Unique.v2$C12.h.qav.first.abv.2.0m^0.5
CFS.DF.Unique.v2$C12.h.qav.first.abv.2.7mSqrt = CFS.DF.Unique.v2$C12.h.qav.first.abv.2.7m^0.5
CFS.DF.Unique.v2$C12.h.qav.first.abv.5.0mSqrt = CFS.DF.Unique.v2$C12.h.qav.first.abv.5.0m^0.5
CFS.DF.Unique.v2$C12.h.qav.first.abv.7.4mSqrt = CFS.DF.Unique.v2$C12.h.qav.first.abv.7.4m^0.5
CFS.DF.Unique.v2$C12.h.qav.first.abv.20.0mSqrt = CFS.DF.Unique.v2$C12.h.qav.first.abv.20.0m^0.5

CFS.DF.Unique.v2$C123.h.qav.first.abv.0.0mSqrt = CFS.DF.Unique.v2$C123.h.qav.first.abv.0.0m^0.5
CFS.DF.Unique.v2$C123.h.qav.first.abv.1.0mSqrt = CFS.DF.Unique.v2$C123.h.qav.first.abv.1.0m^0.5
CFS.DF.Unique.v2$C123.h.qav.first.abv.2.0mSqrt = CFS.DF.Unique.v2$C123.h.qav.first.abv.2.0m^0.5
CFS.DF.Unique.v2$C123.h.qav.first.abv.2.7mSqrt = CFS.DF.Unique.v2$C123.h.qav.first.abv.2.7m^0.5
CFS.DF.Unique.v2$C123.h.qav.first.abv.5.0mSqrt = CFS.DF.Unique.v2$C123.h.qav.first.abv.5.0m^0.5
CFS.DF.Unique.v2$C123.h.qav.first.abv.7.4mSqrt = CFS.DF.Unique.v2$C123.h.qav.first.abv.7.4m^0.5
CFS.DF.Unique.v2$C123.h.qav.first.abv.20.0mSqrt = CFS.DF.Unique.v2$C123.h.qav.first.abv.20.0m^0.5

CFS.DF.Unique.v2$C12.h.max <- pmax(CFS.DF.Unique.v2$C1.h.max, CFS.DF.Unique.v2$C2.h.max)



# note, I rename inot V3 only now
write.csv(CFS.DF.Unique.v2, "CFS.DF.Unique.v4_Jan2025v3.csv", row.names = F)


