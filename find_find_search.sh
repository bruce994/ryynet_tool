#!/bin/bash
find /home2/ -name "Tpl" | while read line; do
    find $line -name "*.jpg" -type f -size +200k | while read line2; do
         echo "$line2"
         rm $line2
     done
 done


