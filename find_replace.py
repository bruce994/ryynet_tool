#-*- coding: UTF-8 -*-
import sys
import string
import time
print sys.version
import re
import os,shutil,platform,datetime

starttime = datetime.datetime.now()

#dir = "E:\\Users\\wang\\Downloads\\wap.yezizx.com\\api"   #Windows
dir = "/home/www/Guest/20160607.zz.lanrenmb.com/Home/Tpl" #查找所在目录路径  Linux
ext = "html" #查找文件后缀
#多行
find_str = u"""
<?php
if($_GET['wecha_id'] && $_GET['token']){ //url del wecha_id token   ?>
o_url = window.location.href;
n_url = o_url.replace("\&wecha\_id\=<?php echo $_GET['wecha_id'];?>","");
n_url = n_url.replace("\&token\=<?php echo $_GET['token'];?>","");
ChangeUrl(document.title, n_url);
<?php } ?>""" #找查的字符串
replace_str = u"""""" #替换的字符串口


i=0
for parent,dirnames, filenames in os.walk(dir):
    for filename in filenames:
        len1 = len(filename.rsplit('.'));
        if len1 > 1 :
            if ext == filename.rsplit('.',1)[1]:
                filename_path = os.path.join(parent, filename)
                content = file(filename_path,'r').read()

                #编码判断
                try:
                    content.decode('utf-8')
                except Exception, e:
                    #gbk
                    find_str1 = find_str.encode('gb2312')
                    replace_str1 = replace_str.encode('gb2312')
                else:
                    #utf-8
                    find_str1 = find_str.encode('utf-8')
                    replace_str1 = replace_str.encode('utf-8')

                find_str1 =  "||||".join(x.strip() for x in find_str1.splitlines())   # 过渡换行\n 行尾有空格
                replace_str1 = "||||".join(x.strip() for x in replace_str1.splitlines())
                content = "||||".join(x.strip() for x in content.splitlines())

                #print find_str1
                #print content

                if content.find(find_str1) > -1 :
                    i+=1
                    #复制文件备份
                    sysstr = platform.system()
                    if(sysstr == "Windows"):
                        src = os.getcwd() + filename_path.replace(dir.rsplit('\\',1)[0],'')
                        targetDir =  src.rsplit('\\',1)[0]
                    elif(sysstr == "Linux"):
                        src = os.getcwd() + filename_path.replace(dir.rsplit('/',1)[0],'')
                        targetDir =  src.rsplit('/',1)[0]
                    else:
                        exit()

                    if (os.path.exists(targetDir) == False):
                        os.makedirs(targetDir)
                        shutil.copy(filename_path, src)

                    content = content.replace(find_str1,replace_str1)
                    content = content.replace("||||","\n")
                    file_write = open(filename_path, 'w')
                    file_write.write(content)
                    file_write.close
                    print filename_path



print "file count:" + str(i) #打印出文件替换的个数


endtime = datetime.datetime.now()
print str((endtime - starttime).seconds) + ' sencond' #执行时间
