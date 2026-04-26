# 3-fold LORO internal validation (per excluded region) with fixed output schema
# One CSV per excluded region; each CSV has exactly nrow(models) rows

rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

library(dplyr)

# -------------------------------------------------------------------
# Inputs
# -------------------------------------------------------------------
df_main_file   <- "CFS.DF.Unique.v4_Jan2025v3.csv"
models_file    <- "Filtered_Models_1SE_v9.csv"

# Output
out_dir <- "3fold_LORO"
if (!dir.exists(out_dir)) dir.create(out_dir)

# Regions and fixed n for SE_robust rule
regions <- c("FPROV","FLIARD","FSIMP","HAYRIV")
n_plots <- c(FPROV = 43, FLIARD = 47, FSIMP = 34, HAYRIV = 39)

# -------------------------------------------------------------------
# Load data and construct agb_l
# -------------------------------------------------------------------
df <- read.csv(df_main_file)
df <- df %>%
  mutate(
    agb_l = Large_LS + Large_LF + Small_LS + Small_LF
  ) %>%
  replace(is.na(.), 0)

stopifnot("LOCATION" %in% names(df))

# Preselected models (x1,x2,x3, model_form, final.rank.n.rmse.LORO)
models <- read.csv(models_file, stringsAsFactors = FALSE)

vars_string <- function(v) paste(na.omit(v), collapse = " + ")

# -------------------------------------------------------------------
# Model-form evaluators (predict AGB units)
# -------------------------------------------------------------------
predict_linear <- function(df_tr, df_te, vars) {
  form <- as.formula(paste("agb_l ~", paste(vars, collapse = " + ")))
  fit  <- lm(form, data = df_tr)
  pred <- as.numeric(predict(fit, newdata = df_te))
  list(pred = pred, sigma = summary(fit)$sigma)
}

predict_loglog <- function(df_tr, df_te, vars) {
  for (v in vars) {
    lv <- paste0(v, "_log")
    df_tr[[lv]] <- log(df_tr[[v]])
    df_te[[lv]] <- log(df_te[[v]])
  }
  df_tr$log_agb_l <- log(df_tr$agb_l)
  log_vars <- paste0(vars, "_log")
  form <- as.formula(paste("log_agb_l ~", paste(log_vars, collapse = " + ")))
  fit  <- lm(form, data = df_tr)
  sm   <- summary(fit)
  log_pred <- as.numeric(predict(fit, newdata = df_te))
  pred <- exp(log_pred) * exp(0.5 * sm$sigma^2)
  list(pred = pred, sigma = sm$sigma)
}

predict_sqrt <- function(df_tr, df_te, vars) {
  df_tr$sqrt_agb_l <- sqrt(df_tr$agb_l)
  form <- as.formula(paste("sqrt_agb_l ~", paste(vars, collapse = " + ")))
  fit  <- lm(form, data = df_tr)
  sm   <- summary(fit)
  sqrt_pred <- as.numeric(predict(fit, newdata = df_te))
  pred <- (sqrt_pred^2) + (sm$sigma^2)
  list(pred = pred, sigma = sm$sigma)
}

predict_by_form <- function(model_form, df_tr, df_te, vars) {
  f <- tolower(model_form)
  if (f == "linear") return(predict_linear(df_tr, df_te, vars))
  if (f == "loglog") return(predict_loglog(df_tr, df_te, vars))
  if (f == "sqrt")   return(predict_sqrt(df_tr, df_te, vars))
  stop("Unknown model_form: ", model_form)
}

rmse_fun <- function(obs, pred) sqrt(mean((obs - pred)^2))
bias_fun <- function(obs, pred) mean(obs - pred)

# Build per-region column names (same order for all files)
reg_cols <- unlist(lapply(regions, function(r) {
  c(paste0("rmse.", r),
    paste0("rmse_pct.", r),
    paste0("bias.", r),
    paste0("bias_pct.", r),
    paste0("SE_robust.", r),
    paste0("pass_1SE.", r))
}))


results_list <- list()


