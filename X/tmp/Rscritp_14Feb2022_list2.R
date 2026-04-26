
library(leaps)
df_modeling = df_tmp_v2_3reg[,c(17, 26:728)]

df_modeling[is.na(df_modeling)] = 0.0

df_modeling.log = log(df_modeling)
regfit.model.log = regsubsets(PLOT_TOTBM ~ ., df_modeling.log, nbest = 1, nvmax = 1, really.big = T)
reg.summary.log = summary(regfit.model.log)

regfit.model = regsubsets(PLOT_TOTBM ~ ., df_modeling, intercept = F, nbest = 1, nvmax = 1, really.big = T)
reg.summary = summary(regfit.model)

reg.summary$adjr2
reg.summary$bic
sqrt(reg.summary$rss/NROW(df_modeling))
coef(regfit.model, 1)

lm.fit.tmp1 = lm( log(PLOT_TOTBM) ~ log(C2.h.avg.all.abv.0.0m), data = df_modeling)
sum.lm.fit = summary(lm.fit.tmp1)
cor(df_modeling$PLOT_TOTBM, predict(lm.fit.tmp1))^2
# library(car)
vif(lm.fit.tmp1)

ggplot(data = df_tmp_v2_3reg, aes(x = predict(lm.fit.tmp2) , y= PLOT_TOTBM, colour = LOCATION)) + geom_point() + 
  ggtitle("lm.fit.tmp2") + xlab("Predicted") + ylab("Observed") + 
  geom_abline(intercept = 0, slope = 1, colour = "gray") + theme_bw()
