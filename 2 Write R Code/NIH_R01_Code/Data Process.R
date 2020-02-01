'''
I downloaded all data to my own computer and merged
the merged file can be find at /John/1 Download the Data/All NIH/from99to15.csv
you can skip this code sheet if you find from99to15
'''
raw1999<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY1999.csv")
raw2000<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2000.csv")
raw2001<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2001.csv")
raw2002<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2002.csv")
raw2003<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2003.csv")
raw2004<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2004.csv")
raw2005<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2005.csv")
raw2006<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2006.csv")
raw2007<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2007.csv")
raw2008<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2008.csv")
raw2009<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2009.csv")
raw2010<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2010.csv")
raw2011<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2011.csv")
raw2012<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2012.csv")
raw2013<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2013.csv")
raw2014<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2014.csv")
raw2015<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2015.csv")
raw2016<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2016.csv")
raw2017<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2017.csv")
raw2018<-read.csv("C:/Users/jiawangzhou/Downloads/All the Data/RePORTER_PRJ_C_FY2018.csv")
from99to15<-rbind(raw1999,raw2000,raw2001,raw2002,raw2003,raw2004,raw2005,raw2006,raw2007,raw2008)
#1999 to 2008 are the same can be merged directly
names(raw1999)
names(raw2014)
#we don't need FUNDING_MECHANISM column
raw2009$FUNDING_MECHANISM<-NULL
raw2010$FUNDING_MECHANISM<-NULL
raw2011$FUNDING_MECHANISM<-NULL
#2012 have even more useless columns,and wroung col name
raw2012$FUNDING_MECHANISM<-NULL
raw2012$DIRECT_COST_AMT<-NULL
raw2012$INDIRECT_COST_AMT<-NULL
colnames(raw2012)[colnames(raw2012)=="FUNDING_Ics"] <- "FUNDING_ICs" 

raw2013$FUNDING_MECHANISM<-NULL
raw2013$DIRECT_COST_AMT<-NULL
raw2013$INDIRECT_COST_AMT<-NULL

#same work flow as above
raw2014$FUNDING_MECHANISM<-NULL
raw2014$DIRECT_COST_AMT<-NULL
raw2014$INDIRECT_COST_AMT<-NULL

raw2015$FUNDING_MECHANISM<-NULL
raw2015$DIRECT_COST_AMT<-NULL
raw2015$INDIRECT_COST_AMT<-NULL

# fixed all, merge togetehr
from99to15<-rbind(from99to15,raw2009,raw2010,raw2011,raw2012,raw2013)
from99to15["ORG_IPF_CODE"]<-NA

'''
from99to15 is the compare group, out working group should be from 16 to 18
you can find the cleaned at /John/1 Download the Data/All NIH/from16to18.csv
'''

from99to15<-rbind(from99to15,raw2014,raw2015)
from16to18<-rbind(raw2016,raw2017,raw2018)

write.csv(from16to18,"from16to18.csv")
write.csv(from99to15,"from99to15.csv")

library(tidyverse)
library(dplyr)

#in from16to18, the PI_IDS have some residual and wired pattern some people here with same project list in same cell
from16to18<-subset(from16to18,PI_IDS!="; "&" (contact); ")
#separate_rows(PI_IDS,PI_NAMEs, sep = ";" , convert = TRUE)
