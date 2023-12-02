#############################################################################
# Script name: log-rotation-script.sh                                       #
# Version: 1.0.1                                                            #
# Description: perform log rotation manually without logrotate daemon       #
# Author: Eng. Hashem Allaham (Syria)                                       #
# Email: hashem.allaham@gmail.com                                           #
#############################################################################

#!/bin/bash

while true
do

LOGS_PATH="/tmp/logs"
LOG_FILE="/tmp/logs/service-name.log"
# replace the service-name with anything more accurate to your needs.


DATE=$(date +%Y-%m-%d---%H-%M-%S)

# archiving the current log
tar -czf ${LOGS_PATH}/service-${DATE}.tar.gz ${LOG_FILE} &>/dev/null

# zeroing the current log (create a new log file)
true > ${LOG_FILE}

# removing any log older than last 7 logs (in case we will take a log rotation each 7 days)
# run this script as a cronjob which runs daily at 12 am
find /tmp/logs/ -type f -mmin +10080 -delete


done
