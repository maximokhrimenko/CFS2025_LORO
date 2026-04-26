## run regsubsets first, then using $which get the list of the predictors and run LOOV validation

## this script is for log~log model
## I run it multiple times, changing AGB input and metrics list input
## don't forget to change output name of the CSV file and AGB_input, Metrics_input fields in the loop

setwd("C:/Users/maxim.okhrimenko/Documents/myR_projects/CFS2022_models/LOOV")

library(leaps)
library(dplyr)

library(tidyverse)
library(caret) #for LOOV
library(car) # for VIF
library(lmtest)# for BT test

## LOOV and K-fold validation:
## http://www.sthda.com/english/articles/38-regression-model-validation/157-cross-validation-essentials-in-r/

rm(list = ls()) ## removing everything from the environment

CFS.DF.modeling <- read.csv("~/myR_projects/CFS2022_models/LOOV/CFS.DF.Unique.v3.csv")
CFS.DF.modeling[CFS.DF.modeling < 0] <- NA
CFS.DF.modeling  <- CFS.DF.modeling  %>% replace(is.na(.), 0)

AGB.input = c("LS", "LS+DS", "Total")
Metrics.input = c("C1,C2,C12", "C12 first", "C2" )


columns = c("AGB_input","Metrics_input", "model_form","model.number","a", "a.std.err", "b", "b.std.err", "c", "c.std.err", "d", "d.std.err",
           "x1", "x2", "x3","sigma", "r2", "r2adj", "r2true", "rmse", "bias", "rmse.random", "bias.random", 
           "rmse.FPROV", "bias.FPROV", "rmse.FLIARD", "bias.FLIARD", "rmse.FSIMP", "bias.FSIMP", 
           "rmse.HAYRIV", "bias.HAYRIV", "VIF1", "VIF2", "VIF3", "BP", "BP.df", "BP.p.value")

#df_validation.out <- data.frame(matrix(nrow = 0, ncol = length(columns)))
#colnames(df_validation.out) = columns  

#df_validation.out2 <- data.frame(matrix(nrow = 0, ncol = length(columns)))
#colnames(df_validation.out2) = columns 

#df_validation.out.tmp <- df_validation.out
  
