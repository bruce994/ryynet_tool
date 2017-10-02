#!/usr/bin/env python
#-*- coding: UTF-8 -*-
import sys
import string
import time
print sys.version
import re
import os,shutil,platform,datetime
import calendar
starttime = datetime.datetime.now()


year = starttime.strftime("%Y")
month = starttime.strftime("%B")[:3]
day = starttime.strftime("%d")
hour = starttime.strftime("%H")
#current_date =  day + "/" + month + "/" + year + ":" + hour
current_date =  day + "/" + month + "/" + year

os.system("ipset create blacklist hash:ip hashsize 4096 maxelem 1000000")  #创建集合，由于ipse存在于内存中,重启服务器失效，所以需要创建


blacklist_date = "/home/Tool/blacklist_date.txt"
if os.path.isfile(blacklist_date):
    f = open(blacklist_date, 'r')
    date1 = f.read()
    if date1 != current_date :
        os.system("ipset flush blacklist")  #清空blacklist 集合
        f = open(blacklist_date, 'w')
        f.write(current_date)
        f.close()
else:
    f = open(blacklist_date, 'w')
    f.write(current_date)
    f.close()



ipNum = "500"
log = ['/home/log/wxsy.zz.lanrenmb.cn-','/home/log/jiahe.zz.lanrenmb.com-']

for f in log:
    print f
    ssh_1 = "cat "+f+starttime.strftime("%Y-%m-%d")+".access.log |grep '"+current_date+"' |cut -d ' ' -f 1 |sort |uniq -c | awk '{if ($1 > "+ipNum+") print $2}'|sort -nr |less | awk '{print \"ipset add blacklist\",$0}'|sh"
    #print ssh_1
    os.system(ssh_1)




#移除腾讯CDN IP
os.system("ipset del blacklist 183.3.254.0/24")
os.system("ipset del blacklist 58.250.143.0/24")
os.system("ipset del blacklist 183.3.254.0/24")
os.system("ipset del blacklist 123.151.76.0/24")
os.system("ipset del blacklist 111.161.109.0/24")
os.system("ipset del blacklist 123.151.76.0/24")
#END



#移除指定IP
os.system("cat /etc/ddos/ignore.ip.list | awk '{print \"ipset del blacklist\",$0}'|sh")


endtime = datetime.datetime.now()
print str((endtime - starttime).seconds) + ' sencond' #执行时间
