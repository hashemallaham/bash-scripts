#!/bin/bash

clear

cat <<EOF
                                        
 ####  #   #  ####  ##### ###### #    # 
#       # #  #        #   #      ##  ## 
 ####    #    ####    #   #####  # ## # 
     #   #        #   #   #      #    # 
#    #   #   #    #   #   #      #    # 
 ####    #    ####    #   ###### #    # 
                                        
                                         
#####  ###### #####   ####  #####  ##### 
#    # #      #    # #    # #    #   #   
#    # #####  #    # #    # #    #   #   
#####  #      #####  #    # #####    #   
#   #  #      #      #    # #   #    #   
#    # ###### #       ####  #    #   #   
@Eng. Hashem Allaham
hashem.allaham@gmail.com
EOF


freespace=$(df -h / | awk 'NR==2 {print $4}')
freemem=$(free -h | awk 'NR==2 {print $4}')

echo -e "\n\n"

echo -e "Quick system report for \033[0;93m $HOSTNAME \033[0m\n----------------------------------"
echo "Uptime        :		$(uptime -p)"
echo "load   average:        $(uptime | awk -F "  load average:" '{print $2}')"
echo "IP   addresses:		$(hostname -I)"
echo "MAC  addresses:		$(ifconfig | grep ether | awk '{print $2}' | paste -sd,)"
echo "Kernel release:		$(uname -r)"
echo "Bash   version:		$BASH_VERSION"
echo "CPU Model name:         $(lscpu | grep "Model name" | awk -F "Model name:" '{print $2}' | tr -d '\t' | tr  -d '[:blank:]')"
echo "CPU(s)        :		$(lscpu | grep "CPU(s)" | head -n 1 | awk '{print $2}')"
echo "CPU / Socket  :		$(lscpu | grep "Socket" | awk '{print $2}')"
echo "Core / Socket :		$(lscpu | grep "per socket" | awk '{print $4}')"
echo "Threads / core:		$(lscpu | grep "per core" | awk '{print $4}')"
echo "Num.of   disks:		$(lsblk | grep disk | wc -l)"
echo "Disk(s)   size:		$(lsblk --output NAME,TYPE,SIZE | grep "disk" | awk '{print $3}')"
echo "Num.of partion:		$(lsblk | grep part | wc -l)"
echo "Free   storage:		$freespace"
echo "Free    memory:		$freemem"
echo "Generated   on:		$(date +%F)"

