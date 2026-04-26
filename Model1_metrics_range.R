library(dplyr)
library(tidyr)
library(purrr)
library(dplyr)
library(purrr)

summary_stats <- \(x) {
  tibble(
    min = min(x, na.rm = TRUE),
    q25 = quantile(x, 0.25, na.rm = TRUE),
    median = median(x, na.rm = TRUE),
    q75 = quantile(x, 0.75, na.rm = TRUE),
    max = max(x, na.rm = TRUE),
    mean = mean(x, na.rm = TRUE)
  )
}

compute_summary_stats <- function(data, columns) {
  purrr::map_dfr(columns, \(col) {
    summary_stats(data[[col]]) |>
      mutate(variable = col, .before = 1)
  })
}

columns <- c(
  "C2.h.ske.all.abv.0.0m",
  "C2.h.p95.first.abv.5.0m",
  "C2.iz2.all.abv.1.0m"
)

compute_summary_stats(df, columns)

write.csv(compute_summary_stats(df, columns), "Model1.variables.ranges.csv")
getwd()
