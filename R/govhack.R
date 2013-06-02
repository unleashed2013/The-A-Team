source("options.R")
# Specify file location. 
# Remember to replace \  by /
file<-"C:/Users/InnaNew/Desktop/Govhack/SA_sla_data_2012 plus prepared data.310513.xls"
#list_of_worksheets<-"C:/Users/InnaNew/Desktop/Govhack/SA_sla_data_2012_list_of_sheets.xls"

# before starting the work w/Excel file,
# make sure that in the Excel file all sheets with no data are deleted


#######################################################
# Load Excel workbook
require(XLConnect)
wb <-loadWorkbook(file)
# , create = TRUE)
#######################################################




#######################################################
#Create list of all worksheets
#######################################################
# 1. Create list of all worksheets
# getsheets(wb) creates a character vector with names of workbook sheets
sheet = getSheets(wb)
sheet
str(sheet)
#######################################################


#######################################################
# import Excel workbook into R. Specify start and end rows
#######################################################
lst =   readWorksheet(wb
                      , sheet = "prepared.data"
                      , startRow = 1 # start at row 5 as above is useless info
                      , endRow = 128 # end at row 132 as below is useless info
)
### review results
str(lst)
names(lst)
summary(lst)
#######################################################



#######################################################
# # select only the "useful" sheets ie applicable to a specific issue
# # some manual work is required to specify the useful sheets
# a<-cat(names(lst), sep='","')
#######################################################
# # 1. specify useful sheets - semi-manually, use cat(names(lst), sep='","')
# usefulsheets<-  "prepared.data"
# #
# # 2. Create lst1 - list with useful sheets only included
# lst1<-lst[usefulsheets]
# #
# # review results
# #str(lst1)
# names(lst1)
#View(lst1$Learning_Earning)
#########################################




#########################################
#
# read in the data
#
#########################################

data<-lst
# review results
dim(data)
str(data)
names(data)

#########################################
#
# Format the resulting data
#
#########################################
# review formats of variables
str(data)
# put datainto d
d<-data
# review results
names(data)
dim(data)
#
names(d)
dim(d)


##########################################
# 1. $ SLA..SLA.group.code code as character
##########################################
# d$SLA..SLA.group.code<-as.character(d$SLA..SLA.group.code)


##########################################
# 2. Recode all vars with names not containing "SLA" string as numeric
##########################################
# find the vector of names of all vars that do not have "SLA" in the name:
names.to.num<-names(d)[str_detect(names(d),"SLA")==0]
# review results
names.to.num
length(names.to.num)
#
# find all columns in d with names not containing "SLA" string as numeric:
d[ ,names.to.num]
# to each suvch  column  apply function as.numeric
a<-as.data.frame(sapply(d[,names.to.num],as.numeric) )
warnings()
#
# review results
dim(a)
#
str(a)
#
summary(a)
contents(a)
# Put the formatted data back in d instead of character var's
d[names.to.num]<-a
# review results
str(d)


##########################################
# 4.  Recode SLA number as character
##########################################\
d$SLA_number<-as.character(d$SLA_number)

# reviewresults
str(d$SLA_number)
#
str(d)
#
contents(d)
#View(d)



##########################################
# 7.  review results
##########################################
str(d)
contents(d)
#View(d)
#########################################



#########################################
# 9. save the formatted data
#########################################
data<-d
# review results
str(data)
dim(data)
#View(data)
source("1. a_gh_read_Excel_files 010613_sample_project.R")
############################################################
# find which vars in d had no missing values
#############################################################
# get dataframe from contents(d) and call it cont
b<-contents(d)
#
str(b)
#
cont<-(b$contents)
#
# add column of variable names to the data frame and save this as c
c<-cbind(row.names(cont),cont)
str(c)
# rename the first column of resulting dataframe as var.name
names(c1)<-c("var.name","Storage","NAs" )
# review results
names(c1)

############################################################
# prepare dataframe of d where vars had no missing values and bind with our response variable
#############################################################
# names of vars with no missing
nm<-c1[c1$NAs==0,1]
# review results
str(nm)
#
names(d[nm])

# bind with our response variable
names(d)
response.imp.d<-cbind(d["DevVulnerablePct"],d[nm])
# review results
str(response.imp.d)
dim(response.imp.d)
###########################################################
# import data
###########################################################
source("options.R")
source("1. a_gh_read_Excel_files 010613_sample_project.R")


###########################################################
# put data in d2
###########################################################
d2<-data
contents(d2)


###########################################################
#
# find the SLAs with many missing rows
#
###########################################################

