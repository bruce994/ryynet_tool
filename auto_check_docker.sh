#!/bin/bash
##Note: httpd restart
#crontab 写全路径
EMAILMESSAGE="/home2/Tool/monitor.log"
domain="jiahe.zz.lanrenmb.com/Member/index.php"
url=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $domain )
if echo "$url" | grep -q "000"; then
    docker restart jiahe >> $EMAILMESSAGE
    DATE=`date '+%Y-%m-%d %H:%M:%S'`
    echo $domain"-"$url-$DATE >> $EMAILMESSAGE
fi

domain="download.lanrenmb.com/index.php"
url=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $domain )
if echo "$url" | grep -q "000"; then
    /bin/bash /home2/ryynet_docker/web_php_restart.sh >> $EMAILMESSAGE
    DATE=`date '+%Y-%m-%d %H:%M:%S'`
    echo $domain"-"$url-$DATE >> $EMAILMESSAGE
fi



exit 0
