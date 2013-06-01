source("3. a_gh_correlation.R")
source("options.R")



#########################################################################
#
# read in data
#
#########################################################################
a<-read.csv("sample_project_290513.csv",stringsAsFactors=FALSE)
str(a)
contents(a)

# 
data<-a
#########################################################################



#########################################################################
#
# Data partition 
#
##################################=#######################################



# # create training and test samples
# seed=3456
# ind <- sample(2, nrow(data), replace=TRUE, prob=c(0.7, 0.3))
# head(ind)
# # [1] 1 2 1 1 2 1
# train <- data[ind==1,]
# test <- data[ind==2,]
# 
# str(train)
# 
# train$respvar<-NULL
# test$respvar<-NULL


##################################=#######################################
#
# fit randomforest
#
##################################=#######################################
# Prepare x and y
##################################=#######################################
library(randomForest)
?randomForest
train<-data
str(train)

# specify target variable and predictors to be used in the model
x<-train[ ,-which (names(data) %in% c("perc.low.birth.weight.babies"))]
# 
str(x)
names(x)
#
y<-train$perc.low.birth.weight.babies  
#
str(y)




##################################=#######################################
## fit randomforest model
##################################=#######################################
fit.t <- randomForest(
    x,y,
   #data=train,
   mtry=5,
    ntree=1000,
   sampsize=100)




##################################=#######################################
# review fit on train data
##################################=#######################################
# review number of trees and % Var explained
fit.t
# % Var explained: 93.37
#
# review number of trees
plot(fit.t)
names(fit.t)
# "pseudo R-squared": 1 - mse / Var(y) on train
fit.t$rsq[length(fit.t$rsq)]


# r  squared on train
ptrain<-predict(fit.t,train)
(cor(ptrain,train$perc.low.birth.weight.babies))**2
# [1] 0.9452496

# confusion matrix - only for classification
# table(p,train$X..low.birth.weight.babies)


##################################=#######################################
# review fit on test data
##################################=#######################################
# # r  squared on test
# ptest<-predict(fit.t,test)
# (cor(ptest,test$X..low.birth.weight.babies))**2
# # [1] 0.9452496
# 
# # confusion matrix
# table(ptest,test$X..low.birth.weight.babies)




##################################=#######################################
# variable importance
##################################=#######################################
# save variable importance as data frame
var.imp <-as.data.frame((fit.t$importance))
str(var.imp)
var.imp$name<-rownames(var.imp)

# sort by importance
?arrange
arrange(var.imp,desc(IncNodePurity))
# save var importance in rf
var.rf.imp<-arrange(var.imp,desc(IncNodePurity))










#######################################################################
#
# GBM
#
#########################################################################
## The gbm function does not accept factor response values 
## so for classification task  we
## would make a copy and modify the outcome variable 

# train$is_spam <- ifelse(train$is_spam == 1, 1, 0)
# names(datarain)
# datarain$city<-datarain$combined<-NULL
# # response
# y<-train$X..low.birth.weight.babies
# # predictor matrix
# x<-datarain
library(gbm)
# fit model
gf<-gbm.fit(x,y,
#         offset = NULL,
#         misc = NULL,
        distribution = "gaussian", # regression
#         w = NULL,
#         var.monotone = NULL,
#             keep.data = TRUE,
#             var.names = NULL,
#             response.name = NULL,
        n.trees = 2000,# 2000 boosting iterations
        interaction.depth = 2, # How many splits in each tree
        n.minobsinnode = 5, # minimum in each node
        shrinkage = 0.000001,# learning rate
        bag.fraction = 0.5, # subsampling fraction, 0.5 is probably best
            #nTrain = 1.0,# fraction of data for training,
                             # first train.fraction*N are used for training
        #cv.folds = 5,                # do 5-fold cross-validation
        verbose = FALSE)              # Do not print the details







#########################################################################
# score train data and review fit
#########################################################################
# calculate predicted values
pred=predict.gbm(gf,x,n.trees=2000)


# # check performance using an out-of-bag estimator.  OOB underestimates the optimal number of iterations
# best.iter <- gbm.perf(gf,method="OOB")
# print(best.iter)
# 
# # check performance using a 50% heldout test set
# best.iter <- gbm.perf(gf,method="test")
# print(best.iter)
# 
# # check performance using 5-fold cross-validation
# best.iter <- gbm.perf(gf,method="cv")
# print(best.iter)

