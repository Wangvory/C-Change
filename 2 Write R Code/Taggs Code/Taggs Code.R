library(tidyverse)
library(foreign)
library(dplyr)
library(tidyr)
library(stringr)
library(readxl)
taggs<-read.csv("/Users/zhoujiawang/Downloads/TAGGS Export.csv",stringsAsFactors = FALSE)
library(gtools)
setwd('/Volumes/c-change-bibliography/John/TAGGS')

taggs9915R01<-read.csv("/Users/zhoujiawang/Downloads/taggs9915R01.csv",stringsAsFactors = FALSE)
taggs9915R21<-read.csv("/Users/zhoujiawang/Downloads/taggs9915R21.csv",stringsAsFactors = FALSE)

taggsR01<-taggs[grep("R01", taggs$Award.Number), ]
taggsR21<-taggs[grep("R21", taggs$Award.Number), ]
#taggsR34<-taggs[grep("R34", taggs$Award.Number), ], No R34 in the database



#df9915v1<-subset(df9915v1,select = -c(1))
#df9915v2<-distinct(df9915v1,PI_IDS, .keep_all= TRUE)
#df9915v3<-subset(df9915v2,ACTIVITY==c("R01","DP2","R23","R29","R37","RF1"))
#df9915v4<-separate_rows(df9915v3,PI_IDS,PI_NAMEs,sep = ";",convert = TRUE)
#df9915v5<-df9915v4[-which(df9915v4$PI_IDS==""),]
#df9915v5$PI_IDS<-str_trim(str_replace(df9915v5$PI_IDS,fixed("(contact)"),""))


colnames(taggsR01)[15]<-"Contact.PI..Person.Name"
colnames(taggsR21)[15]<-"Contact.PI..Person.Name"
colnames(taggs9915R01)[15]<-"Contact.PI..Person.Name"
colnames(taggs9915R21)[15]<-"Contact.PI..Person.Name"

taggsR01<-distinct(taggsR01, Contact.PI..Person.Name, .keep_all = TRUE)
taggsR21<-distinct(taggsR21, Contact.PI..Person.Name, .keep_all = TRUE)
taggs9915R01<-distinct(taggs9915R01, Contact.PI..Person.Name, .keep_all = TRUE)

taggsR01Plus<-mutate(taggsR01,Stats=case_when(taggsR01$Contact.PI..Person.Name %in% taggs9915R01$Contact.PI..Person.Name~"Exclude",T~"Include"))
taggsR01Final<-taggsR01Plus%>%
  filter(Stats=="Include")

taggsR21Plus<-mutate(taggsR21,Stats=case_when(taggsR21$Contact.PI..Person.Name %in% taggs9915R21$Contact.PI..Person.Name~"Exclude",T~"Include"))
taggsR21Final<-taggsR21Plus%>%
  filter(Stats=="Include")


Medical_School<-read_excel("/Users/zhoujiawang/Desktop/C-Change/institution list/Medical School.xlsx")
Teaching_Hospitals<-read_excel("/Users/zhoujiawang/Desktop/C-Change/institution list/Teaching Hospitals.xlsx")
taggsR01Final<-mutate(taggsR01Final,Organization.Name=str_to_title(Recipient.Name))
taggsR21Final<-mutate(taggsR21Final,Organization.Name=str_to_title(Recipient.Name))
colnames(Medical_School)[1]<-"Organization.Name"

TaggInExR01<-mutate(taggsR01Final,Stats=case_when(str_trim(Organization.Name)%in%str_trim(Medical_School[1])~"Include",
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
                                            str_detect(Organization.Name,"Dartmouth-Hitchcock Clinic")~"Include",
                                            str_detect(Organization.Name,"Hennepin")~"Include",
                                            T~"Exclude"))

TaggInExR21<-mutate(taggsR21Final,Stats=case_when(str_trim(Organization.Name)%in%str_trim(Medical_School[1])~"Include",
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
                                                  str_detect(Organization.Name,"Dartmouth-Hitchcock Clinic")~"Include",
                                                  str_detect(Organization.Name,"Hennepin")~"Include",
                                                  T~"Exclude"))


# Wordn Health Hospital Med Sch Medical 
taggR01Ex<-TaggInExR01%>%
  filter(Stats=="Exclude")
taggR01In<-TaggInExR01%>%
  filter(Stats=="Include")
unique(taggR01Ex$Organization.Name)%>%View()

taggR21Ex<-TaggInExR21%>%
  filter(Stats=="Exclude")
taggR21In<-TaggInExR21%>%
  filter(Stats=="Include")

write.csv(taggR01In,"taggsR01.csv")
write.csv(taggR21In,"taggsR21.csv")

ExcludeUnique<-unique(Exclude$Organization.Name)%>%View()
write.csv(ExcludeUnique,"ExcludeUnique.csv")