###########################################################
# missing row calculating function
###########################################################
nmissing<-function(x)( sum(is.na(x)) )
miss.in.rows<-apply(data,      # data is "data"
                    1,      # apply function to each row
                    nmissing   # apply function nmissing
)
table(miss.in.rows) 
#
str(miss.in.rows)



###########################################################
# add to data number of observations missing in rows
###########################################################
d2$miss.in.rows<-miss.in.rows/(ncol(data)-1)
str(d2)
# calculate the proportion of obs missing in a row
d2$miss.in.rows.gt.08<-d2$miss.in.rows>0.8
d2$miss.in.rows.gt.07<-d2$miss.in.rows>0.7
d2$miss.in.rows.gt.06<-d2$miss.in.rows>0.6

###########################################################
# find the SLAs with 80% or more data missing
###########################################################
#(d2[d2$miss.in.rows>0.6, ])$SLA_group  
(d2[d2$miss.in.rows.gt.06, ])$SLA_group  
#[1] "Maralinga Tjarutja (AC)" "Unincorp. Lincoln"       "Unincorp. Murray Mallee" "Unincorp. Western"       "Unincorp. Yorke" 

as.vector(d2[46,])

source("options.R")
source("1.1. a_gh_find_vars_with_no_miss_for_response_imputation.R")




###########################################
# Impute numeric missing values
###########################################


###########################################
# save data as t
###########################################
t<-response.imp.d
#
str(t)
dim(t)


###########################################
# select numeric vars in d
###########################################
# which(x) produces column number for the column where logical vector 
# inside which() is TRUE
d1<-t[, which(( 
  sapply(t,is.numeric)   
) )      ]
# review results
names(d1)
###########################################

###########################################
#impute values in the numeric vars
###########################################
###########################################
# calculate imputed missing valuesfor  numeric vars in d 
###########################################
library(imputation)
imp.response<-kNNImpute(d1, 5)
# review results
str(imp.response)
# here imp.response$x is the data frame with imputed missing values
contents(imp.response$x)
###########################################



###########################################
# replace response in d with the response w/imputed missing values
###########################################
imp.resp<-imp.response$x
#
str(imp.resp)
str(imp.resp$DevVulnerablePct)

d$DevVulnerablePct <-imp.resp$DevVulnerablePct
# review results
str(d)
contents(d)
###########################################



###########################################
# save results
###########################################
data<-d
#
str(data)
contents(data)
#
write.csv(data,file="imputed response 010613.csv")
z<-read.csv("imputed response 010613.csv",stringsAsFactors=F)

source("options.R")
source("1.1. a_gh_find_vars_with_no_miss_for_response_imputation.R")




###########################################
# Impute numeric missing values
###########################################


###########################################
# save data as t
###########################################
t<-response.imp.d
#
str(t)
dim(t)


###########################################
# select numeric vars in d
###########################################
# which(x) produces column number for the column where logical vector 
# inside which() is TRUE
d1<-t[, which(( 
  sapply(t,is.numeric)   
) )      ]
# review results
names(d1)
###########################################

###########################################
#impute values in the numeric vars
###########################################
###########################################
# calculate imputed missing values for  numeric vars in d 
###########################################
library(imputation)
imp.response<-kNNImpute(d1, 5)
# review results
str(imp.response)
# here imp.response$x is the data frame with imputed missing values
contents(imp.response$x)
###########################################



###########################################
# replace response in d with the response w/imputed missing values
###########################################
imp.resp<-imp.response$x
#
str(imp.resp)
str(imp.resp$DevVulnerablePct)

d$DevVulnerablePct <-imp.resp$DevVulnerablePct
# review results
str(d)
contents(d)
###########################################



###########################################
# save results
###########################################
data<-d
#
str(data)
contents(data)
#
write.csv(data,file="imputed response 010613.csv")
z<-read.csv("imputed response 010613.csv",stringsAsFactors=F)
names(z)
z$x<-NULL
d<-z

source("options.R")
source("2. 2. a_gh_missing values imputation for vars 010613.R")




###########################################
# Impute numeric missing values
###########################################


###########################################
# save data as t
###########################################
t<-data
#
str(t)
dim(t)


###########################################
# select numeric vars in d
###########################################
# which(x) produces column number for the column where logical vector 
# inside which() is TRUE
d1<-t[, which(( 
  sapply(t,is.numeric)   
) )      ]
# review results
names(d1)
###########################################

###########################################
#impute values in the numeric vars
###########################################
###########################################
# calculate imputed missing values for  numeric vars in d1 
###########################################
library(imputation)
imp.vars<-kNNImpute(d1, 5)
# review results
str(imp.vars)
# here imp.vars$x is the data frame with imputed missing values
contents(imp.vars$x)
###########################################



