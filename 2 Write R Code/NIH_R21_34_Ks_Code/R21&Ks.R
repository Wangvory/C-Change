library(tidyverse)
library(foreign)
library(dplyr)
library(tidyr)
library(stringr)
library(gtools)
library(readxl)
getwd()
setwd("/Volumes/c-change-bibliography/John/Award list")

df9915<-from99to15
df9915v1<-subset(df9915,APPLICATION_TYPE==c(1,2))
df9915v1<-subset(df9915v1,select = -c(1))
df9915v2<-distinct(df9915v1,PI_IDS, .keep_all= TRUE)
df9915v3R21<-subset(df9915v2,ACTIVITY==c("R21"))
df9915v3R34<-subset(df9915v2,ACTIVITY==c("R34"))
df9915v3Ks<-subset(df9915v2,ACTIVITY==c("K01","K02","K05","K08","K21","K22","K23","K24","K25","K26","K99","KL2"))

df9915v4R21<-separate_rows(df9915v3R21,PI_IDS,PI_NAMEs,sep = ";",convert = TRUE)
df9915v4R34<-separate_rows(df9915v3R34,PI_IDS,PI_NAMEs,sep = ";",convert = TRUE)
df9915v4Ks<-separate_rows(df9915v3Ks,PI_IDS,PI_NAMEs,sep = ";",convert = TRUE)

df9915v5R21<-df9915v4R21[-which(df9915v4R21$PI_IDS==""),]
df9915v5R34<-df9915v4R34[-which(df9915v4R34$PI_IDS==""),]
df9915v5Ks<-df9915v4Ks[-which(is.na(df9915v4Ks$PI_IDS)==T),]

df9915v5R21$PI_IDS<-str_trim(str_replace(df9915v5R21$PI_IDS,fixed("(contact)"),""))
df9915v5R34$PI_IDS<-str_trim(str_replace(df9915v5R34$PI_IDS,fixed("(contact)"),""))
df9915v5Ks$PI_IDS<-str_trim(str_replace(df9915v5Ks$PI_IDS,fixed("(contact)"),""))

colnames(df9915v5R21)[28]<-"Contact.PI..Person.ID"
colnames(df9915v5R34)[28]<-"Contact.PI..Person.ID"
colnames(df9915v5Ks)[28]<-"Contact.PI..Person.ID"

df9913v5Ks<-subset(df9915v5Ks,FY<2013)

R21Plus<-mutate(R21_1619,Stats=case_when(R21_1619$Contact.PI..Person.ID%in%df9915v5R21$Contact.PI..Person.ID~"Exclude",T~"Include"))
R34Plus<-mutate(R34_1619,Stats=case_when(R34_1619$Contact.PI..Person.ID%in%df9915v5R34$Contact.PI..Person.ID~"Exclude",T~"Include"))
KsPlus<-mutate(Ks_1315,Stats=case_when(Ks_1315$Contact.PI..Person.ID%in%df9913v5Ks$Contact.PI..Person.ID~"Exclude",T~"Include"))
R21_1st<-R21Plus%>%filter(Stats=="Include")
R34_1st<-R34Plus%>%filter(Stats=="Include")
Ks_1st<-KsPlus%>%filter(Stats=="Include")
#some of these have same grant befor 2016,Ks before 2013(Maybe bacause we selected new project)

R01_1619<-subset(from16to19,select = -c(1))
R01_9915<-subset(df9915v2,ACTIVITY==c("DP2","R01","R23","R29","R37","RF1"))
R01_1315<-subset(R01_9915,FY>2012)
R21Plus2<-mutate(R21_1st,Stats=case_when(R21_1st$Contact.PI..Person.ID%in%R01_1619$Contact.PI..Person.ID~"Exclude",T~"Include"))
R34Plus2<-mutate(R34_1st,Stats=case_when(R34_1st$Contact.PI..Person.ID%in%R01_1619$Contact.PI..Person.ID~"Exclude",T~"Include"))
KsPlus2<-mutate(Ks_1st,Stats=case_when(Ks_1st$Contact.PI..Person.ID%in%R01_1315$Contact.PI..Person.ID~"Exclude",T~"Include"))
R21_Final<-R21Plus2%>%filter(Stats=="Include")
R34_Final<-R34Plus2%>%filter(Stats=="Include")
Ks_Final<-KsPlus2%>%filter(Stats=="Include")
#None of these have same grant befor 2016(Maybe bacause we selected new project)

