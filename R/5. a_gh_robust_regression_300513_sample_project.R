#source("4. a_gh_Random forest, earth and gbm regression 290513.R")
source("3. a_gh_correlation.R")
source("options.R")
library("cvTools")
library("robustbase")
#

str(data)
#
n1<-str_replace_all(names(data), "ASR.per.100000","")
n2<-str_replace_all(n1, "X","perc")
n3<-str_replace_all(n2, "ASR.per.100","")
n4<-str_replace_all(n3, "ASR.per.101","")
n5<-str_replace_all(n4, "ASR.per","")
#
n5
#
names(data)<-n5

#
str(data)

# select numeric vars, w/o id vars
d<-data[-c(1,2)]
#
names(d)

# impute missing
library(imputation)
imp.d<-kNNImpute(d, 10)
d<-imp.d$x


###########################################
## set up folds for cross-validation
###########################################
set.seed(1234) # set seed for reproducibility
#
?cvFolds
#
folds <- cvFolds(nrow(d) #the number of observations 
                 #to be split into groups.
                 , K = 5# number of groups 
                 , R = 10#number of replications for 
                 #repeated K-fold cross-validation
                 )
###########################################




###########################################
#
## compare LS, MM and LTS regression
#
###########################################

###########################################
# 1. perform cross-validation for an LS regression model
###########################################
fitLm <- lm(Y ~ ., data = d)
#
cvFitLm <- cvLm(fitLm, cost = rtmspe,
                folds = folds, trim = 0.1)
## find predicted
predict(fitLm,d)
###########################################





###########################################
# 2. perform cross-validation for an MM regression model
###########################################
fitLmrob <- lmrob(Y ~ ., data = d, k.max = 500)
#
cvFitLmrob <- cvLmrob(fitLmrob, cost = rtmspe,
                      folds = folds, trim = 0.1)
# find predicted
predict(fitLmrob,d)
###########################################



###########################################
# 3. perform cross-validation for an LTS regression model
###########################################
?ltsReg
fitLts <- ltsReg(Y ~ ., data = d)
#
cvFitLts <- cvLts(fitLts, cost = rtmspe,
                  folds = folds, trim = 0.1)
# find predicted
predict(fitLts,d)
###########################################




###########################################
# combine and plot results
###########################################
cvFits <- cvSelect(LS = cvFitLm
                   , MM = cvFitLmrob
                   , LTS = cvFitLts)
# review results
cvFits$cv
names(cvFits)
#
dotplot(cvFits)
###########################################




###########################################
#
# coefficients for the best model
#
###########################################
fitLmrob$coefficients


