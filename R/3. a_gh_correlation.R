source("options.R")
source("2. a_gh_missing values imputation.R")  

d<- data[ ,sapply(data,is.numeric)]
str(d)
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

#Determine highly correlated variables
library(caret)
highlyCorvars <- findCorrelation(a$r, cutoff = .95)
# review results
names(d)[highlyCorvars]
names(d[ ,-highlyCorvars])

# remove the highly correlated vars
data<-d[,-highlyCorvars]
# 
contents(data)

# save the result
write.csv(data,file="sample_project_290513.csv")
# review results
a<-read.csv("sample_project_290513.csv",stringsAsFactors=FALSE)
str(a)
contents(a)
