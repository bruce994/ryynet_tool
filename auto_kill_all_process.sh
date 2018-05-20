#!/bin/bash

## Note: will kill the top-most process if the $CPU_LOAD is greater than the $CPU_THRESHOLD.

CPU_LOAD=$(uptime | cut -d"," -f4 | cut -d":" -f2 | cut -d" " -f2 | sed -e "s/\.//g")
CPU_THRESHOLD=400

while [ true ]
do

  while [ $CPU_LOAD -gt $CPU_THRESHOLD ]
  do

      CPU_LOAD=$(uptime | cut -d"," -f4 | cut -d":" -f2 | cut -d" " -f2 | sed -e "s/\.//g")
      PROCESS=$(ps aux r)
      TOPPROCESS=$(ps -eo pid -eo pcpu -eo command | sort -k 2 -r | grep -v PID | head -n 1)

      #find httpd.itk process
      SOURCE="php-fpm"
      if echo "$TOPPROCESS" | grep -q "$SOURCE"; then
          # kill -9 $(ps -eo pid | sort -k 1 -r | grep -v PID | head -n 1) #original
          # kill -9 $(ps -eo pcpu | sort -k 1 -r | grep -v %CPU | head -n 1)

            for pid in $TOPPROCESS   #以空格分隔    32525  8.0 /usr/sbin/httpd.itk
            do
                echo $pid
                kill -9 $pid
                break
            done

          echo Top-most process killed $TOPPROCESS
          echo load average is at $CPU_LOAD
          echo '--------------------------------'

          sleep 1
      else
          echo "no match"
          break
          #exit 0
      fi
  done

  sleep 2
done

exit 0