############################################
# variable influence
############################################
summary(gf,n.trees=2000)      
#
var.importance.gbf<-(summary(gf,n.trees=2000))
#
head(var.importance.gbf,20)

############################################
# find combined var importance
############################################
# gbm
names(var.importance.gbf)<-c("name","GF.importance")
var.importance.gbf<-arrange(var.importance.gbf,desc(GF.importance))
var.importance.gbf$rank.gbf<-as.numeric(row.names(var.importance.gbf))
# rf
names(var.rf.imp)<-c("RF.importance","name")
var.rf.imp$RF.importance<-var.rf.imp$RF.importance/max(var.rf.imp$RF.importance)
var.importance.rf<-arrange(var.rf.imp,desc(RF.importance))
var.importance.rf$rank.rf<-as.numeric(row.names(var.importance.rf))
# calculate rank for combined rf and gbm
combined.importance<-merge(var.importance.gbf,var.importance.rf)
combined.importance$rank<-(combined.importance$rank.rf+combined.importance$rank.gbf)/2
# 15 top rank vars
head(arrange(combined.importance[c("name","rank.gbf","rank.rf","rank")], rank ),15  )

??ntile
table(train$perc.low.birth.weight.babies)
      , data = train,geom = "histogram", binwidth = 1)
      ,geom = c("point", "smooth"))
   
cor(train$Normal.weight.range.m,train$perc.low.birth.weight.babies)

names(train)










##################################=#######################################
#
# fit cforest via party
#
##################################=#######################################
# rm(nt2,t2)
# data$y<-data$X..low.birth.weight.babies
# which (names(data)=="X..low.birth.weight.babies")
# data<-data[ ,-which (names(data) %in% c("X..low.birth.weight.babies", "X..low.birth.weight.babies"))]
# # create training and test samples
# seed=3456
# ind <- sample(2, nrow(data), replace=TRUE, prob=c(0.7, 0.3))
# head(ind)
# # [1] 1 2 1 1 2 1
# train <- data[ind==1,]
# test <- data[ind==2,]
# names(train)
#
# Function cforest_unbiased returns the settings suggested for the construction of unbiased 
# random forests (teststat = "quad", testtype = "Univ", replace = FALSE) 
# by Strobl et al. (2007) and is the default since version 0.9-90. 



##################################=#######################################
## fit cforest model
##################################=#######################################
cf<-cforest(perc.low.birth.weight.babies ~ .
            , data=train
            ,controls = cforest_unbiased( ntree = 100, savesplitstats = FALSE,mtry = 5)                                             
)

##################################=#######################################



##################################=#######################################
# review fit on train data
##################################=#######################################
cf
summary(cf)    
plot(cf)

# calculate predicted values
predict.cf<-predict(cf)

### true vs. predicted classes
plot(predict(cf),train$perc.low.birth.weight.babies)

# r-squared
(cor(predict(cf),train$perc.low.birth.weight.babies))**2
### 



##################################=#######################################
# variable importance
##################################=#######################################
v<-varimp(cf)
str(v)

row.names(v)
# save variable importance as data frame
vv<-as.data.frame(cbind(names(v),v) )
str(vv)
str(as.data.frame(vv))

vv$v<-as.numeric(vv$v)
str(vv)
names(vv)<-c("names", "importance")
# sort by importance
variable.imp.table<-arrange(vv,desc(importance))
variable.imp.table