# -------------------------------------------------------------------
# Main: loop over excluded regions, produce one CSV each
# -------------------------------------------------------------------
for (excluded in regions) {
  kept_regions <- setdiff(regions, excluded)
  
  # Pre-allocate results (exactly one row per input model)
  results <- data.frame(
    excluded_region = rep(excluded, nrow(models)),
    model_id   = models$final.rank.n.rmse.LORO,
    model_form = models$model_form,
    vars       = apply(models[, c("x1","x2","x3")], 1,
                       function(x) vars_string(na.omit(x))),
    matrix(NA_real_, nrow = nrow(models), ncol = length(reg_cols),
           dimnames = list(NULL, reg_cols)),
    # no PASS_3fold column per your revised spec
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  
  # For each model, run 3-fold LORO across kept regions
  for (i in seq_len(nrow(models))) {
    rowm <- models[i, ]
    model_form <- rowm$model_form
    vars <- na.omit(unlist(rowm[c("x1","x2","x3")]))
    vars <- vars[vars != ""]
    
    # If variables are missing in df, leave all metrics NA (but still keep the row)
    if (length(vars) == 0 || !all(vars %in% names(df))) {
      next
    }
    
    # Do three folds: each kept region acts as validation once
    for (val_region in kept_regions) {
      train_regions <- setdiff(kept_regions, val_region)
      df_tr <- df %>% filter(LOCATION %in% train_regions)
      df_te <- df %>% filter(LOCATION == val_region)
      
      # Predict
      pred_obj <- predict_by_form(model_form, df_tr, df_te, vars)
      obs  <- df_te$agb_l
      pred <- pred_obj$pred
      
      # Metrics
      r_rmse <- rmse_fun(obs, pred)
      r_bias <- bias_fun(obs, pred)
      
      denom_mean <- mean(obs, na.rm = TRUE)
      if (is.finite(denom_mean) && denom_mean > 0) {
        r_rmse_pct <- 100 * r_rmse / denom_mean
        r_bias_pct <- 100 * r_bias / denom_mean
      } else {
        r_rmse_pct <- NA_real_
        r_bias_pct <- NA_real_
      }
      
      r_SE <- r_rmse / sqrt(n_plots[[val_region]])
      r_pass <- as.integer(abs(r_bias) < r_SE)
      
      # Write into the per-region columns for this model/region
      results[i, paste0("rmse.",      val_region)] <- r_rmse
      results[i, paste0("rmse_pct.",  val_region)] <- r_rmse_pct
      results[i, paste0("bias.",      val_region)] <- r_bias
      results[i, paste0("bias_pct.",  val_region)] <- r_bias_pct
      results[i, paste0("SE_robust.", val_region)] <- r_SE
      results[i, paste0("pass_1SE.",  val_region)] <- r_pass
    }
    
    # For the excluded region, columns stay as NA (already initialized)
  }
  
  # ----- Final PASS_3fold: all three kept regions must pass -----
  pass_cols <- paste0("pass_1SE.", kept_regions)          # e.g., pass_1SE.FPROV, pass_1SE.FLIARD, pass_1SE.FSIMP
  pass_mat  <- as.matrix(results[, pass_cols])
  
  results$PASS_3fold <- apply(
    pass_mat, 1,
    function(x) {
      if (any(is.na(x))) NA_integer_ else as.integer(all(x == 1))
    }
  )
  
  # ----- Bias relative to 1SE per region -----
  for (r in regions) {
    bcol  <- paste0("bias.", r)
    secol <- paste0("SE_robust.", r)
    outc  <- paste0("bias_over_SE.", r)
    results[[outc]] <- results[[bcol]] / results[[secol]]  # NA for excluded region stays NA
  }
  # ----- Reorder columns: put PASS_3fold next to vars; interleave region blocks -----
  base_cols <- c("excluded_region", "model_id", "model_form", "vars", "PASS_3fold")
  
  region_blocks <- unlist(lapply(regions, function(r) {
    c(paste0("rmse.", r),
      paste0("rmse_pct.", r),
      paste0("bias.", r),
      paste0("bias_pct.", r),
      paste0("SE_robust.", r),
      paste0("bias_over_SE.", r),   # <-- new
      paste0("pass_1SE.", r))
  }))
  
  new_order <- c(base_cols, region_blocks)
  new_order <- intersect(new_order, names(results))  # safety
  results   <- results[, new_order, drop = FALSE]
  
  
  
  # Order rows by model_id for readability
  results <- results %>% arrange(model_id)
  
  # Keep a copy for the final “pass all four” aggregation
  results_list[[excluded]] <- results
  
  
  # Write CSV with excluded region in the filename
  out_file <- file.path(out_dir, paste0("ThreeFold_LORO_excluded_", excluded, ".csv"))
  write.csv(results, out_file, row.names = FALSE)
  message("Wrote: ", out_file, "  (", nrow(results), " models)")
}

# ===== Aggregate models that pass PASS_3fold for all four excluded regions =====
# 1) Collect the set of model_ids that passed in each excluded-region run
pass_sets <- lapply(results_list, function(df_one) {
  df_one %>% dplyr::filter(PASS_3fold == 1) %>% dplyr::pull(model_id) %>% unique()
})

# 2) Intersection: models that passed in ALL four runs
passed_all <- Reduce(intersect, pass_sets)

# 3) Bind the rows (keep the same format as per-region outputs)
results_pass_all <- dplyr::bind_rows(lapply(results_list, function(df_one) {
  df_one %>% dplyr::filter(model_id %in% passed_all)
})) %>%
  dplyr::arrange(model_id, excluded_region)

# 4) Save
out_file_all <- file.path(out_dir, "ThreeFold_LORO_passAllFour_v2.csv")
write.csv(results_pass_all, out_file_all, row.names = FALSE)
message("Wrote: ", out_file_all, "  (", nrow(results_pass_all), " rows across four regions)")

# ===== Aggregate models that have |bias_over_SE.| < 1.5 for all folds in all four runs =====
# For each excluded-region results frame, check ONLY the kept regions (non-NA columns)
small_bias_sets <- lapply(names(results_list), function(excl) {
  df_one <- results_list[[excl]]
  kept   <- setdiff(regions, excl)
  ratio_cols <- paste0("bias_over_SE.", kept)
  
  # row-wise: all(abs(bias_over_SE.<kept>) < 1.5)
  pass_row <- apply(abs(as.matrix(df_one[, ratio_cols, drop = FALSE])) < 1.5, 1, function(x) {
    if (any(is.na(x))) FALSE else all(x)
  })
  
  df_one$model_id[pass_row]
})
names(small_bias_sets) <- names(results_list)

# Intersection across the four runs: models that pass the small-bias criterion everywhere
passed_smallbias_all <- Reduce(intersect, small_bias_sets)

# Bind rows from each run, keep same schema/format as per-region outputs
results_smallbias_all <- dplyr::bind_rows(lapply(results_list, function(df_one) {
  df_one %>% dplyr::filter(model_id %in% passed_smallbias_all)
})) %>%
  dplyr::arrange(model_id, excluded_region)

# Save
out_file_small <- file.path(out_dir, "ThreeFold_LORO_smallBiasAllFour_thr1p5_v2.csv")
write.csv(results_smallbias_all, out_file_small, row.names = FALSE)
message("Wrote: ", out_file_small, "  (", nrow(results_smallbias_all), " rows across four regions)")
