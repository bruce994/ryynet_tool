#!/bin/bash
##Note: httpd restart
#crontab 写全路径
EMAILMESSAGE="/home/ryynet1/Tool/monitor.log"
domain="vote.lanrenmb.com/Member/index.php"
url=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $domain )
if echo "$url" | grep -q "000"; then
    docker restart lanren >> $EMAILMESSAGE
    DATE=`date '+%Y-%m-%d %H:%M:%S'`
    echo $domain"-"$url-$DATE > $EMAILMESSAGE

    SUBJECT="docker restart lanren"
    EMAIL="271059875@qq.com"
    mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
fi


# -----------------------------------------------------------------
#500 error restart nginx
domain="vote.lanrenmb.com/Member/index.php"
url=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $domain )
if echo "$url" | grep -q "500"; then
    docker restart web >> $EMAILMESSAGE
    DATE=`date '+%Y-%m-%d %H:%M:%S'`
    echo $domain"-"$url-$DATE > $EMAILMESSAGE

    SUBJECT="docker restart web"
    EMAIL="271059875@qq.com"
    mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
fi



exit 0
