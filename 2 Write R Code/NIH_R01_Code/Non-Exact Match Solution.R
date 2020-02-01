library(tidyverse)
library(foreign)
library(dplyr)
library(tidyr)
library(stringr)
df2019<-read.csv("/Users/zhoujiawang/Downloads/2019Data.csv",stringsAsFactors = FALSE)
df1618<-read.csv("/Users/zhoujiawang/Downloads/Data16-18.csv",stringsAsFactors = FALSE)
library(gtools)
df1619<-smartbind(df2019, df1618)
df1619<-distinct(df1619,Contact.PI..Person.ID, .keep_all= TRUE)
write.csv(df1619,"from16to19.csv")
getwd()

df9915<-read.csv("/Users/zhoujiawang/Downloads/from99to15.csv",stringsAsFactors = FALSE)
df9915v1<-subset(df9915,APPLICATION_TYPE==1)
df9915v1<-subset(df9915v1,select = -c(1))
df9915v2<-distinct(df9915v1,PI_IDS, .keep_all= TRUE)
df9915v3<-subset(df9915v2,ACTIVITY==c("R01","DP2","R23","R29","R37","RF1"))
df9915v4<-separate_rows(df9915v3,PI_IDS,PI_NAMEs,sep = ";",convert = TRUE)
df9915v5<-df9915v4[-which(df9915v4$PI_IDS==""),]
df9915v5$PI_IDS<-str_trim(str_replace(df9915v5$PI_IDS,fixed("(contact)"),""))
colnames(df9915v5)[28]<-"Contact.PI..Person.ID"
df1619Plus<-mutate(df1619,Stats=case_when("Contact.PI..Person.ID"%in%df9915v5[28]~"Exclude",T~"Include"))
# 1619 have same grant befor 2016,excluded, not  many Maybe bacause we selected new project

read_excel("/Users/zhoujiawang/Desktop/Medical School.xlsx",header= F)
df1619<-mutate(df1619,Organization.Name=str_to_title(Organization.Name))
colnames(Medical_School)[1]<-"Organization.Name"
Medical_School$PI_IDS<-str_trim(str_replace(df9915v5$PI_IDS,fixed("(contact)"),""))

InandEx<-mutate(df1619,Stats=case_when(str_trim(Organization.Name)%in%str_trim(Medical_School[1])~"Include",
                                       str_trim(Organization.Name)%in%str_trim(Teaching_Hospitals$Name)~"Include",
                                       str_detect(Organization.Name,"Medical")~"Include",
                                       str_detect(Organization.Name,"Med Sch")~"Include",
                                       str_detect(Organization.Name,"Med Ctr")~"Include",
                                       str_detect(Organization.Name,"Medstar")~"Include",
                                       str_detect(Organization.Name,"Md Anderson Can Ctr")~"Include",
                                       str_detect(Organization.Name,"Med Sciences")~"Include",
                                       str_detect(Organization.Name,"Med & Sci")~"Include",
                                       str_detect(Organization.Name,"Md Br")~"Include",
                                       str_detect(Organization.Name,"School Of Medicine")~"Include",
                                       str_detect(Organization.Name,"Univ Of Medicine")~"Include",
                                       str_detect(Organization.Name,"Sch Of Med")~"Include",
                                       str_detect(Organization.Name,"Einstein Healthcare")~"Include",
                                       str_detect(Organization.Name,"College Of Medicine")~"Include",
                                       str_detect(Organization.Name,"Hosp")~"Include",
                                       str_detect(Organization.Name,"Hospital")~"Include",
                                       str_detect(Organization.Name,"Health Science")~"Include",
                                       str_detect(Organization.Name,"Health & Science")~"Include",
                                       str_detect(Organization.Name,"Health Sci")~"Include",
                                       str_detect(Organization.Name,"Hlth")~"Include",
                                       str_detect(Organization.Name,"Health Alliance")~"Include",
                                       str_detect(Organization.Name,"Healthsystem")~"Include",
                                       str_detect(Organization.Name,"Med Scis")~"Include",
                                       str_detect(Organization.Name,"Can Research")~"Include",
                                       str_detect(Organization.Name,"Cancer Inst")~"Include",
                                       str_detect(Organization.Name,"Cancer Ctr")~"Include",
                                       str_detect(Organization.Name,"Cancer Center")~"Include",
                                       str_detect(Organization.Name,"Cleveland Clinic Lerner Com")~"Include",
                                       str_detect(Organization.Name,"Osteopathic Med")~"Include",
                                       str_detect(Organization.Name,"Eye And Ear Infirmary")~"Include",
                                       T~"Exclude"))
# Wordn Health Hospital Med Sch Medical 
Exclude<-InandEx%>%
  filter(Stats=="Exclude")
Include<-InandEx%>%
  filter(Stats=="Include")
setwd("/Volumes/c-change-bibliography/John")
write.csv(Exclude,"exclude.csv")
write.csv(Include,"Include.csv")

ExcludeUnique<-unique(Exclude$Organization.Name)%>%View()
write.csv(ExcludeUnique,"ExcludeUnique.csv")
