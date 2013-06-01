source("options.R")
source("a_gh_read_Excel_files 170513.R")
source("a_gh_missing values imputation.R")       


##############################################################
# Create a column with first 4 digits of the code
##############################################################
# 1. Create a column with first 4 digits of the code
slaFirst4<-str_sub(data$SLA..SLA.group.code,1,4)
head(slaFirst4)
data$slaFirst4<-slaFirst4
#review results
str(data)
View(data)
#
# 2. Put the column slaFirst4 to be first in the data
d<-data[ ,c("slaFirst4", names(data)[names(data)!="slaFirst4"]  )
#       ]
#review results
names(d)
##############################################################

        
        

##############################################################
# create Frequency table of the created variable
table(d$slaFirst4,exclude=NULL)
##############################################################



       
##############################################################
# add a variable newvar which is the aggregated average of 
# X..total.Centrelink.concession.card.holders over slaFirst4
##############################################################
d<-transform(d, newvar=ave(X..total.Centrelink.concession.card.holders,
                          slaFirst4))
#
#review results
head(d)
##############################################################


          