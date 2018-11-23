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


#先删除
os.system("iptables -D DOCKER -m set --match-set blacklist src -p tcp --destination-port 80 -j DROP")
#docker 阻止ipset集合 先执行如何命令
os.system("iptables -I DOCKER -m set --match-set blacklist src -p tcp --destination-port 80 -j DROP")


year = starttime.strftime("%Y")
month = starttime.strftime("%B")[:3]
day = starttime.strftime("%d")
hour = starttime.strftime("%H")
#current_date =  day + "/" + month + "/" + year + ":" + hour
current_date =  day + "/" + month + "/" + year

os.system("ipset create blacklist hash:ip hashsize 4096 maxelem 1000000")  #创建集合，由于ipse存在于内存中,重启服务器失效，所以需要创建

os.system("ipset flush blacklist")  #清空blacklist 集合

#blacklist_date = "/home/ryynet1/Tool/blacklist_date.txt"
#if os.path.isfile(blacklist_date):
#    f = open(blacklist_date, 'r')
#    date1 = f.read()
#    if date1 != current_date :
#        os.system("ipset flush blacklist")  #清空blacklist 集合
#        f = open(blacklist_date, 'w')
#        f.write(current_date)
#        f.close()
#else:
#    f = open(blacklist_date, 'w')
#    f.write(current_date)
#    f.close()


ipNum = "1000"
#log = ['/home2/ryynet_docker/log/jiahe.zz.lanrenmb.com-']

log  = open("/home/ryynet1/Tool/blacklist_site_docker.txt")
for f in log.readlines():
    f = f[0:-1]
    print f
    ssh_1 = "cat "+f+starttime.strftime("%Y-%m-%d")+"-access.log |grep '"+current_date+"' |cut -d ' ' -f 1 |sort |uniq -c | awk '{if ($1 > "+ipNum+") print $2}'|sort -nr |less | awk '{print \"ipset add blacklist\",$0}'|sh"
    #print ssh_1
    os.system(ssh_1)

    remove_ip = "cat "+f+starttime.strftime("%Y-%m-%d")+"-access.log |grep 'event.php' |cut -d ' ' -f 1 |sort |uniq -c | awk '{if ($1 > 1) print $2}'|sort -nr |less | awk '{print \"ipset del blacklist\",$0}'|sh"
    os.system(remove_ip)
    remove_ip = "cat "+f+starttime.strftime("%Y-%m-%d")+"-access.log |grep 'Weixin&a=index' |cut -d ' ' -f 1 |sort |uniq -c | awk '{if ($1 > 1) print $2}'|sort -nr |less | awk '{print \"ipset del blacklist\",$0}'|sh"
    os.system(remove_ip)
    remove_ip = "cat "+f+starttime.strftime("%Y-%m-%d")+"-access.log |grep 'notify_url.php' |cut -d ' ' -f 1 |sort |uniq -c | awk '{if ($1 > 1) print $2}'|sort -nr |less | awk '{print \"ipset del blacklist\",$0}'|sh"
    os.system(remove_ip)
    remove_ip = "cat "+f+starttime.strftime("%Y-%m-%d")+"-access.log |grep 'Member/index.php' |cut -d ' ' -f 1 |sort |uniq -c | awk '{if ($1 > 1) print $2}'|sort -nr |less | awk '{print \"ipset del blacklist\",$0}'|sh"
    os.system(remove_ip)
#手动添加指定IP
os.system("cat /home/ryynet1/Tool/blacklist.ip.list | awk '{print \"ipset add blacklist\",$0}'|sh")

#移除腾讯CDN IP
cdns = ['112.29.152.','112.90.51.','113.207.39.','115.231.37.','117.169.77.','117.34.36.','119.147.227.','120.41.44.','125.39.6.','180.163.68.','182.247.229.','218.60.33.','219.146.241.','220.170.91.','221.204.182.','222.161.220.','223.87.3.','42.236.2.','58.216.25.','60.174.156.','61.184.213.','61.240.150.','183.3.254.','58.250.143.','101.227.163.','123.151.76.','111.161.109.','140.207.120.','101.226.233.','183.3.234.']
for cdn in cdns :
    for x in xrange(1,255):
        os.system("ipset del blacklist "+cdn+str(x)+"")
#END


#移除指定IP
os.system("cat /home/ryynet1/Tool/ignore.ip.list | awk '{print \"ipset del blacklist\",$0}'|sh")

endtime = datetime.datetime.now()
print str((endtime - starttime).seconds) + ' sencond' #执行时间
