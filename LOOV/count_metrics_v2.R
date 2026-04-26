### this is to replace wrong cover metrics for C12 from the first version of the script.



### Step 1 - calculate cov, dns, and ndns metrics

rm(list = ls())

setwd("LOOV")

CFS.DF.Unique <- read.csv("CFS.DF.Unique.v4_Jan2025v1.csv")

attach(CFS.DF.Unique)


CFS.DF.Unique$C3.cov.abv.1.0m = counts.C3.first.abv.1.0m/counts.C3.first.abv.0.0m
CFS.DF.Unique$C3.cov.abv.2.0m = counts.C3.first.abv.2.0m/counts.C3.first.abv.0.0m
CFS.DF.Unique$C3.cov.abv.2.7m = counts.C3.first.abv.2.7m/counts.C3.first.abv.0.0m  
CFS.DF.Unique$C3.cov.abv.5.0m = counts.C3.first.abv.5.0m/counts.C3.first.abv.0.0m
CFS.DF.Unique$C3.cov.abv.7.4m = counts.C3.first.abv.7.4m/counts.C3.first.abv.0.0m

CFS.DF.Unique$C3.dns.abv.1.0m = counts.C3.all.abv.1.0m/counts.C3.all.abv.0.0m
CFS.DF.Unique$C3.dns.abv.2.0m = counts.C3.all.abv.2.0m/counts.C3.all.abv.0.0m
CFS.DF.Unique$C3.dns.abv.2.7m = counts.C3.all.abv.2.7m/counts.C3.all.abv.0.0m  
CFS.DF.Unique$C3.dns.abv.5.0m = counts.C3.all.abv.5.0m/counts.C3.all.abv.0.0m
CFS.DF.Unique$C3.dns.abv.7.4m = counts.C3.all.abv.7.4m/counts.C3.all.abv.0.0m

CFS.DF.Unique$C3.ndns.abv.0.0m = counts.C3.all.abv.0.0m/counts.C3.first.abv.0.0m
CFS.DF.Unique$C3.ndns.abv.1.0m = counts.C3.all.abv.1.0m/counts.C3.first.abv.0.0m
CFS.DF.Unique$C3.ndns.abv.2.0m = counts.C3.all.abv.2.0m/counts.C3.first.abv.0.0m
CFS.DF.Unique$C3.ndns.abv.2.7m = counts.C3.all.abv.2.7m/counts.C3.first.abv.0.0m  
CFS.DF.Unique$C3.ndns.abv.5.0m = counts.C3.all.abv.5.0m/counts.C3.first.abv.0.0m
CFS.DF.Unique$C3.ndns.abv.7.4m = counts.C3.all.abv.7.4m/counts.C3.first.abv.0.0m

CFS.DF.Unique$C12.cov.abv.1.0m = (counts.C1.first.abv.1.0m+counts.C2.first.abv.1.0m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)
CFS.DF.Unique$C12.cov.abv.2.0m = (counts.C1.first.abv.2.0m+counts.C2.first.abv.2.0m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)
CFS.DF.Unique$C12.cov.abv.2.7m = (counts.C1.first.abv.2.7m+counts.C2.first.abv.2.7m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)
CFS.DF.Unique$C12.cov.abv.5.0m = (counts.C1.first.abv.5.0m+counts.C2.first.abv.5.0m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)
CFS.DF.Unique$C12.cov.abv.7.4m = (counts.C1.first.abv.7.4m+counts.C2.first.abv.7.4m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)

CFS.DF.Unique$C12.dns.abv.1.0m = (counts.C1.all.abv.1.0m+counts.C2.all.abv.1.0m)/(counts.C1.all.abv.0.0m+counts.C2.all.abv.0.0m)
CFS.DF.Unique$C12.dns.abv.2.0m = (counts.C1.all.abv.2.0m+counts.C2.all.abv.2.0m)/(counts.C1.all.abv.0.0m+counts.C2.all.abv.0.0m)
CFS.DF.Unique$C12.dns.abv.2.7m = (counts.C1.all.abv.2.7m+counts.C2.all.abv.2.7m)/(counts.C1.all.abv.0.0m+counts.C2.all.abv.0.0m)
CFS.DF.Unique$C12.dns.abv.5.0m = (counts.C1.all.abv.5.0m+counts.C2.all.abv.5.0m)/(counts.C1.all.abv.0.0m+counts.C2.all.abv.0.0m)
CFS.DF.Unique$C12.dns.abv.7.4m = (counts.C1.all.abv.7.4m+counts.C2.all.abv.7.4m)/(counts.C1.all.abv.0.0m+counts.C2.all.abv.0.0m)

CFS.DF.Unique$C12.ndns.abv.0.0m = (counts.C1.all.abv.0.0m+counts.C2.all.abv.0.0m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)
CFS.DF.Unique$C12.ndns.abv.1.0m = (counts.C1.all.abv.1.0m+counts.C2.all.abv.1.0m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)
CFS.DF.Unique$C12.ndns.abv.2.0m = (counts.C1.all.abv.2.0m+counts.C2.all.abv.2.0m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)
CFS.DF.Unique$C12.ndns.abv.2.7m = (counts.C1.all.abv.2.7m+counts.C2.all.abv.2.7m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)
CFS.DF.Unique$C12.ndns.abv.5.0m = (counts.C1.all.abv.5.0m+counts.C2.all.abv.5.0m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)
CFS.DF.Unique$C12.ndns.abv.7.4m = (counts.C1.all.abv.7.4m+counts.C2.all.abv.7.4m)/(counts.C1.first.abv.0.0m+counts.C2.first.abv.0.0m)

detach(CFS.DF.Unique)
#write.csv(names(CFS.DF.Unique), "CFS.DF.Unique.v4_Jan2025v2.csv")
write.csv(CFS.DF.Unique, "CFS.DF.Unique.v4_Jan2025v2.csv")



