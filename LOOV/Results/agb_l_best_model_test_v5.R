### Full R script: regional CV with normality‐conditional CIs for mean bias

# Clear workspace and set working directory
rm(list = ls())
setwd("D:/MyR_projects/CFS2025_LORO/LOOV/Results")

# Load libraries
library(dplyr)
library(lmtest)      # coeftest()
library(sandwich)    # vcovHC()
library(tidyverse)   # data wrangling
library(boot)        # bootstrapping

# Read data
df            <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")
models.var.cv <- read.csv("input_models_v1.csv")  # x1,x2,x3,...

# Compute agb_l
df_filtered <- df %>%
  mutate(agb_l = Large_LS + Large_LF + Small_LS + Small_LF) %>%
  replace(is.na(.), 0)

# Prepare region info
locations            <- unique(df_filtered$LOCATION)
mean_agb_all         <- mean(df_filtered$agb_l, na.rm = TRUE)
mean_agb_by_region   <- df_filtered %>%
  group_by(LOCATION) %>%
  summarize(mean_agb = mean(agb_l, na.rm = TRUE)) %>%
  pull(mean_agb)
names(mean_agb_by_region) <- locations

# Container for results
results_list <- vector("list", nrow(models.var.cv))

# Loop over each candidate model
for (i in seq_len(nrow(models.var.cv))) {
  # Build formula from non-NA predictors
  vars <- na.omit(unlist(models.var.cv[i, c("x1","x2","x3")]))
  if (length(vars)==0) next
  fmla <- as.formula(paste("agb_l ~", paste(vars, collapse = " + ")))
  
  # Initialize result row
  mr <- data.frame(
    Model_ID             = i,
    Metrics_input        = models.var.cv$Metrics_input[i],
    model_form           = models.var.cv$model_form[i],
    rank.rmse            = models.var.cv$rank.rmse[i],
    rank.n.rmse.LORO     = models.var.cv$rank.n.rmse.LORO[i],
    max.VIF              = models.var.cv$max.VIF[i],
    X1                   = models.var.cv$x1[i],
    X2                   = models.var.cv$x2[i],
    X3                   = models.var.cv$x3[i],
    RMSE_input_percent   = models.var.cv$rmse[i] / mean_agb_all * 100
  )
  
  # Loop over regions
  for (loc in locations) {
    train_data <- filter(df_filtered, LOCATION != loc)
    test_data  <- filter(df_filtered, LOCATION == loc)
    if (nrow(train_data) < length(vars)+1 || nrow(test_data) < 3) next
    
    # Fit and predict
    mdl <- tryCatch(lm(fmla, data=train_data), error=function(e) NULL)
    if (is.null(mdl)) next
    test_data$pred <- predict(mdl, newdata=test_data)
    test_data$error <- test_data$pred - test_data$agb_l
    
    # RMSE, bias, SE
    rmse   <- sqrt(mean(test_data$error^2))
    bias   <- mean(test_data$error)
    bias_se<- sd(test_data$error)/sqrt(nrow(test_data))
    
    # Store percent metrics
    mr[[paste0("RMSE_", loc, "_percent")]]        <- rmse  / mean_agb_by_region[loc] * 100
    mr[[paste0("Bias_", loc, "_percent")]]        <- bias  / mean_agb_by_region[loc] * 100
    mr[[paste0("Bias_StdErr_", loc, "_percent")]] <- bias_se / mean_agb_by_region[loc] * 100
    
    # Classical t-test p-value
    mr[[paste0("Bias_pValue_", loc)]] <- t.test(test_data$error, mu=0)$p.value
    
    # HC3 robust test
    vm   <- lm(error ~ 1, data=test_data)
    hc3  <- coeftest(vm, vcov=vcovHC(vm, type="HC3"))
    mr[[paste0("Bias_StdErr_HC3_", loc, "_percent")]] <- 
      hc3["(Intercept)","Std. Error"] / mean_agb_by_region[loc] * 100
    mr[[paste0("Bias_pValue_HC3_", loc)]] <- hc3["(Intercept)","Pr(>|t|)"]
    
    # 1 SE heuristic
    robust_se <- (rmse/sqrt(nrow(test_data))) / mean_agb_by_region[loc] * 100
    mr[[paste0("RobustSE_", loc, "_percent")]] <- robust_se
    mr[[paste0("1SE_Test_", loc)]] <- ifelse(
      abs(mr[[paste0("Bias_", loc, "_percent")]]) <= robust_se, "Pass","Fail"
    )
    
    # Shapiro–Wilk normality
    sw <- shapiro.test(test_data$error)
    mr[[paste0("ShapiroW_", loc, "_W")]] <- sw$statistic
    mr[[paste0("ShapiroW_", loc, "_p")]] <- sw$p.value
    
    # Conditional CI for mean bias
    if (sw$p.value > 0.05) {
      # parametric t-test CI
      tt <- t.test(test_data$error, mu=0, conf.level=0.95)
      ci <- tt$conf.int
    } else {
      # percentile bootstrap CI
      set.seed(123)
      boot_mean <- function(d,i) mean(d[i])
      b <- boot(test_data$error, statistic=boot_mean, R=2000)
      ci <- boot.ci(b, type="perc")$percent[4:5]
    }
    mr[[paste0("Bias_CI_low_",  loc, "_percent")]] <- ci[1] / mean_agb_by_region[loc] * 100
    mr[[paste0("Bias_CI_high_", loc, "_percent")]] <- ci[2] / mean_agb_by_region[loc] * 100
  }
  
  results_list[[i]] <- mr
}

# Combine and save
results <- bind_rows(results_list)
write.csv(results, "Regional_CV_With_Normality_Conditional_CIs.csv", row.names = FALSE)
print("Done: results saved to 'Regional_CV_With_Normality_Conditional_CIs.csv'")
