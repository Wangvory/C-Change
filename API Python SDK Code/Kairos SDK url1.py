# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import kairos_face
import pandas as pd
import csv

with open(r'\\files.brandeis.edu\c-change-bibliography\John\6. Facial Recogonition Software\ImageUrl.csv', 'r') as f:
    reader = csv.reader(f)
    urlist = [tuple(row) for row in reader]

#On Mac
with open(r'/Users/zhoujiawang/Desktop/C-Change/ImageUrl.csv', 'r') as f:
    reader = csv.reader(f)
    urlist = [tuple(row) for row in reader]


kairos_face.settings.app_id = '7b83c627'
kairos_face.settings.app_key = 'a488889a0e6b0c542a061846fd64c19c'
galleries_list = kairos_face.get_galleries_names_list()


def cleanout(output):
    attribute=output['images'][0]['attributes']
    gender=attribute['gender']['type']
    asian=attribute['asian']
    black=attribute['black']
    hispanic=attribute['hispanic']
    other=attribute['other']
    white=attribute['white']
    return [gender,asian,black,hispanic,other,white]

output=kairos_face.enroll_face(url=urlist[1:][0][1], subject_id='subject1', gallery_name='a-gallery')
cleanout(output)

head=('NameInst','gender','asian','black','hispanic','other','white')
dfP1=[]
#for row in urlist[1:]: Stoped at 1449
#for row in urlist[1:]: Stoped at 2823
#for row in urlist[1:]: Stoped at 4340
#for row in urlist[1:]: Stoped at 4350
#for row in urlist[1:]: Stoped at 4890
for row in urlist[4890:]:
    try:
        output=kairos_face.enroll_face(url=row[1], subject_id='subject1', gallery_name='a-gallery')
        dfP1.append([row[0]]+cleanout(output))
    except ValueError:
        dfP1.append([row[0],'NO url was scrapeed'])
        print('No URL For',row[0])
    except kairos_face.exceptions.ServiceRequestError:
        dfP1.append([row[0],'Go for next url'])
        print('Go for next url',row[0])
        
df_url1=pd.DataFrame(dfP1,columns = head)
df_url1.to_csv(r'/Users/zhoujiawang/Desktop/C-Change/Kairos URL1.csv')
df_url1.to_csv(r'\\files.brandeis.edu\c-change-bibliography\John\6. Facial Recogonition Software\Kairos URL1.csv')
