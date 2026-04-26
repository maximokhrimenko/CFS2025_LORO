### this is to check why those two are the same: C2.h.qav.all.abv.1.0mSqrt and C2.h.qav.first.abv.1.0mSqrt

CFS.DF.Unique.v3 <- read.csv("D:/MyR_projects/CFS2025_LORO/CFS.DF.Unique.v3.csv")


mean(C2.h.ske.all.abv.0.0m)



C2.h.ske.all.abv.0.0m	C2.h.p95.first.abv.5.0m	C2.iz2.all.abv.1.0m



plot(CFS.DF.Unique.v3$C2.h.qav.all.abv.1.0mSqrt, CFS.DF.Unique.v3$C2.h.qav.first.abv.1.0mSqrt)

plot(CFS.DF.Unique.v3$C2.h.avg.all.abv.2.0m, CFS.DF.Unique.v3$C2.h.avg.first.abv.2.0m)


attach(CFS.DF.Unique.v3)
cor(C1.h.p50.all.abv.2.0m, C1.h.p50.first.abv.2.0m)

identical(counts.C2.all.abv.5.0m, counts.C2.first.abv.5.0m) 

plot(C1.h.avg.all.abv.0.0m, C2.h.avg.all.abv.0.0m)
cor(C1.h.avg.all.abv.0.0m, C2.h.avg.all.abv.0.0m)

plot(C1.h.avg.all.abv.0.0m, C3.h.avg.all.abv.0.0m)
cor(C1.h.avg.all.abv.0.0m, C3.h.avg.all.abv.0.0m)
# Compute correlation excluding NA values
cor(C1.h.avg.all.abv.0.0m, C3.h.avg.all.abv.0.0m, use = "complete.obs")


# Count rows with "counts.C3.all.abv.0.0m" < 200
row_count <- sum(CFS.DF.Unique.v3$counts.C3.all.abv.0.0m < 200, na.rm = TRUE)

# Print the result
print(row_count)


# Count NA values in the specified column
na_count <- sum(is.na(CFS.DF.Unique.v3$counts.C1.all.abv.0.0m))

# Print the result
print(na_count)

var(C1.h.avg.all.abv.0.0m)  # Check variance of the first column
var(C3.h.avg.all.abv.0.0m)  # Check variance of the second column

any(is.na(C3.h.avg.all.abv.0.0m))

class(C3.h.avg.all.abv.0.0m)  # Ensure it's numeric
unique(C3.h.avg.all.abv.0.0m) # Inspect unique values
which(is.na(C3.h.avg.all.abv.0.0m))  # Returns row indices with NA

sum(C3.h.avg.all.abv.0.0m == "NA", na.rm = TRUE)  # Count occurrences of the string "NA"


problem_rows <- which(is.na(C3.h.avg.all.abv.0.0m))
problem_rows
C3.h.avg.all.abv.0.0m[problem_rows]


