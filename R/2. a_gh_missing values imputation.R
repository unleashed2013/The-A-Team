source("options.R")
source("1. a_gh_read_Excel_files 290513_sample_project.R")
 

###########################################
# review missing values in the data:
contents(data)
###########################################

###########################################
# Impute numeric missing values
###########################################


###########################################
# save data as d
###########################################
d<-data
str(d)


###########################################
# select numeric vars in d
###########################################
# which(x) produces column number for the column where logical vector 
# inside which() is TRUE
d1<-d[, which(( 
           sapply(d,is.numeric)   
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
imp.d1<-kNNImpute(d1, 5)
# review results
str(imp.d1)
# here impd1$x is the data frame with imputed missing values
contents(imp.d1$x)
###########################################



###########################################
# replace numeric vars in d with the vars w/imputed missing values
###########################################
d[, which((sapply(d,is.numeric))) ]<-imp.d1$x
# review results
str(d)
contents(d)
###########################################



###########################################
# save results
###########################################
data<-d
str(data)
contents(data)