###########################################
# replace vars in d with the vars w/imputed missing values
###########################################
imp.var<-imp.vars$x
#
str(imp.var)
dim(imp.var)
names(imp.var)

# replace in data varibles w/imputed variables
str(d[names(imp.var)])
str(imp.var)
d[names(imp.var)]<-imp.var

# review results
str(d)
contents(d)
###########################################



###########################################
# save results
###########################################
data<-d
#
str(data)
contents(data)
#
write.csv(d,file="imputed vars all 010613.csv")
z<-read.csv("imputed vars all 010613.csv",stringsAsFactors=F)

source("2. 3. a_gh_missing values imputation for all vars  010613.R")

str(data)
# delete unneeded vars
names(data)
data$ChildCountAEDI<-NULL

# calculate percentages and do scaling
d<-data
d$pct.population.in.SLA<-round(d$PersonsCountTotal/sum(d$PersonsCountTotal)*100,3)
summary(d)
# save in data
data<-d

# delete PersonsCountTotal
d<-data
d$PersonsCountTotal<-NULL
# review results
str(d)
dim(d)
contents(d)


# save data
data<-d

write.csv(d,file="imputed vars all plus scaling 010613.csv")
z<-read.csv("imputed vars all plus scaling 010613.csv",stringsAsFactors=F)

source("options.R")
source("2. 4. a_gh_scaling_and_formatting_after_missing values imputation for all vars 010613.R")  

d<- data[ ,sapply(data,is.numeric)]
str(d)
names(d)
dim(d)
# rcorr returns a list with elements 
# r, the matrix of correlations, 
# n the matrix of number of observations used in analyzing each pair of variables,
# P, the asymptotic P-values. 
# Pairs with fewer than 2 non-missing values have the r values set to NA. 
# The diagonals of n are the number of 
# non-NAs for the single variable corresponding to that row and column.
a<-rcorr(as.matrix(d))


# review results
str(a)
str(a$n )
head(a$n)
summary(as.data.frame(a$n))
# review results
View(a$r)
write.csv(a$r,file="correlations.csv")


#Determine highly correlated variables
library(caret)
highlyCorvars <- findCorrelation(a$r, cutoff = .8)
#?findCorrelation
# review results
names(d)[highlyCorvars]
names(d[ ,-highlyCorvars])

# remove the highly correlated vars
data.filtered<-d[,-highlyCorvars]
# 
contents(data.filtered)

# save the result
write.csv(data.filtered,file="filtered correlateds.csv")
# review results
a<-read.csv("filtered correlateds.csv",stringsAsFactors=FALSE)
str(a)
contents(a)


source("3. a_gh_correlation 010613.R")

##########################################################
#
# Team selection of predictors after discussion
#
##########################################################
selected.names.by.team<-c(
  "DevVulnerablePct"
  ,"DwlgRentedHsgAuthPct"
  ,"DwlNoMtrVehPct"
  ,"NursingServicesPct"
  , "BornOSEngSpeakPct"
  , "IndigPop2011Pct"
  ,"Female25.29Pct"
  ,"Female40.44Pct"
  , "FullTimeSecEduAt16Pct"
  , "CdrnInJoblessFamPct"
  , "LbrForcePartpatnPct"
  , "DlydPurchMedNotAfrdLow95Pct"
  , "SmokeDurPregPct"
  ,"PrivateHealthIns2007Pct"
  , "SocialWorkerPct"
  , "Persons0To4Pct"
  , "MorgStressPct"
  , "ImmunisedPct"
  , "MentalHealthCarePlanPct"
  , "BornNESgt5YrsPct"
  , "YouthUnemployedPct"
  , "Female30.34Pct"
  , "LowIncomeFamiliesPct"
  , "VocEduTrnPct"
  , "HshldsInDwlgRentAssistPct"
  , "DisadvMinCD"
  , "DiffTransportPct"
  , "AlcConPct"
  , "PsychiastristsPct"
  , "pct.population.in.SLA"
  , "ProvideChildCarePct"
  , "RentStressPct"
  , "GPServicesFemalePct"
  , "AustBornPct"
  , "IndigPop2006Pct"
  ,"Female20.24Pct"
  ,"Female35.39Pct"
  , "TotFertRate"
  , "SchLvrHigherEduPct"
  ,  "UnemployedPct"
  , "DisadvRank"
  , "LowBthWgtBubsPct"
  , "PrivateHealthIns2001Pct"
  , "PsychologistsPct"
  , "DiffAcesServPct"
)

