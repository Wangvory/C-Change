library(gtools)
library(dplyr)
RandK<-smartbind(Include01,Include21,Include34,IncludeKs)
RandK<-subset(RandK,select = -c(1))
RandKv2<-RandK %>%
  group_by(Contact.PI..Person.ID) %>%
  filter(n() == 1)
R01<-subset(RandKv2,Activity==c("DP2","R01","R23","R29","R37","RF1"))
R21<-subset(RandKv2,Activity==c("R21"))

R21Plus<-mutate(Include21,Stats=case_when(Include21$Contact.PI..Person.ID%in%Include01$Contact.PI..Person.ID~"Exclude",
                                          T~"Include"))
