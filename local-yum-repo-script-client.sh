#!/bin/bash

clear
echo -e "\n\n"


read -p "Enter the IP or hostname for the local yum repo server: " LOCAL_YUM_SERVER_IP
echo -e "\n"
echo "create local repos file..."
cat >>/etc/yum.repos.d/local-repos.repo <<EOF
[local-base]
name=CentOS Base
baseurl=http://$LOCAL_YUM_SERVER_IP/base/
gpgcheck=0
enabled=1

[local-centosplus]
name=CentOS CentOSPlus
baseurl=http://$LOCAL_YUM_SERVER_IP/centosplus/
gpgcheck=0
enabled=1

[local-extras]
name=CentOS Extras
baseurl=http://$LOCAL_YUM_SERVER_IP/extras/
gpgcheck=0
enabled=1

[local-updates]
name=CentOS Updates
baseurl=http://$LOCAL_YUM_SERVER_IP/updates/
gpgcheck=0
enabled=1
EOF
echo -e "\n"
echo "Done..."
echo -e "\n"
yum repolist all

