#!/usr/bin/env python
#-*- coding: UTF-8 -*-
import sys
import os
import string
import time
print sys.version
import re
import shutil
from time import gmtime, strftime
import datetime



path = "/home2/Guest/virtual_guest/www.pzjhome.com/"
dirList = os.listdir(path)

check = ["1","11.sql","1208pzj.zip","2.6.zip","a","admin","adminer-4.3.1-mysql.php","anli.php","chaigai","data","fangshui","favicon.ico","fuwuliucheng","guanyuwomen","httpd.ini","huodong","huodong_pc","images","include","index.htm","index.html","index.php","install","jingdiananli","jungong","lianxiwomen","m","member","misc","mugong","niwa","old_admin","pc_price.php","plus","price","price.php","price_success.html","price_success.html.bak","publics","README.md","robots.txt","search_case.php","search_desgin.php","shejituandui","shijingyangbanjian","shuidian","special","tags.php","templets","test.php","uploads","wap","youqi","zaixianyuyue","zhuangxiuzhibo","zhuangxiuzhishi","zhuyingyewu","gong",".git",".gitignore"]

#print len(check)
#删除主目录不存在的文件
for fname in dirList:
        if fname not in check:
                tmp = os.path.join(path, fname)
                if os.path.isdir(tmp)==False:
                        os.remove(tmp)
                if os.path.isdir(tmp)==True:
                        shutil.rmtree(tmp)
                print tmp

start="8:30:00"
End="18:30:00"
now = datetime.datetime.now()
Tocompare=now.strftime("%H:%M:%S")
print Tocompare

start = datetime.datetime.strptime(start, '%H:%M:%S')
End = datetime.datetime.strptime(End, '%H:%M:%S')
Tocompare=datetime.datetime.strptime(Tocompare, '%H:%M:%S')


os.chdir(path)

check_file = " ".join(check)
if start < Tocompare and  End > Tocompare:
    os.system("chattr -i -R " + check_file)
else :
    os.system("chattr +i -R " + check_file)


os.system("chattr +a -R uploads")
os.system("chattr +i -R include/ admin/ old_admin/ plus/ templets/  misc/ tags.php robots.txt ")
os.system("chattr -i -R data/tplcache/ data/sessions/ data/cache/ index.html ")
