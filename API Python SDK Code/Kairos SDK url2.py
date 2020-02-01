# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import kairos_face
import pandas as pd
import csv

with open(r'/Users/zhoujiawang/Desktop/C-Change/ImageUrl2.csv', 'r') as f:
    reader = csv.reader(f)
    urlist = [tuple(row) for row in reader]

kairos_face.settings.app_id = '7b83c627'
kairos_face.settings.app_key = 'a488889a0e6b0c542a061846fd64c19c'
galleries_list = kairos_face.get_galleries_names_list()


output=kairos_face.enroll_face(url=urlist[1][3], subject_id='subject1', gallery_name='a-gallery')
print(output)

def cleanout(output):
    attribute=output['images'][0]['attributes']
    gender=attribute['gender']['type']
    asian=attribute['asian']
    black=attribute['black']
    hispanic=attribute['hispanic']
    other=attribute['other']
    white=attribute['white']
    return [gender,asian,black,hispanic,other,white]

cleanout(output)

head=('NIH ID','NameInst','gender','asian','black','hispanic','other','white')
dfP2=[]
#for row in urlist[1:]: Stoped at 1322
for row in urlist[1:]:
    try:
        output=kairos_face.enroll_face(url=row[3], subject_id='subject1', gallery_name='a-gallery')
        dfP2.append(list(row[0:2])+cleanout(output))
    except ValueError:
        dfP2.append([row[0],row[1],'NO url was scrapeed'])
        print('No URL For',row[1])
    except kairos_face.exceptions.ServiceRequestError:
        dfP2.append([row[0],row[1],'Go for next url'])
        print('Go for next url',row[1])


df_url2=pd.DataFrame(dfP2,columns = head)
df_url2.to_csv(r'\\files.brandeis.edu\c-change-bibliography\John\6. Facial Recogonition Software\Kairos URL1.csv')
df_url2.to_csv(r'/Users/zhoujiawang/Desktop/C-Change/Kairos URL2.csv')
