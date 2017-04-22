import requests
import simplejson
import json
import time
import sqlite3
from multiprocessing.dummy import Pool as ThreadPool


conn = sqlite3.connect('LOL.db',check_same_thread=False)
cur = conn.cursor()
cur.execute('''DROP TABLE IF EXISTS LOL''')
cur.execute('''CREATE TABLE LOL (
teamname1 TEXT,
teamname2 TEXT,
kills1 INTEGER ,
kills2 INTEGER ,
baronkills1 INTEGER,
baronkills2 INTEGER ,
death1 INTEGER ,
death2 INTEGER ,
dragonkills1 INTEGER ,
dragonkills2 INTEGER ,
golds1 INTEGER,
golds2 INTEGER,
assists1 INTEGER ,
assists2 INTEGER ,
towerkills1 INTEGER ,
towerkills2 INTEGER ,
scheduleid INTEGER
)''')



urls = []
for k in range(1,5000):
    address = 'http://www.wanplus.com/ajax/matchdetail/' + str(k) + '?_gtk='
    urls.append(address)

def get_pages(url):
    try:
        cookies = {'Cookie':'isShown=1; gameType=2; Hm_lvt_f69cb5ec253c6012b2aa449fb925c1c2=1492760839,1492776021,1492829141; Hm_lpvt_f69cb5ec253c6012b2aa449fb925c1c2=1492829860; wanplus_token=57293e3cf97c12f47ddb2804d60b9da6; wanplus_storage=l%2F0ntrL0OCyiKxm9zzaRyOrPVaDn%2FHeTJcAxhQX2tZbm54TvxPOBGXcz1N5tG%2BhRKLE9zwNsxT4hSYMvwI%2F04tizp3esiOFnuaiefVSDLvRzzmvP%2BvZn22cC3Fqn%2F%2BA9PKF7kQl78j9o6LSGsrttLL4dS8c5Ik56n1BeZpLB8cGJYd%2BOU8IYXYvdns9pASeH9XtTxNUyx1enZbAmS2Zd0cX6Ccx02vOWC9x1n8oawImKHRj6Vtg8EHobUOMgRbOo1PhzUP5VmW0xKkwBCsXJcgPQyjAuo%2BNxUbihVKub4EzEarKBN3hu0Ky121%2FUouR8o7%2BAmNFwC9yGssM%2BOA%2FfU5H2Ah3qZLz4%2FRp3wOU; wanplus_sid=717f86ffc5006098b35675c51acb4003; wanplus_csrf=_csrf_tk_2005064935'}
        headers = {'Headers':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36','X-Requested-With':'XMLHttpRequest'}
        response = requests.get(url, cookies = cookies, headers=headers,timeout= 5)
        response.encoding = 'utf-8'
        response = response.text
        dict_json = simplejson.loads(response)
        item_json = json.dumps(dict_json, indent=2)
        review_json = json.loads(item_json)
        #print(review_json)
        if 'dragonkills' in review_json['data']['teamStatsList']:
            teamname1 = (review_json['data']['info']['oneteam']['teamalias'])
            teamname2 = (review_json['data']['info']['twoteam']['teamalias'])
            kills1 = (review_json['data']['teamStatsList']['kills'][0])
            kills2 = (review_json['data']['teamStatsList']['kills'][1])
            baronkills1 = (review_json['data']['teamStatsList']['baronkills'][0])
            baronkills2 = (review_json['data']['teamStatsList']['baronkills'][1])
            death1 = (review_json['data']['teamStatsList']['deaths'][0])
            death2 = (review_json['data']['teamStatsList']['deaths'][1])
            dragonkills1 = (review_json['data']['teamStatsList']['dragonkills'][0])
            dragonkills2 = (review_json['data']['teamStatsList']['dragonkills'][1])
            golds1 = (review_json['data']['teamStatsList']['golds'][0])
            golds2 = (review_json['data']['teamStatsList']['golds'][1])
            assists1 = (review_json['data']['teamStatsList']['assists'][0])
            assists2 = (review_json['data']['teamStatsList']['assists'][1])
            towerkills1 = (review_json['data']['teamStatsList']['towerkills'][0])
            towerkills2 = (review_json['data']['teamStatsList']['towerkills'][1])
            scheduleid = (review_json['data']['plList'][0]['1']['scheduleid'])
            conn = sqlite3.connect('LOL.db', check_same_thread=False)
            cur = conn.cursor()
            cur.execute(
                '''INSERT OR IGNORE INTO LOL(teamname1,teamname2,kills1,kills2,baronkills1,baronkills2,death1,death2,dragonkills1,dragonkills2,golds1,golds2,assists1,assists2,towerkills1,towerkills2,scheduleid) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)''',
                (teamname1, teamname2, kills1, kills2, baronkills1, baronkills2, death1, death2, dragonkills1,dragonkills2, golds1, golds2, assists1, assists2, towerkills1, towerkills2,scheduleid))
            conn.commit()
            # print(golds1)
            print(url)
        else:
            print('do not belon to LOL',url)
    except:
        print('url do not exist',url)


pool = ThreadPool(8)
result = pool.map(get_pages,urls)

pool.close()
pool.join()