# 
# 
# ##################################=#######################################
# library(earth) 
# ##################################=#######################################
# # create training and test samples. Prepare x and y
# ##################################=#######################################
# seed=3456789456
# ind <- sample(2, nrow(data), replace=TRUE, prob=c(0.7, 0.3))
# #
# train <- data[ind==1,]
# test <- data[ind==2,]
# #
# # # y<-data$X..low.birth.weight.babies
# # # which (names(data)=="X..low.birth.weight.babies")
# # ##################################=######################################
# # x<-train[ ,-which (names(data) %in% c("X..low.birth.weight.babies", "X..low.birth.weight.babies"))]
# # y<-as.factor(train$X..low.birth.weight.babies)
# ###################################=#######################################
# 
# 
# 
# ############################################################
# # fit MARS model
# ############################################################
# # My.Formula<- X..low.birth.weight.babies ~ year+vclass+displ+trany+cylinders+
# #   drive+fueltype+pv2+lv4+hlv+fuelprice+costa08
# library(earth)
# et<-earth(x,y,  trace=1) # note col names in x and y below
# 
# 
# 
# 
# 
# ############################################################
# # review MARS model
# ############################################################
# et
# # RSq 0.955
# summary(et)
# 
# # R-squared
# et$rsq
# # [1] 0.955
# 
# # score train data 
# et.pred.train<-predict(et,newdata=train)
# #calculate r-squared directly
# (cor (et.pred.train,as.numeric(train$X..low.birth.weight.babies)))**2
# #  0.8599896
# 
# 
# 
# 
# #########################################################################
# # Variable importance
# #########################################################################
# evimp(et, trim=FALSE)
# # nsubsets   gcv    rss
# # year                                             5 100.0  100.0
# # newmakeAudi-unused                               0   0.0    0.0
# # newmakeBMW-unused                                0   0.0    0.0
# # newmakeBuick-unused                              0   0.0    0.0
# # newmakeChevrolet-unused                          0   0.0    0.0
# 
# 
# 
# 
# #########################################################################
# # plots
# #########################################################################
# plot(et)
# # The plot.earth function produces four graphs .
# # 1. Use the Model Selection plot to see how the fit depends on the number of predictors,
# #       how the final model was selected at the maximum GCV, and so on.
# # 2. Use the Residuals vs Fitted graph to look for outliers and for any obviously strange
# #       behavior of the fitted function.
# # You can usually ignore the other two graphs
# #
# #
# 
# 
# 
# 
# #########################################################################
# # score test data and review fit
# #########################################################################
# # r-squared 
# ( cor (predict(et,newdata=test), test$X..low.birth.weight.babies)  )**2
# #  0.8630669
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# #########################################################################
# #
# # MARS model with crossvalidation
# #
# #########################################################################
# # Cross-validation is done if nfold is greater than 1 (typically 5 or 10). Earth rst builds
# # a standard model with all the data as usual. This means that the standard elds in
# # earth's return value appear as usual, and will be displayed as usual by summary.earth.
# # Earth then builds nfold cross-validated models. For each fold it builds an earth model
# # with the in-fold data (typically nine tenths of the complete data) and using this model
# # measures the R-Squared from predictions made on the out-of-fold data (typically one
# # tenth of the complete data). The nal mean cv.rsq printed by summary.earth is the
# # mean of these out-of-fold R-Squared's.
# #
# # The cross-validation results go into extra fields in earth's return value. All of these
# # have a cv prex | see the Value section of the earth help page for details. 
# 
# # For reproducibility, call set.seed before calling earth with nfold.
# 
# #########################################################################
# # fit MARS model
# #########################################################################\
# library(earth)
# et1<-earth(x,y, trace=1,degree=2, minspan=5
#            ,nfold=3)#cross-validation
# 
# 
# 
# 
# #########################################################################
# # Review model
# #########################################################################
# et1
# # Selected 6 of 6 terms, and 1 of 76 predictors 
# # Importance: year, newmakeAudi-unused, newmakeBMW-unused, newmakeBuick-unused, ...
# # Number of terms at each degree of interaction: 1 5 (additive model)
# # GCV 0.00639  RSS 142  GRSq 0.955  RSq 0.955  cv.rsq 0.955
# 
# 
# 
# 
# 
# #########################################################################
# # coefficients
# #########################################################################
# coefficients(et1)
# # y
# # (Intercept) -0.006244
# # h(year-22)   0.075140
# # h(22-year)   0.000404
# # h(year-26)  -0.690808
# 
# 
# 
# #########################################################################
# # Variable importance
# #########################################################################
# evimp(et1)
# # nsubsets   gcv    rss
# # year        5 100.0  100.0
# 
# 
# 
# 
# 
# #########################################################################
# # plot model
# #########################################################################
# plot(et1)
# 
# 
# 
# #########################################################################
# # Score test data and review fit
# #########################################################################
# # r-squared
# (cor(predict (et1,newdata=test),as.numeric(test$X..low.birth.weight.babies)))**2
# #########################################################################
# # 0.956
# #########################################################################
# # Graphical analysis of MARS prediction
# #########################################################################
# 
# train$p<-as.vector(predict(et1,newdata=train))
# library(ggplot2)
# qplot(p, data = train)+facet_wrap(~X..low.birth.weight.babies)
