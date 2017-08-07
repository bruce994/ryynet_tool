#!/bin/bash
##Note: httpd restart
#crontab 写全路径
EMAILMESSAGE="/home/Tool/emailHttpd.txt"
url=$(curl -I -m 10 -o /dev/null -s -w %{http_code}  test2.tt.lanrenmb.com/Home/index.php/Index/index/id/54.html)
echo $url >$EMAILMESSAGE
if echo "$url" | grep -q "000"; then
    i="0"
    while [ $i -lt 4  ]
    do
        killall -9 httpd.itk
        sleep 1
        i=$[$i+1]
    done

    #防止报错信息：No space left on device 注意这里apache 根据 ipcs -s 查看获取
    /usr/bin/ipcs -s | grep apache | awk '{print $2}' | xargs ipcrm sem

    /etc/init.d/httpd restart >>$EMAILMESSAGE

    # send an email using mail
    SUBJECT="zhejiang httpd restart"
    # Email To ?
    EMAIL="1330407081@qq.com"
    echo "httpd restart" >>$EMAILMESSAGE
    mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
    exit 0
fi
exit 0

