#!/bin/bash

## Note: will kill the top-most process if the $CPU_LOAD is greater than the $CPU_THRESHOLD.
echo
echo checking for run-away process ...

CPU_LOAD=$(uptime | cut -d"," -f4 | cut -d":" -f2 | cut -d" " -f2 | sed -e "s/\.//g")
CPU_THRESHOLD=400

if [ $CPU_LOAD -gt $CPU_THRESHOLD ] ; then

  EMAILMESSAGE="/tmp/emailmessage.txt"
  echo "System overloading, possible runaway process."> $EMAILMESSAGE

  while [ $CPU_LOAD -gt $CPU_THRESHOLD ]
  do
      
      CPU_LOAD=$(uptime | cut -d"," -f4 | cut -d":" -f2 | cut -d" " -f2 | sed -e "s/\.//g")
      PROCESS=$(ps aux r)
      TOPPROCESS=$(ps -eo pid -eo pcpu -eo command | sort -k 2 -r | grep -v PID | head -n 1)

      #find httpd.itk process
      SOURCE="httpd.itk" 
      if echo "$TOPPROCESS" | grep -q "$SOURCE"; then
          # kill -9 $(ps -eo pid | sort -k 1 -r | grep -v PID | head -n 1) #original
          # kill -9 $(ps -eo pcpu | sort -k 1 -r | grep -v %CPU | head -n 1)
           
            for pid in $TOPPROCESS   #以空格分隔    32525  8.0 /usr/sbin/httpd.itk
            do
                echo $pid
                kill -9 $pid
                break
            done

          echo system overloading!
          echo Top-most process killed $TOPPROCESS
          echo load average is at $CPU_LOAD

          # Email text/message
          echo "Top-most process killed $TOPPROCESS" >>$EMAILMESSAGE
          echo "Load average was at $CPU_LOAD" >>$EMAILMESSAGE

          sleep 2
      else
          echo "no match"
          break
          #exit 0
      fi
  done


  # send an email using mail
  SUBJECT="zhejiang kill process"
  # Email To ?
  EMAIL="1330407081@qq.com"
  echo "Active processes..." >>$EMAILMESSAGE
  echo "$PROCESS" >>$EMAILMESSAGE
  #mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE

else
 echo
 echo no run-aways.
 echo load average is at $CPU_LOAD

fi

exit 0





