
set.seed(2)

train=sample(124,81) # random validation 

train = which(df_tmp_v2_3reg$LOCATION != "FPROV")
train = which(df_tmp_v2_3reg$LOCATION != "FLIARD")
train = which(df_tmp_v2_3reg$LOCATION != "FSIMP")

lm.test = lm(PLOT_TOTBM ~ C12.h.qav.first.abv.0.0mSqrt-1 , data = df_modeling, subset = train)
sqrt(mean((df_modeling$PLOT_TOTBM - predict(lm.test, df_modeling))[-train]^2))
mean((df_modeling$PLOT_TOTBM - predict(lm.test, df_modeling))[-train])



