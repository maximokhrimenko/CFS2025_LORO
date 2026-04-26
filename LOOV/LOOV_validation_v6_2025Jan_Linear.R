### January 2025
### updated height first returns metrics with cut-offs
### updated cover metrics for C12 and added cover for C3

### this is for a split version of the LORO paper
### will change definitions of AGB types and will reduce the number of inputs to only 2 - all live, and all live and dead. 

## from 2022:
## run regsubsets first, then using $which get the list of the predictors and run LOOV validation

## this script is for linear model with intercept. Other scripts will be for different model forms


library(leaps)
library(dplyr)

library(tidyverse)
library(caret) #for LOOV
library(car) # for VIF
library(lmtest)# for BT test

## LOOV and K-fold validation:
## http://www.sthda.com/english/articles/38-regression-model-validation/157-cross-validation-essentials-in-r/

rm(list = ls()) ## removing everything from the environment

setwd("LOOV")

CFS.DF.modeling <- read.csv("CFS.DF.Unique.v4_Jan2025v2.csv") ### resolved issues with metrics
CFS.DF.modeling  <- CFS.DF.modeling  %>% replace(is.na(.), 0)


AGB.input = c("agb_l", "agb_lad")
Metrics.input = c("C2", "C2 first", "ms" )


columns = c("AGB_input","Metrics_input", "model_form","model.number","a", "a.std.err", "b", "b.std.err", "c", "c.std.err", "d", "d.std.err",
            "x1", "x2", "x3","sigma", "r2", "r2adj", "r2true", "rmse", "bias", "rmse.random", "bias.random", "avg.random",
            "rmse.FPROV", "bias.FPROV", "rmse.FLIARD", "bias.FLIARD", "rmse.FSIMP", "bias.FSIMP", 
            "rmse.HAYRIV", "bias.HAYRIV", "VIF1", "VIF2", "VIF3", "BP", "BP.df", "BP.p.value")


for (k in 1:2) {
  
  df_validation.out <- data.frame(matrix(nrow = 0, ncol = length(columns)))
  colnames(df_validation.out) = columns 
  
  for (l in 1:3) {
    
    ##### Define AGB -  agb_l and agb_lad
    
    ### agb_l
    if (k==1){CFS.DF.modeling$AGB = CFS.DF.modeling$Large_LS + CFS.DF.modeling$Large_LF + CFS.DF.modeling$Small_LS + CFS.DF.modeling$Small_LF} 
    
    ## agb_lad = LS+DS+FS+Small_LS+Small_DS+Small_FS
    if (k==3){CFS.DF.modeling$AGB = CFS.DF.modeling$Large_LS + CFS.DF.modeling$Large_DS + CFS.DF.modeling$Large_LF + CFS.DF.modeling$Small_LS + CFS.DF.modeling$Small_LF + CFS.DF.modeling$Small_DS}
    
    
    # read list of metrics - Full (C1, C2, C12), first (C12 first), C2 (only C2)
    if (l==1){MetricsList <- read.csv("MetricsList_C2.v6.txt", header = FALSE)}
    if (l==2){MetricsList <- read.csv("MetricsList_C2first.v6.txt", header = FALSE)}
    if (l==3){MetricsList <- read.csv("MetricsList_ms.v6.txt", header = FALSE)}



CFS.DF.modeling.first <- CFS.DF.modeling[,c("AGB", MetricsList$V1)]

## I dont know why, but nvmax = 2 gives me three variables in case of the Max Metirics and C2 metrics list
## strange - if I run first list, with nvmax = 2 it gives me only two variable model

if (l==2){regfit.model.first = regsubsets(AGB ~ . , data = CFS.DF.modeling.first,
                                nbest = 500, nvmax = 3, really.big = T, intercept = T)} 
else {regfit.model.first = regsubsets(AGB ~ . , data = CFS.DF.modeling.first,
                                      nbest = 500, nvmax = 3, really.big = T, intercept = T)
     }

reg.summary.first = summary(regfit.model.first)
variables.tmp = as.data.frame(reg.summary.first$which)[,-1]

df_modeling = CFS.DF.modeling[,c("AGB", "LOCATION", MetricsList$V1)]

set.seed(2)

train.random=sample(163,120) # random validation 
train.FPROV = which(df_modeling$LOCATION != "FPROV")
train.FLIARD = which(df_modeling$LOCATION != "FLIARD")
train.FSIMP = which(df_modeling$LOCATION != "FSIMP")
train.HAYRIV = which(df_modeling$LOCATION != "HAYRIV") 


columns= c("AGB_input","Metrics_input", "model_form","model.number","a", "a.std.err", "b", "b.std.err", "c", "c.std.err", "d", "d.std.err",
           "x1", "x2", "x3","sigma", "r2", "r2adj", "r2true", "rmse", "bias", "rmse.random", "bias.random", "avg.random", 
           "rmse.FPROV", "bias.FPROV", "rmse.FLIARD", "bias.FLIARD", "rmse.FSIMP", "bias.FSIMP", 
           "rmse.HAYRIV", "bias.HAYRIV", "VIF1", "VIF2", "VIF3", "BP", "BP.df", "BP.p.value") 


df_validation = data.frame(matrix(nrow = nrow(variables.tmp), ncol = length(columns)))
colnames(df_validation) = columns


for (i in 1:nrow(variables.tmp)) {  

metric.column = which(variables.tmp[i,] == TRUE)
lm.full.model = lm(AGB ~ ., data =df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ] )
sum.full.model = summary(lm.full.model)

df_modeling$predict = predict(lm.full.model, data = df_modeling[,names(variables.tmp[metric.column])])

# check that "AGB_input","Metrics_input", "model_form" are correct
df_validation$AGB_input[i] = AGB.input[k]  ## "LS", "LS+DS", "Total", "Small_all"
df_validation$Metrics_input[i] = Metrics.input[l] ## "C1,C2,C12", "C12 first", "C2" 
df_validation$model_form[i] = "linear"


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

lm.test <- lm(AGB ~ ., data = train.data)
predictions <- lm.test %>% predict(test.data)

df_validation$rmse.random[i] = RMSE(predictions, df_modeling$AGB[-train.random])
df_validation$bias.random[i] = mean(df_modeling$AGB[-train.random] - predictions)
df_validation$avg.random[i] = mean(df_modeling$AGB[-train.random])

## FPROV validation
train.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][train.FPROV,]
test.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][-train.FPROV,]

