source("options.R")


# Specify file location. 
# Remember to replace \  by /
file<-"C:/Users/InnaNew/Desktop/Govhack/SA_sla_data_2012_prep250513.xls"
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
                      , sheet = getSheets(wb) 
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
# 1. specify useful sheets - semi-manually, use cat(names(lst), sep='","')
usefulsheets<-  "prepared.data"
#
# 2. Create lst1 - list with useful sheets only included
lst1<-lst[usefulsheets]
#
# review results
#str(lst1)
names(lst1)
#View(lst1$Learning_Earning)
#########################################




#########################################
#
# read in the data
#
#########################################

data<-lst1$prepared.data
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
# fix formatting
d<-data
names(data)


##########################################
# 1. $ SLA..SLA.group.code code as character
##########################################
d$SLA..SLA.group.code<-as.character(d$SLA..SLA.group.code)


##########################################
# 2. Recode all vars with names containing "X" code as numeric
##########################################
 # find the vector of names of all vars that have "X" in the name:
names.X<-names(d)[str_detect(names(d),"X")!=0]
 # find all columns in d that have X in their name:
d[ ,names.X]
 # to each column of d with name containing X,  apply function as.numeric
a<-as.data.frame(sapply(d[,names.X],as.numeric) )
# review results
str(a)
summary(a)
contents(a)
# Put the formatted data back in d instead of character var's
d[names.X]<-a
str(d)

##########################################
# 3. Recode all vars with names containing ASR.per.100000  as numeric
##########################################
# find the vector of names of all vars that have "ASR.per.100000" in the name:
names.ASR.per.100000<-names(d)[str_detect(names(d),"ASR.per.100000")!=0]
d.asr<-d[names.ASR.per.100000]
contents(d.asr)
# replace commas in the data
f<-function(x){as.numeric(str_replace_all(x,",",""))}
f(d$Psychiatrists.ASR.per.100000)
#
a<-as.data.frame(sapply(d.asr,f))
# review results
str(a)
contents(a)
# replace vars
d[names.ASR.per.100000]<-a
# review results
str(d)
contents(d)

##########################################
# 4. Recode all vars with names containing ASR  as numeric
##########################################
# find the vector of names of all vars that have "ASR" in the name:
names.ASR<-names(d)[str_detect(names(d),"ASR")!=0]
# review results
names.ASR
#
d.asr<-d[names.ASR]
contents(d.asr)

#

b<-as.data.frame(sapply(d.asr,as.numeric) )
str(b)
contents(b)
#
d[names.ASR]<-b
# review results
str(d)
contents(d)

##########################################
# 5. Recode all vars with names containing SEIFA  as numeric
##########################################
# find the vector of names of all vars that have "SEIFA" in the name:
names.SEIFA<-names(d)[str_detect(names(d),"SEIFA")!=0]
# review results
names.SEIFA
#
d.SEIFA<-d[names.SEIFA]
contents(d.SEIFA)

#

c<-as.data.frame(sapply(d.SEIFA,as.numeric) )
str(c)
contents(c)
#
d[names.SEIFA]<-c
#
contents(d)


##########################################
# 6. Recode all vars with names containing births  as numeric
##########################################
# the vector  "Births","Total.fertility.rate"
names.births<-c("Births","Total.fertility.rate")
# review results
names.births
#
d.births<-d[names.births]
contents(d.births)

#

c1<-as.data.frame(sapply(d.births,as.numeric) )
str(c1)
contents(c1)
#
d[names.births]<-c1


##########################################
# 7.  review results
##########################################
str(d)
contents(d)
View(d)
#########################################


#########################################
# 8. Format the names
#########################################

str(d)
#
n1<-str_replace_all(names(d), "ASR.per.100000","")
n2<-str_replace_all(n1, "X","perc")
n3<-str_replace_all(n2, "ASR.per.100","")
n4<-str_replace_all(n3, "ASR.per.101","")
n5<-str_replace_all(n4, "ASR.per","")
#
n5
#
names(d)<-n5

#
str(d)


#########################################
# 9. save the formatted data
#########################################
data<-d
View(data)

