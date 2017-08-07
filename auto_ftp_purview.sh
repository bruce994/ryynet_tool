#!/bin/bash

## auto set ftp purview
find /home/www/Guest/ -mtime -1 | xargs setfacl -R -m u:fpta01:rwx 