lm.test <- lm(AGB ~ ., data = train.data)
predictions <- lm.test %>% predict(test.data)

df_validation$rmse.FPROV[i] = RMSE(predictions, df_modeling$AGB[-train.FPROV])
df_validation$bias.FPROV[i] = mean(df_modeling$AGB[-train.FPROV] - predictions)

## FLIARD validation
train.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][train.FLIARD,]
test.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][-train.FLIARD,]

lm.test <- lm(AGB ~ ., data = train.data)
predictions <- lm.test %>% predict(test.data)

df_validation$rmse.FLIARD[i] = RMSE(predictions, df_modeling$AGB[-train.FLIARD])
df_validation$bias.FLIARD[i] = mean(df_modeling$AGB[-train.FLIARD] - predictions)
## FSIMP validation
train.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][train.FSIMP,]
test.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][-train.FSIMP,]

lm.test <- lm(AGB ~ ., data = train.data)
predictions <- lm.test %>% predict(test.data)

df_validation$rmse.FSIMP[i] = RMSE(predictions, df_modeling$AGB[-train.FSIMP])
df_validation$bias.FSIMP[i] = mean(df_modeling$AGB[-train.FSIMP] - predictions)
## HAYRIV validation
train.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][train.HAYRIV,]
test.data <- df_modeling[ ,c("AGB", names(variables.tmp[metric.column]) ) ][-train.HAYRIV,]

lm.test <- lm(AGB ~ ., data = train.data)
predictions <- lm.test %>% predict(test.data)

df_validation$rmse.HAYRIV[i] = RMSE(predictions, df_modeling$AGB[-train.HAYRIV])
df_validation$bias.HAYRIV[i] = mean(df_modeling$AGB[-train.HAYRIV] - predictions)
}

df_validation.out <- rbind(df_validation.out, df_validation)

  }
  
  
  attach(df_validation.out)
  df_validation.out$rmse.LOOV = (rmse.FPROV + rmse.FLIARD + rmse.FSIMP + rmse.HAYRIV)/4
  df_validation.out$bias.LOOV = ( bias.FPROV + bias.FLIARD + bias.FSIMP + bias.HAYRIV)/4
  df_validation.out$bias.abs.LOOV = ( abs(bias.FPROV) + abs(bias.FLIARD) + abs(bias.FSIMP) + abs(bias.HAYRIV))/4
  df_validation.out$LOOV.score = df_validation.out$rmse.LOOV + abs(df_validation.out$bias.LOOV) + df_validation.out$bias.abs.LOOV
  detach(df_validation.out)
  
  write.csv(df_validation.out, paste0("2025.LOOV.", AGB.input[k],".Linear.v6.csv"))
  
}
