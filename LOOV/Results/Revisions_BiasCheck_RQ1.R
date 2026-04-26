# ---- Sqrt-stream: 4-fold LORO bias tests for two best models (A, B) ----
## this is for revisions for Table with best BSS and Best LORO models
## we want to see if bias is statistically significant


### updated models from df.agb_l_v3.csv

rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

suppressPackageStartupMessages({
  library(dplyr)
})

# -------------------------------
# Data & regions
# -------------------------------
df_main_file <- "CFS.DF.Unique.v4_Jan2025v3.csv"

# Fixed n per region for SE_robust
regions  <- c("FPROV","FLIARD","FSIMP","HAYRIV")
n_plots  <- c(FPROV = 43, FLIARD = 47, FSIMP = 34, HAYRIV = 39)

# Read and build agb_l; keep NA -> 0 as in your pipeline
df <- read.csv(df_main_file)
df <- df %>%
  mutate(agb_l = Large_LS + Large_LF + Small_LS + Small_LF) %>%
  replace(is.na(.), 0)

stopifnot("LOCATION" %in% names(df))

# -------------------------------
# Define models (predictor sets)
# -------------------------------
models_list <- list(
  A = c("C12.h.avg.all.abv.0.0m", "C12.h.p25.first.abv.0.0m", "C2.int.avg.single.abv.5.0m"),
  B = c("C2.h.ske.all.abv.0.0m", "C2.h.avg.all.abv.2.0m", "C2.h.ske.first.abv.2.0m")
)

		
# Ensure predictors exist
stopifnot(all(unlist(models_list) %in% names(df)))

# -------------------------------
# Helpers
# -------------------------------
rmse_fun  <- function(x) sqrt(mean(x^2))
vars_str  <- function(v) paste(v, collapse = " + ")

evaluate_sqrt_model <- function(label, vars) {
  out <- data.frame()
  for (excluded in regions) {
    # Split
    df_tr <- df %>% filter(LOCATION != excluded)
    df_te <- df %>% filter(LOCATION == excluded)
    
    # Fit on sqrt-scale, predictors raw
    train <- df_tr[, c("agb_l", vars), drop = FALSE]
    train$sqrt_agb_l <- sqrt(train$agb_l)
    form  <- as.formula(paste("sqrt_agb_l ~", paste(vars, collapse = " + ")))
    fit   <- lm(form, data = train)
    sm    <- summary(fit)
    
    # Predict to held-out region; back-transform (parametric)
    newX        <- as.data.frame(df_te[, vars, drop = FALSE])
    pred_sqrt   <- predict(fit, newdata = newX)
    pred_agb    <- (pred_sqrt^2) + (sm$sigma^2)
    
    # Residuals on AGB scale
    obs         <- df_te$agb_l
    resid       <- obs - pred_agb
    
    # Metrics per fold
    r_rmse      <- rmse_fun(resid)
    r_bias      <- mean(resid)
    denom_mean  <- mean(obs)                 # for % metrics (validation region mean AGB)
    r_rmse_pct  <- 100 * r_rmse / denom_mean
    r_bias_pct  <- 100 * r_bias / denom_mean
    
    # SE_robust and bias in SE units
    r_SE        <- r_rmse / sqrt(n_plots[[excluded]])
    r_bias_SE   <- r_bias / r_SE
    
    # Significance tests of bias = 0 (two-sided)
    t_out <- t.test(resid, mu = 0, alternative = "two.sided")
    # Wilcoxon (large-sample/with ties safe)
    w_out <- tryCatch(
      wilcox.test(resid, mu = 0, alternative = "two.sided", exact = FALSE, correct = FALSE),
      error = function(e) list(p.value = NA_real_)
    )
    
    out <- rbind(out, data.frame(
      model            = label,
      model_form       = "Sqrt",
      vars             = vars_str(vars),
      excluded_region  = excluded,
      n_val            = length(resid),
      rmse             = r_rmse,
      rmse_pct         = r_rmse_pct,
      bias             = r_bias,
      bias_pct         = r_bias_pct,
      SE_robust        = r_SE,
      bias_over_SE     = r_bias_SE,
      p_t              = as.numeric(t_out$p.value),
      p_wilcox         = as.numeric(w_out$p.value),
      sig_t            = as.integer(t_out$p.value < 0.05),
      sig_wilcox       = as.integer(!is.na(w_out$p.value) && w_out$p.value < 0.05),
      stringsAsFactors = FALSE
    ))
  }
  out
}

# -------------------------------
# Run both models and save
# -------------------------------
resA <- evaluate_sqrt_model("A", models_list$A)
resB <- evaluate_sqrt_model("B", models_list$B)

results_all <- bind_rows(resA, resB) %>%
  arrange(model, excluded_region)

out_dir  <- "Results/Sqrt_bestmodels_LORO"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
out_file <- file.path(out_dir, "Sqrt_BiasTests_LORO_v1.csv")

write.csv(results_all, out_file, row.names = FALSE)
message("Wrote: ", out_file)
