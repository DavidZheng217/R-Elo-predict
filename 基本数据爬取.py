# 数据源：http://www.wanplus.com/lol

import requests
import sqlite3
import json
import math
import time
import csv
from bs4 import BeautifulSoup
from multiprocessing.dummy import Pool as ThreadPool

t_start = time.time()

conn = sqlite3.connect('LOL_match.db',check_same_thread = False)
cur = conn.cursor()
cur.execute('''DROP TABLE IF EXISTS L_Match''')
cur.execute('''
CREATE TABLE L_Match (
scheduleid UNIQUE PRIMARY KEY NOT NULL,
name_1 TEXT,
name_2 TEXT,
name_1_win TEXT,
name_2_win TEXT,
name_1_country TEXT,
name_2_country TEXT
)''')

raw_cookie = 'wanplus_token=5acfdc53a08dc0bbbd0394a997b8e34e; wanplus_storage=lf4m67eka3o; wanplus_sid=07ec99d65013370bf69ae499d57a0d6d; wanplus_csrf=_csrf_tk_1561048384; gameType=2; Hm_lvt_f69cb5ec253c6012b2aa449fb925c1c2=1492760524; Hm_lpvt_f69cb5ec253c6012b2aa449fb925c1c2=1492760579'
cookies = { }
for line in raw_cookie.split(';') :
    key,value = line.split('=',maxsplit=1)
    cookies[key] = value
headers = {'User-Agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0) Gecko/20100101 Firefox/52.0'}


urls = []
for id_num in range(32,50) :
    for page_count in range(1,11) :   #range(1,math.ceil(61/20) + 1)
        address = 'https://www.wanplus.com/ajax/team/recent?isAjax=1&teamId='+ str(id_num) +'&gameType=2&objTeamId=0&page='+ str(page_count) +'&totalPage=undefined&totalItems=?&_gtk='
        #    '+ str(page_count) +'
        urls.append(address)

def get_page(url) :
    page = requests.post(url, headers=headers, cookies=cookies)
    try :
        data = json.loads(page.text)
        #print(json.dumps(data,indent=3))
        return data
    except :
        return 'None'

def process_page(url) :
    detail = get_page(url)
    if detail != 'None' :
        info = detail['data']
        for stuff in info:
            schedule_id = stuff['scheduleid']
            name_1 = stuff['oneseedname']
            name_2 = stuff['twoseedname']
            name_1_win = stuff['onewin']
            name_2_win = stuff['twowin']
            name_1_country = stuff['onecountry']
            name_2_country = stuff['twocountry']

            conn = sqlite3.connect('LOL_match.db', check_same_thread=False)
            cur = conn.cursor()
            cur.execute('''INSERT OR IGNORE INTO L_Match(scheduleid,name_1,name_2,name_1_win, name_2_win,name_1_country,name_2_country) VALUES (?,?,?,?,?,?,?)''',
                        (schedule_id,name_1,name_2,name_1_win,name_2_win,name_1_country,name_2_country))
            conn.commit()
        print('store data successfully from', url)
    else :
        print('Page not exists', url)
    time.sleep(1)


pool = ThreadPool(4)  # don't set this number too high
result = pool.map(process_page,urls)

pool.close()
pool.join()

t_end = time.time()
print('cost(secound) :',t_end - t_start)