# save the data as data.sel.1
data.s1<-d[selected.names.by.team]

# review results
str(data.s1)
dim(data.s1)
contents(data.s1)

# save the data as csv
write.csv(data.s1,file="vars selected by team 010613.csv")
z<-read.csv("vars selected by team 010613.csv",stringsAsFactors=F)
source("3. 1 a_gh_correlation 010613. Team selection of predictors after discussion.R")
source("options.R")



#########################################################################
#
# read in data
#
#########################################################################
a<-data.s1
str(a)
contents(a)

# 
data.s1<-a
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
# delete 2006 Indigenous data
train<-data.s1[(names(data.s1)!="IndigPop2006Pct")]

str(train)

# specify target variable and predictors to be used in the model
x<-train[ ,-which (names(data.s1) %in% c("DevVulnerablePct"))]
# 
str(x)
names(x)
#
y<-train$DevVulnerablePct  
#
str(y)




##################################=#######################################
## fit randomforest model
##################################=#######################################
fit.t <- randomForest(
  x,y,
  #data=train,
  mtry=5,
  ntree=3000,
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
(cor(ptrain,train$DevVulnerablePct))**2
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
            n.trees = 3000,# 2000 boosting iterations
            interaction.depth = 3, # How many splits in each tree
            n.minobsinnode = 5, # minimum in each node
            shrinkage = 0.000001,# learning rate
            bag.fraction = 0.7, # subsampling fraction, 0.5 is probably best
            #nTrain = 1.0,# fraction of data for training,
            # first train.fraction*N are used for training
            #cv.folds = 5,                # do 5-fold cross-validation
            verbose = FALSE)              # Do not print the details







#########################################################################
# score train data and review fit
#########################################################################
# calculate predicted values
pred=predict.gbm(gf,x,n.trees=2000)
cor(pred, y)**2

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
ranked.pred<-head(arrange(combined.importance[c("name","rank.gbf","rank.rf","rank")]
                          , rank ),50  )
ranked.pred$name
#Choose vars for regression
names(ranked.pred)
#
cat(ranked.pred$name, sep=" + ")

# explore Indigenous in 2011 and 2006. decided to keep 2011
v<-data[c("SLA_group","IndigPop2006Pct","IndigPop2011Pct")]
 v$diff<-v$IndigPop2006Pct-v$IndigPop2011Pct
# arrange(v, desc(diff))


# # ############################################################
# # # fit MARS model
# # ############################################################

library(earth)
 et<-earth(x,y,  trace=1) # note col names in x and y below
# # 
# # 
# # 
# # 
# # 
# # ############################################################
# # # review MARS model
# # ############################################################
 et
# # # 
summary(et)
# # 
# # # R-squared
et$rsq

# # 
# # 
# # 
# # 
# # #########################################################################
# # # Variable importance
# # #########################################################################
# # evimp(et, trim=FALSE)
# # 
# #
# # #
# # 
# # 

# # #########################################################################
# # #



source("4. a_gh_Random forest, earth and gbm regression 010613.R")
#source("3. a_gh_correlation.R")
source("options.R")
library("cvTools")
library("robustbase")
#


names(data.s1)
v<-data.s1

y<-v$DevVulnerablePct
#
str(v)

###########################################
# 1. perform cross-validation for an LS regression model
###########################################
fitLm <- lm(DevVulnerablePct ~ 
DlydPurchMedNotAfrdLow95Pct + UnemployedPct + 
DwlNoMtrVehPct 
+ IndigPop2011Pct 
+ SmokeDurPregPct
+ RentStressPct 
#+PrivateHealthIns2001Pct 
# + FullTimeSecEduAt16Pct 
+ NursingServicesPct + 
DisadvMinCD 
#+ HshldsInDwlgRentAssistPct
#+ PsychologistsPct 
# +LbrForcePartpatnPct 
# + PsychiastristsPct 
# + MorgStressPct
+ pct.population.in.SLA
# + Female25.29Pct
+ Female35.39Pct 
#+   LowBthWgtBubsPct 
+ Female30.34Pct 
# + DiffTransportPct
# + Female40.44Pct 
#+ SchLvrHigherEduPct
,data = v)
## cvFitLm <- cvLm(fitLm, cost = rtmspe,
#                 folds = folds, trim = 0.1)
## find predicted
#pred<-predict(fitLm,v)
#cor(pred,v$DevVulnerablePct)**2
# 0.52
summary(fitLm)


# step <- stepAIC(fitLm, direction="both")
# step$anova # display results

###########################################


fitLm$coefficients
