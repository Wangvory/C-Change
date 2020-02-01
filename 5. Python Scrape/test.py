#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  1 11:15:58 2019

@author: zhoujiawang
"""
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  1 11:14:01 2019

@author: zhoujiawang
"""

import argparse
import json
import itertools
import logging
import re
import os
import uuid
import sys
from urllib.request import urlopen, Request
import pandas as pd
from bs4 import BeautifulSoup


def configure_logging():
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    handler = logging.StreamHandler()
    handler.setFormatter(
        logging.Formatter('[%(asctime)s %(levelname)s %(module)s]: %(message)s'))
    logger.addHandler(handler)
    return logger

logger = configure_logging()

REQUEST_HEADER = {'User-Agent': "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.134 Safari/537.36"}


def get_soup(url, header):
    response = urlopen(Request(url, headers=header))
    return BeautifulSoup(response, 'html.parser')


def get_query_url(query):
    return "https://www.google.co.in/search?q=%s&source=lnms&tbm=isch" % query


def extract_images_from_soup(soup):
    image_elements = soup.find_all("div", {"class": "rg_meta"})
    metadata_dicts = (json.loads(e.text) for e in image_elements)
    link_type_records = ((d["ou"], d["ity"]) for d in metadata_dicts)
    return link_type_records

def extract_images(query, num_images):
    url = get_query_url(query)
    logger.info("Souping")
    soup = get_soup(url, REQUEST_HEADER)
    logger.info("Extracting image urls")
    link_type_records = extract_images_from_soup(soup)
    return itertools.islice(link_type_records, num_images)

def get_raw_image(url):
    req = Request(url, headers=REQUEST_HEADER)
    resp = urlopen(req)
    return resp.read()

#get_raw_image()返回的是inspect的所有内容
#重点在此！
def download_images_to_dir(images, num_images,lst1):
    lst2=[]
    for i, (url, image_type) in enumerate(images):
        try:
            logger.info("Making request (%d/%d): %s", i, num_images, url)
            lst2.append(url)
        except Exception as e:
            logger.exception(e)
    lst1.extend(lst2)

def run(query,lst1,num_images=5):
    query = '+'.join(query.split())
    logger.info("Extracting image links")
    images = extract_images(query, num_images)
    logger.info("Downloading images")
    download_images_to_dir(images, num_images,lst1)
    logger.info("Finished")

def main(qurey,lst1):
    parser = argparse.ArgumentParser(description='Scrape Google images')
    parser.add_argument('-s', '--search', default=qurey[0], type=str, help='search term')
    parser.add_argument('-n', '--num_images', default=5, type=int, help='num images to save')
    parser.add_argument('-l', '--list', default=lst1, type=list, help='original list to append')
    args = parser.parse_args()
    run(args.search,args.list,args.num_images)

import csv
with open('//files.brandeis.edu/c-change-bibliography/John/Python Scrape/Search Key.csv', 'r') as reader:
    keyword = csv.reader(reader)
    qureys = list(keyword)[1:]


df=[]
for qurey in qureys[4242:]:
    try:
        lst=[]
        lst.extend(qurey)
        main(qurey,lst)
        df.append(lst)
    except Exception:
        pass

final_df=pd.DataFrame(df)
export_csv = final_df.to_csv (r'//files.brandeis.edu/c-change-bibliography/John/Python Scrape/ImageUrl.csv', index = None, header=True)
