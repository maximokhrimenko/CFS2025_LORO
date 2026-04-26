### test if C3 is good in comparison to C1 and C2

library(ggplot2)
library(tidyr)
library(dplyr)

# Replace NA values in counts.C3.all.abv.0.0m with 0
CFS.DF.Unique.v3$counts.C3.all.abv.0.0m[is.na(CFS.DF.Unique.v3$counts.C3.all.abv.0.0m)] <- 0

# Remove outliers for C1 and C2 (values > 5000)
CFS.DF.Unique.v3 <- CFS.DF.Unique.v3 %>%
  filter(counts.C1.all.abv.0.0m <= 5000, counts.C2.all.abv.0.0m <= 5000)

# Reshape the data into long format
df_long <- CFS.DF.Unique.v3 %>%
  pivot_longer(
    cols = c(counts.C1.first.abv.0.0m, counts.C2.all.abv.0.0m, counts.C3.all.abv.0.0m), 
    names_to = "variable", 
    values_to = "value"
  )

# Create a histogram for all three columns
ggplot(df_long, aes(x = value, fill = variable)) +
  geom_histogram(alpha = 0.3, position = "identity", bins = 30) +  # More transparent histograms
  labs(
    title = "Histogram of Counts Variables (C1, C2, C3)",
    x = "Value",
    y = "Frequency",
    fill = "Variable"
  ) +
  theme_minimal()



library(ggplot2)
library(tidyr)
library(dplyr)

# Replace NA values in counts.C3.all.abv.0.0m with 0
CFS.DF.Unique.v3$counts.C3.all.abv.0.0m[is.na(CFS.DF.Unique.v3$counts.C3.all.abv.0.0m)] <- 0

# Reshape the data into long format
df_long <- CFS.DF.Unique.v3 %>%
  pivot_longer(
    cols = c(counts.C1.all.abv.0.0m, counts.C2.all.abv.0.0m, counts.C3.all.abv.0.0m), 
    names_to = "variable", 
    values_to = "value"
  )

# Create a histogram for all three columns
ggplot(df_long, aes(x = value, fill = variable)) +
  geom_histogram(alpha = 0.4, position = "identity", bins = 30) +  # Transparent histograms
  labs(
    title = "Histogram of Counts Variables (C1, C2, C3)",
    x = "Value",
    y = "Frequency",
    fill = "Variable"
  ) +
  theme_minimal()

library(ggplot2)
library(tidyr)
library(dplyr)

# Replace NA values in counts.C3.all.abv.0.0m with 0
CFS.DF.Unique.v3$counts.C3.all.abv.0.0m[is.na(CFS.DF.Unique.v3$counts.C3.all.abv.0.0m)] <- 0

# Reshape the data into long format
df_long <- CFS.DF.Unique.v3 %>%
  pivot_longer(
    cols = c(counts.C1.all.abv.0.0m, counts.C2.all.abv.0.0m, counts.C3.all.abv.0.0m), 
    names_to = "variable", 
    values_to = "value"
  )

# Create density plots (PDFs)
ggplot(df_long, aes(x = value, color = variable, fill = variable)) +
  geom_density(alpha = 0.4) +  # Transparent PDFs
  labs(
    title = "Probability Density Functions of Counts Variables (C1, C2, C3)",
    x = "Value",
    y = "Density",
    color = "Variable",
    fill = "Variable"
  ) +
  theme_minimal()


t_test_result <- t.test(
  CFS.DF.Unique.v3$counts.C1.all.abv.0.0m,
  CFS.DF.Unique.v3$counts.C2.all.abv.0.0m,
  paired = TRUE
)

print(t_test_result)


ks_test_result <- ks.test(
  CFS.DF.Unique.v3$counts.C1.all.abv.0.0m,
  CFS.DF.Unique.v3$counts.C3.all.abv.0.0m
)

print(ks_test_result)


wilcox_test_result <- wilcox.test(
  CFS.DF.Unique.v3$counts.C1.all.abv.0.0m,
  CFS.DF.Unique.v3$counts.C2.all.abv.0.0m,
  paired = TRUE
)

print(wilcox_test_result)


median_diff <- median(CFS.DF.Unique.v3$counts.C1.all.abv.0.0m - CFS.DF.Unique.v3$counts.C3.all.abv.0.0m, na.rm = TRUE)
print(median_diff)

poisson_model <- glm(
  counts.C2.all.abv.0.0m ~ counts.C1.all.abv.0.0m,
  family = poisson(link = "log"),
  data = CFS.DF.Unique.v3
)

summary(poisson_model)
