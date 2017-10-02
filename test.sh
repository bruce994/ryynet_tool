#!/bin/bash
##Note: httpd restart
url=$(curl -I -m 10 -o /dev/null -s -w %{http_code}  vote.lanrenmb.com)
if echo "$url" | grep -q "000"; then
    i="0"
    while [ $i -lt 4  ]
    do
        killall -9 httpd.itk
        echo "$url" >> /home/Tool/test.log
        sleep 1
        i=$[$i+1]
    done
    /etc/init.d/httpd restart > /home/Tool/httpd.log

    # send an email using mail
    SUBJECT="zhejiang httpd restart"
    # Email To ?
    EMAIL="1330407081@qq.com"
    EMAILMESSAGE="/tmp/emailmessage.txt"
    echo "httpd restart" >>$EMAILMESSAGE
    mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE

fi
exit 0


