## run regsubsets first, then using $which get the list of the predictors and run LOOV validation
## SQRT(AGB) ~ raw predictors, parametric back-transform to AGB units

setwd("C:/Users/maxim.okhrimenko/Documents/myR_projects/CFS2022_models/LOOV")

library(leaps)
library(dplyr)
library(tidyverse)
library(caret)     # RMSE
library(car)       # VIF
library(lmtest)    # BP test
library(tictoc)

rm(list = ls())

setwd("LOOV/2025")

CFS.DF.modeling <- read.csv("CFS.DF.Unique.v4_Jan2025v3.csv")

CFS.DF.modeling$C3.h.max <- ifelse(CFS.DF.modeling$C3.h.max == "#NAME?", NA, CFS.DF.modeling$C3.h.max)
CFS.DF.modeling$C3.h.max <- as.numeric(CFS.DF.modeling$C3.h.max)

## keep your NA→0 choice to use all observations
CFS.DF.modeling[CFS.DF.modeling < 0] <- NA
CFS.DF.modeling  <- CFS.DF.modeling  %>% replace(is.na(.), 0)

AGB.input     = c("agb_l", "agb_lad")
Metrics.input = c("C2", "C2FR", "ms" )

columns = c("AGB_input","Metrics_input", "model_form","model.number","a", "a.std.err", "b", "b.std.err", "c", "c.std.err", "d", "d.std.err",
            "x1", "x2", "x3","sigma", "r2", "r2adj", "r2true", "rmse", "bias", "rmse.random", "bias.random", "avg.random",
            "rmse.FPROV", "bias.FPROV", "rmse.FLIARD", "bias.FLIARD", "rmse.FSIMP", "bias.FSIMP", 
            "rmse.HAYRIV", "bias.HAYRIV", "VIF1", "VIF2", "VIF3", "BP", "BP.df", "BP.p.value")

