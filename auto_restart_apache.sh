#!/bin/bash
##Note: httpd restart
#crontab 写全路径
i="0"
while [ $i -lt 4  ]
do
    killall -9 httpd.itk
    sleep 1
    i=$[$i+1]
done

#防止报错信息：No space left on device 注意这里apache 根据 ipcs -s 查看获取
/usr/bin/ipcs -s | grep apache | awk '{print $2}' | xargs ipcrm sem

/etc/init.d/httpd restart 
