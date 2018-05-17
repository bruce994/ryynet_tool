#!/bin/bash
##Note: httpd restart
#crontab 写全路径
EMAILMESSAGE="/home/ryynet1/Tool/emailHttpd.txt"
url=$(curl -I -m 10 -o /dev/null -s -w %{http_code}  vote.lanrenmb.com/Member/index.php?m=Public&a=login)
echo $url >$EMAILMESSAGE
if echo "$url" | grep -q "000"; then
    #i="0"
    #while [ $i -lt 4  ]
    #do
    #    killall -9 httpd.itk
    #    sleep 1
    #    i=$[$i+1]
    #done
    ##防止报错信息：No space left on device 注意这里apache 根据 ipcs -s 查看获取
    #/usr/bin/ipcs -s | grep apache | awk '{print $2}' | xargs ipcrm sem
    #/etc/init.d/httpd restart >>$EMAILMESSAGE

    /bin/bash /home/ryynet_docker/web_php_restart.sh >>$EMAILMESSAGE

    # send an email using mail
    SUBJECT="zhejiang httpd restart"
    # Email To ?
    EMAIL="271059875@qq.com"
    echo "httpd restart" >>$EMAILMESSAGE
    mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
    exit 0
fi



exit 0