for (k in 1:2) {
  tic(paste("Iteration", k, "of the outer loop"))
  
  df_validation.out <- data.frame(matrix(nrow = 0, ncol = length(columns)))
  colnames(df_validation.out) = columns 
  
  for (l in 1:3) {
    ##### Define AGB -  agb_l and agb_lad
    
    ## agb_l
    if (k==1){
      CFS.DF.modeling$AGB = CFS.DF.modeling$Large_LS + CFS.DF.modeling$Large_LF +
        CFS.DF.modeling$Small_LS + CFS.DF.modeling$Small_LF
    } 
    
    ## agb_lad = LS+DS+FS+Small_LS+Small_DS+Small_FS
    if (k==3){  ## NOTE: with for(k in 1:2) this branch never runs.
      ## Likely intent: if (k==2){ ... }
      CFS.DF.modeling$AGB = CFS.DF.modeling$Large_LS + CFS.DF.modeling$Large_DS + CFS.DF.modeling$Large_LF +
        CFS.DF.modeling$Small_LS + CFS.DF.modeling$Small_LF + CFS.DF.modeling$Small_DS
    }
    
    # read list of metrics
    if (l==1){MetricsList <- read.csv("MetricsList_C2.v6.txt", header = FALSE)}
    if (l==2){MetricsList <- read.csv("MetricsList_C2first.v6.txt", header = FALSE)}
    if (l==3){MetricsList <- read.csv("MetricsList_ms.v6.txt", header = FALSE)}
    
    ## Build modeling frame with AGB and selected metrics
    CFS.DF.modeling.tmp <- as.data.frame(CFS.DF.modeling[,c("AGB", MetricsList$V1)])
    
    ## ### CHANGED (SQRT): do NOT drop zero-containing columns; no log-transform for predictors
    ## Create a version for regsubsets where the response is sqrt(AGB)
    df_for_subset <- CFS.DF.modeling.tmp
    df_for_subset$AGB <- sqrt(df_for_subset$AGB)   ## transform response only
    
    regfit.model.first = regsubsets(AGB ~ . , data = df_for_subset,
                                    nbest = 500, nvmax = 3, really.big = TRUE, intercept = TRUE)
    reg.summary.first = summary(regfit.model.first)
    variables.tmp = as.data.frame(reg.summary.first$which)[,-1]  # drop intercept column
    
    ## Raw-scale frame for fitting/prediction (AGB and LOCATION kept)
    df_modeling = CFS.DF.modeling[,c("AGB", "LOCATION", MetricsList$V1)]
    
    set.seed(2)
    train.random = sample(163,120) # random validation (unchanged)
    train.FPROV  = which(df_modeling$LOCATION != "FPROV")
    train.FLIARD = which(df_modeling$LOCATION != "FLIARD")
    train.FSIMP  = which(df_modeling$LOCATION != "FSIMP")
    train.HAYRIV = which(df_modeling$LOCATION != "HAYRIV") 
    
    df_validation = data.frame(matrix(nrow = nrow(variables.tmp), ncol = length(columns)))
    colnames(df_validation) = columns
    
    for (i in 1:nrow(variables.tmp)) {  
      metric.column = which(variables.tmp[i,] == TRUE)
      sel_names <- names(variables.tmp[metric.column])
      
      ## ### CHANGED (SQRT): fit model on sqrt(AGB) ~ raw predictors
      df_fit_full <- df_modeling[, c("AGB", sel_names)]
      df_fit_full$AGB <- sqrt(df_fit_full$AGB)     # transform response only
      
      lm.full.model = lm(AGB ~ ., data = df_fit_full)
      sum.full.model = summary(lm.full.model)
      
      ## Full-sample predictions back-transformed to AGB units (parametric correction)
      df_pred_full <- df_modeling[, sel_names]
      pred_sqrt <- predict(lm.full.model, newdata = df_pred_full)
      sigma_hat <- sum.full.model$sigma
      df_modeling$predict <- (pred_sqrt^2) + (sigma_hat^2)    ## ### CHANGED (SQRT)
      
      ## bookkeeping / outputs
      df_validation$AGB_input[i]    = AGB.input[k]
      df_validation$Metrics_input[i]= Metrics.input[l]
      df_validation$model_form[i]   = "Sqrt"       ## ### CHANGED (SQRT)
      df_validation$model.number[i] = i
      
      ## coefficients: a,b,c,d (intercept then first 3 betas if present)
      coefs <- coef(sum.full.model)
      df_validation$a[i]         = coefs[1]
      df_validation$a.std.err[i] = coef(summary(lm.full.model))[1,2]
      if (length(coefs) >= 2){
        df_validation$b[i]         = coefs[2]
        df_validation$b.std.err[i] = coef(summary(lm.full.model))[2,2]
      }
      if (length(coefs) >= 3){
        df_validation$c[i]         = coefs[3]
        df_validation$c.std.err[i] = coef(summary(lm.full.model))[3,2]
      }
      if (length(coefs) >= 4){
        df_validation$d[i]         = coefs[4]
        df_validation$d.std.err[i] = coef(summary(lm.full.model))[4,2]
      }
      
      ## chosen predictors (fill safely when <3)
      df_validation$x1[i] = ifelse(length(sel_names) >= 1, sel_names[1], NA)
      df_validation$x2[i] = ifelse(length(sel_names) >= 2, sel_names[2], NA)
      df_validation$x3[i] = ifelse(length(sel_names) >= 3, sel_names[3], NA)
      
      ## model diagnostics on the fitted scale (sqrt)
      df_validation$sigma[i] = sigma_hat
      df_validation$r2[i]    = sum.full.model$r.squared
      df_validation$r2adj[i] = sum.full.model$adj.r.squared
      
      ## r2true, RMSE, bias in AGB units (after back-transform)
      df_validation$r2true[i] = cor(df_modeling$predict, CFS.DF.modeling$AGB)^2
      df_validation$rmse[i]   = sqrt(mean((CFS.DF.modeling$AGB - df_modeling$predict)^2))
      df_validation$bias[i]   = mean(CFS.DF.modeling$AGB - df_modeling$predict)
      
      ## VIFs (predictor-only)
      if (length(sel_names) >= 2){ df_validation$VIF1[i] = as.vector(vif(lm.full.model))[1] }
      if (length(sel_names) >= 2){ df_validation$VIF2[i] = as.vector(vif(lm.full.model))[2] }
      if (length(sel_names) >= 3){ df_validation$VIF3[i] = as.vector(vif(lm.full.model))[3] }
      
      ## Breusch–Pagan on sqrt-scale model
      bp <- bptest(lm.full.model)
      df_validation$BP[i]        = as.vector(bp$statistic)
      df_validation$BP.df[i]     = as.vector(bp$parameter)
      df_validation$BP.p.value[i]= as.vector(bp$p.value)
      
      ## ---------- Random split validation (train on sqrt-scale, predict/back-transform) ----------
      train.data <- df_modeling[ , c("AGB", sel_names) ][train.random,]
      test.data  <- df_modeling[ , c("AGB", sel_names) ][-train.random,]
      train.data$AGB <- sqrt(train.data$AGB)
      
      lm.test <- lm(AGB ~ ., data = train.data)
      sum.lm.test <- summary(lm.test)
      
      pred_sqrt_test <- predict(lm.test, newdata = test.data)
      predictions <- (pred_sqrt_test^2) + (sum.lm.test$sigma^2)   ## ### CHANGED (SQRT)
      
      df_validation$rmse.random[i] = RMSE(predictions, CFS.DF.modeling$AGB[-train.random])
      df_validation$bias.random[i] = mean(CFS.DF.modeling$AGB[-train.random] - predictions)
      df_validation$avg.random[i]  = mean(CFS.DF.modeling$AGB[-train.random])
      
      ## ---------- FPROV ----------
      train.data <- df_modeling[ , c("AGB", sel_names) ][train.FPROV,]
      test.data  <- df_modeling[ , c("AGB", sel_names) ][-train.FPROV,]
      train.data$AGB <- sqrt(train.data$AGB)
      
      lm.test <- lm(AGB ~ ., data = train.data)
      sum.lm.test <- summary(lm.test)
      pred_sqrt_test <- predict(lm.test, newdata = test.data)
      predictions <- (pred_sqrt_test^2) + (sum.lm.test$sigma^2)
      df_validation$rmse.FPROV[i] = RMSE(predictions, CFS.DF.modeling$AGB[-train.FPROV])
      df_validation$bias.FPROV[i] = mean(CFS.DF.modeling$AGB[-train.FPROV] - predictions)
      
      ## ---------- FLIARD ----------
      train.data <- df_modeling[ , c("AGB", sel_names) ][train.FLIARD,]
      test.data  <- df_modeling[ , c("AGB", sel_names) ][-train.FLIARD,]
      train.data$AGB <- sqrt(train.data$AGB)
      
      lm.test <- lm(AGB ~ ., data = train.data)
      sum.lm.test <- summary(lm.test)
      pred_sqrt_test <- predict(lm.test, newdata = test.data)
      predictions <- (pred_sqrt_test^2) + (sum.lm.test$sigma^2)
      df_validation$rmse.FLIARD[i] = RMSE(predictions, CFS.DF.modeling$AGB[-train.FLIARD])
      df_validation$bias.FLIARD[i] = mean(CFS.DF.modeling$AGB[-train.FLIARD] - predictions)
      
      ## ---------- FSIMP ----------
      train.data <- df_modeling[ , c("AGB", sel_names) ][train.FSIMP,]
      test.data  <- df_modeling[ , c("AGB", sel_names) ][-train.FSIMP,]
      train.data$AGB <- sqrt(train.data$AGB)
      
      lm.test <- lm(AGB ~ ., data = train.data)
      sum.lm.test <- summary(lm.test)
      pred_sqrt_test <- predict(lm.test, newdata = test.data)
      predictions <- (pred_sqrt_test^2) + (sum.lm.test$sigma^2)
      df_validation$rmse.FSIMP[i] = RMSE(predictions, CFS.DF.modeling$AGB[-train.FSIMP])
      df_validation$bias.FSIMP[i] = mean(CFS.DF.modeling$AGB[-train.FSIMP] - predictions)
      
      ## ---------- HAYRIV ----------
      train.data <- df_modeling[ , c("AGB", sel_names) ][train.HAYRIV,]
      test.data  <- df_modeling[ , c("AGB", sel_names) ][-train.HAYRIV,]
      train.data$AGB <- sqrt(train.data$AGB)
      
      lm.test <- lm(AGB ~ ., data = train.data)
      sum.lm.test <- summary(lm.test)
      pred_sqrt_test <- predict(lm.test, newdata = test.data)
      predictions <- (pred_sqrt_test^2) + (sum.lm.test$sigma^2)
      df_validation$rmse.HAYRIV[i] = RMSE(predictions, CFS.DF.modeling$AGB[-train.HAYRIV])
      df_validation$bias.HAYRIV[i] = mean(CFS.DF.modeling$AGB[-train.HAYRIV] - predictions)
    } # end model loop
    
    df_validation.out <- rbind(df_validation.out, df_validation)
  } # end metrics loop
  
  ## LOOV aggregation (unchanged)
  attach(df_validation.out)
  df_validation.out$rmse.LOOV     = (rmse.FPROV + rmse.FLIARD + rmse.FSIMP + rmse.HAYRIV)/4
  df_validation.out$bias.LOOV     = (bias.FPROV + bias.FLIARD + bias.FSIMP + bias.HAYRIV)/4
  df_validation.out$bias.abs.LOOV = (abs(bias.FPROV) + abs(bias.FLIARD) + abs(bias.FSIMP) + abs(bias.HAYRIV))/4
  df_validation.out$LOOV.score    = df_validation.out$rmse.LOOV + abs(df_validation.out$bias.LOOV) + df_validation.out$bias.abs.LOOV
  detach(df_validation.out)
  
  ## ### CHANGED (SQRT): filename tag
  write.csv(df_validation.out, paste0("2025.LOOV.", AGB.input[k], ".Sqrt.v6.csv"))
  
  toc()
} # end outer loop