R21_Final<-mutate(R21_Final,Organization.Name=str_to_title(Organization.Name))
R34_Final<-mutate(R34_Final,Organization.Name=str_to_title(Organization.Name))
Ks_Final<-mutate(Ks_Final,Organization.Name=str_to_title(Organization.Name))
colnames(Medical_School)[1]<-"Organization.Name"

InandExR21<-mutate(R21_Final,Stats=case_when(str_trim(Organization.Name)%in%str_trim(Medical_School[1])~"Include",
                                            str_trim(Organization.Name)%in%str_trim(Teaching_Hospitals$Name)~"Include",
                                            str_detect(Organization.Name,"Medical")~"Include",
                                            str_detect(Organization.Name,"Academy Of Medicine")~"Include",
                                            str_detect(Organization.Name,"Med Sch")~"Include",
                                            str_detect(Organization.Name,"Med Ctr")~"Include",
                                            str_detect(Organization.Name,"Medstar")~"Include",
                                            str_detect(Organization.Name,"Md Anderson Can Ctr")~"Include",
                                            str_detect(Organization.Name,"Med Sciences")~"Include",
                                            str_detect(Organization.Name,"Med & Sci")~"Include",
                                            str_detect(Organization.Name,"Md Br")~"Include",
                                            str_detect(Organization.Name,"School Of Medicine")~"Include",
                                            str_detect(Organization.Name,"School Of Public Health")~"Include",
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

InandExR34<-mutate(R34_Final,Stats=case_when(str_trim(Organization.Name)%in%str_trim(Medical_School[1])~"Include",
                                            str_trim(Organization.Name)%in%str_trim(Teaching_Hospitals$Name)~"Include",
                                            str_detect(Organization.Name,"Medical")~"Include",
                                            str_detect(Organization.Name,"Academy Of Medicine")~"Include",
                                            str_detect(Organization.Name,"Med Sch")~"Include",
                                            str_detect(Organization.Name,"Med Ctr")~"Include",
                                            str_detect(Organization.Name,"Medstar")~"Include",
                                            str_detect(Organization.Name,"Md Anderson Can Ctr")~"Include",
                                            str_detect(Organization.Name,"Med Sciences")~"Include",
                                            str_detect(Organization.Name,"Med & Sci")~"Include",
                                            str_detect(Organization.Name,"Md Br")~"Include",
                                            str_detect(Organization.Name,"School Of Medicine")~"Include",
                                            str_detect(Organization.Name,"School Of Public Health")~"Include",
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

InandExKs<-mutate(Ks_Final,Stats=case_when(str_trim(Organization.Name)%in%str_trim(Medical_School[1])~"Include",
                                            str_trim(Organization.Name)%in%str_trim(Teaching_Hospitals$Name)~"Include",
                                            str_detect(Organization.Name,"Medical")~"Include",
                                            str_detect(Organization.Name,"Academy Of Medicine")~"Include",
                                            str_detect(Organization.Name,"Med Sch")~"Include",
                                            str_detect(Organization.Name,"Med Ctr")~"Include",
                                            str_detect(Organization.Name,"Medstar")~"Include",
                                            str_detect(Organization.Name,"Md Anderson Can Ctr")~"Include",
                                            str_detect(Organization.Name,"Med Sciences")~"Include",
                                            str_detect(Organization.Name,"Med & Sci")~"Include",
                                            str_detect(Organization.Name,"Md Br")~"Include",
                                            str_detect(Organization.Name,"School Of Medicine")~"Include",
                                            str_detect(Organization.Name,"School Of Public Health")~"Include",
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
ExcludeR21<-InandExR21%>%
  filter(Stats=="Exclude")
IncludeR21<-InandExR21%>%
  filter(Stats=="Include")
IncludeR21<-distinct(IncludeR21,Contact.PI..Person.ID, .keep_all= TRUE)

ExcludeR34<-InandExR34%>%
  filter(Stats=="Exclude")
IncludeR34<-InandExR34%>%
  filter(Stats=="Include")
IncludeR34<-distinct(IncludeR34,Contact.PI..Person.ID, .keep_all= TRUE)

ExcludeKs<-InandExKs%>%
  filter(Stats=="Exclude")
IncludeKs<-InandExKs%>%
  filter(Stats=="Include")
IncludeKs<-distinct(IncludeKs,Contact.PI..Person.ID, .keep_all= TRUE)

write.csv(IncludeR21,"Include21.csv")
write.csv(IncludeR34,"Include34.csv")
write.csv(IncludeKs,"IncludeKs.csv")