for (k in 1:3) {
  
  df_validation.out <- data.frame(matrix(nrow = 0, ncol = length(columns)))
  colnames(df_validation.out) = columns 

for (l in 1:3) {

##### Define AGB -  LS, LS+DS, Total, Small_all

### LS
if (k==1){CFS.DF.modeling$AGB = CFS.DF.modeling$Large_LS} 

### LS+DS
if (k==2){CFS.DF.modeling$AGB = CFS.DF.modeling$Large_LS + CFS.DF.modeling$Large_DS}

## Total = LS+DS+FS+Small_LS+Small_DS+Small_FS
if (k==3){CFS.DF.modeling$AGB = CFS.DF.modeling$Large_LS + CFS.DF.modeling$Large_DS + CFS.DF.modeling$Large_LF + CFS.DF.modeling$Small_LS + CFS.DF.modeling$Small_LF + CFS.DF.modeling$Small_DS}

### Small_all = Small_DS+Small_FS
#CFS.DF.modeling$AGB = CFS.DF.modeling$Small_LS + CFS.DF.modeling$Small_LF + CFS.DF.modeling$Small_DS


# read list of metrics - Full (C1, C2, C12), first (C12 first), C2 (only C2)
if (l==1){MetricsList <- read.csv("MetricsList_full.v2.txt", header = FALSE)}
if (l==2){MetricsList <- read.csv("MetricsList_first.txt", header = FALSE)}
if (l==3){MetricsList <- read.csv("MetricsList_C2.txt", header = FALSE)}




CFS.DF.modeling.tmp <- as.data.frame(CFS.DF.modeling[,c("AGB", MetricsList$V1)])

df <- CFS.DF.modeling.tmp %>% select_if(function(x) any(x == 0))
names.vector = as.vector(names(df))

### now remove columns with at least 1 zero?
CFS.DF.modeling.first <-CFS.DF.modeling.tmp[ , !names(CFS.DF.modeling.tmp) %in% names.vector]

CFS.DF.modeling.log <- log(CFS.DF.modeling.first)


## I dont know why, but nvmax = 2 gives me three variables in case of the Max Metirics and C2 metrics list
## strange - if I run first list, with nvmax = 2 it gives me only two variable model
regfit.model.first = regsubsets(AGB ~ . , data = CFS.DF.modeling.log,
                                nbest = 30, nvmax = 2, really.big = T, intercept = T)

reg.summary.first = summary(regfit.model.first)

variables.tmp = as.data.frame(reg.summary.first$which)[,-1]

df_modeling = CFS.DF.modeling[,c("AGB", "LOCATION", MetricsList$V1)]

set.seed(2)

train.random=sample(163,120) # random validation 
train.FPROV = which(df_modeling$LOCATION != "FPROV")
train.FLIARD = which(df_modeling$LOCATION != "FLIARD")
train.FSIMP = which(df_modeling$LOCATION != "FSIMP")
train.HAYRIV = which(df_modeling$LOCATION != "HAYRIV") 


columns = c("AGB_input","Metrics_input", "model_form","model.number","a", "a.std.err", "b", "b.std.err", "c", "c.std.err", "d", "d.std.err",
           "x1", "x2", "x3","sigma", "r2", "r2adj", "r2true", "rmse", "bias", "rmse.random", "bias.random", 
           "rmse.FPROV", "bias.FPROV", "rmse.FLIARD", "bias.FLIARD", "rmse.FSIMP", "bias.FSIMP", 
           "rmse.HAYRIV", "bias.HAYRIV", "VIF1", "VIF2", "VIF3", "BP", "BP.df", "BP.p.value") 


df_validation = data.frame(matrix(nrow = nrow(variables.tmp), ncol = length(columns)))
colnames(df_validation) = columns


for (i in 1:nrow(variables.tmp)) {  
  
  metric.column = which(variables.tmp[i,] == TRUE)
  df.modeling.log = log(df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ])
  lm.full.model = lm(AGB ~ ., data = df.modeling.log)
  sum.full.model = summary(lm.full.model)
  
  df_modeling$predict.log = predict(lm.full.model, data = df.modeling.log[,names(variables.tmp[metric.column])])
  df_modeling$predict = exp(df_modeling$predict.log)*exp(0.5*sum.full.model$sigma^2) 
  
  # check that "AGB_input","Metrics_input", "model_form" are correct
  df_validation$AGB_input[i] = AGB.input[k]  ## "LS", "LS+DS", "Total", "Small_all"
  df_validation$Metrics_input[i] = Metrics.input[l] ## "C1,C2,C12", "C12 first", "C2" 
  df_validation$model_form[i] = "LogLog" ## "linear", "LogLog"
  
  
  df_validation$model.number[i] = i
  df_validation$a[i] = sum.full.model$coefficients[1,1]
  df_validation$a.std.err[i] = sum.full.model$coefficients[1,2]
  df_validation$b[i] = sum.full.model$coefficients[2,1]
  df_validation$b.std.err[i] = sum.full.model$coefficients[2,2]
  
  if (dim(sum.full.model$coefficients)[1] > 2){df_validation$c[i] =  sum.full.model$coefficients[3,1]}
  if (dim(sum.full.model$coefficients)[1] > 2){df_validation$c.std.err[i] = sum.full.model$coefficients[3,2]}
  if (dim(sum.full.model$coefficients)[1] > 3){df_validation$d[i] = sum.full.model$coefficients[4,1]}
  if (dim(sum.full.model$coefficients)[1] > 3){df_validation$d.std.err[i] = sum.full.model$coefficients[4,2]}
  
  df_validation$x1[i] = names(variables.tmp[metric.column])[1]
  df_validation$x2[i] = names(variables.tmp[metric.column])[2]
  df_validation$x3[i] = names(variables.tmp[metric.column])[3]
  
  df_validation$sigma[i] = sum.full.model$sigma
  df_validation$r2[i] = sum.full.model$r.squared
  df_validation$r2adj[i] = sum.full.model$adj.r.squared
  df_validation$r2true[i] = cor(df_modeling$predict, df_modeling$AGB)^2
  df_validation$rmse[i] = sqrt(mean((df_modeling$AGB - df_modeling$predict)^2))
  df_validation$bias[i] = mean((df_modeling$AGB - df_modeling$predict))
  
  if (dim(sum.full.model$coefficients)[1] > 2){df_validation$VIF1[i] = as.vector(vif(lm.full.model))[1] }
  if (dim(sum.full.model$coefficients)[1] > 2){df_validation$VIF2[i] = as.vector(vif(lm.full.model))[2] }
  if (dim(sum.full.model$coefficients)[1] > 3){df_validation$VIF3[i] = as.vector(vif(lm.full.model))[3] }
  
  df_validation$BP[i] = as.vector(bptest(lm.full.model)$statistic)
  df_validation$BP.df[i] = as.vector(bptest(lm.full.model)$parameter)
  df_validation$BP.p.value[i] = as.vector(bptest(lm.full.model)$p.value)
  
  ## random validation
  train.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][train.random,]
  test.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][-train.random,]
  
  train.data.log <- log(train.data)
  test.data.log <- log(test.data)
  
  lm.test <- lm(AGB ~ ., data = train.data.log)
  sum.lm.test <- summary(lm.test)
  
  
  predictions.log <- lm.test %>% predict(test.data.log)
  predictions <- exp(predictions.log)*exp(0.5*sum.lm.test$sigma^2) 
    
  
  df_validation$rmse.random[i] = RMSE(predictions, df_modeling$AGB[-train.random])
  df_validation$bias.random[i] = mean(df_modeling$AGB[-train.random] - predictions)

  
  ## FPROV validation
  train.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][train.FPROV,]
  test.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][-train.FPROV,]
  
  train.data.log <- log(train.data)
  test.data.log <- log(test.data)
  
  lm.test <- lm(AGB ~ ., data = train.data.log)
  sum.lm.test <- summary(lm.test)
  
  predictions.log <- lm.test %>% predict(test.data.log)
  predictions <- exp(predictions.log)*exp(0.5*sum.lm.test$sigma^2)
  
  df_validation$rmse.FPROV[i] = RMSE(predictions, df_modeling$AGB[-train.FPROV])
  df_validation$bias.FPROV[i] = mean(df_modeling$AGB[-train.FPROV] - predictions)
  
  ## FLIARD validation
  train.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][train.FLIARD,]
  test.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][-train.FLIARD,]
  
  train.data.log <- log(train.data)
  test.data.log <- log(test.data)
  
  lm.test <- lm(AGB ~ ., data = train.data.log)
  sum.lm.test <- summary(lm.test)
  
  predictions.log <- lm.test %>% predict(test.data.log)
  predictions <- exp(predictions.log)*exp(0.5*sum.lm.test$sigma^2)
  
  df_validation$rmse.FLIARD[i] = RMSE(predictions, df_modeling$AGB[-train.FLIARD])
  df_validation$bias.FLIARD[i] = mean(df_modeling$AGB[-train.FLIARD] - predictions)
  ## FSIMP validation
  train.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][train.FSIMP,]
  test.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][-train.FSIMP,]
  
  train.data.log <- log(train.data)
  test.data.log <- log(test.data)
  
  lm.test <- lm(AGB ~ ., data = train.data.log)
  sum.lm.test <- summary(lm.test)
  
  predictions.log <- lm.test %>% predict(test.data.log)
  predictions <- exp(predictions.log)*exp(0.5*sum.lm.test$sigma^2)
  
  df_validation$rmse.FSIMP[i] = RMSE(predictions, df_modeling$AGB[-train.FSIMP])
  df_validation$bias.FSIMP[i] = mean(df_modeling$AGB[-train.FSIMP] - predictions)
  ## HAYRIV validation
  train.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][train.HAYRIV,]
  test.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][-train.HAYRIV,]
  
  train.data.log <- log(train.data)
  test.data.log <- log(test.data)
  
  lm.test <- lm(AGB ~ ., data = train.data.log)
  sum.lm.test <- summary(lm.test)
  
  predictions.log <- lm.test %>% predict(test.data.log)
  predictions <- exp(predictions.log)*exp(0.5*sum.lm.test$sigma^2)
  
  df_validation$rmse.HAYRIV[i] = RMSE(predictions, df_modeling$AGB[-train.HAYRIV])
  df_validation$bias.HAYRIV[i] = mean(df_modeling$AGB[-train.HAYRIV] - predictions)
}

df_validation.out <- rbind(df_validation.out, df_validation)

}
  
  
  attach(df_validation.out)
  df_validation.out$rmse.LOOV = (rmse.FPROV + rmse.FLIARD + rmse.FSIMP + rmse.HAYRIV)/4
  df_validation.out$bias.LOOV = ( bias.FPROV + bias.FLIARD + bias.FSIMP + bias.HAYRIV)
  df_validation.out$bias.abs.LOOV = ( abs(bias.FPROV) + abs(bias.FLIARD) + abs(bias.FSIMP) + abs(bias.HAYRIV))/4
  df_validation.out$LOOV.score = df_validation.out$rmse.LOOV + abs(df_validation.out$bias.LOOV) + df_validation.out$bias.abs.LOOV
  detach(df_validation.out)
  
  write.csv(df_validation.out, paste0("LOOV.", AGB.input[k],".LogLog.csv"))
  
}



