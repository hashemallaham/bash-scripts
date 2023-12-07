#!/bin/bash

clear
echo -e "\n"


cat <<EOF
#
#         ####    ####     ##    #
#        #    #  #    #   #  #   #
#        #    #  #       #    #  #
#        #    #  #       ######  #
#        #    #  #    #  #    #  #
#######   ####    ####   #    #  ######

#     # #     # #     #
 #   #  #     # ##   ##
  # #   #     # # # # #
   #    #     # #  #  #
   #    #     # #     #
   #    #     # #     #
   #     #####  #     #

 #####
#     #  ######   #####  #    #  #####
#        #          #    #    #  #    #
 #####   #####      #    #    #  #    #
      #  #          #    #    #  #####
#     #  #          #    #    #  #
 #####   ######     #     ####   #
@Eng. Hashem Allaham
hashem.allaham@gmail.com



EOF

echo "installing and running nginx web server..."
yum update
yum install epel-release -y
yum update
yum install nginx -y
systemctl enable --now nginx

echo -e "\n"
echo "installing yum utilites..."
yum install createrepo yum-utils -y
echo "\n\n"

echo "Syncing data from Internet Repos locally..."
echo "This stage may takes a while, please wait..."
sleep 10s
mkdir -p /var/www/html/repos/{base,centosplus,extras,updates}
chmod -R u+rw,g+r,o+r /var/www/html/repos/{base,centosplus,extras,updates}
reposync -g -l -d -m --repoid=base --newest-only --download-metadata --download_path=/var/www/html/repos/
reposync -g -l -d -m --repoid=centosplus --newest-only --download-metadata --download_path=/var/www/html/repos/
reposync -g -l -d -m --repoid=extras --newest-only --download-metadata --download_path=/var/www/html/repos/
reposync -g -l -d -m --repoid=updates --newest-only --download-metadata --download_path=/var/www/html/repos/
# create repodata for the local repositories
createrepo -g comps.xml /var/www/html/repos/base/
createrepo -g comps.xml /var/www/html/repos/centosplus
createrepo -g comps.xml /var/www/html/repos/extras/
createrepo -g comps.xml /var/www/html/repos/updates/


echo -e "\n\n"



echo "configuring a VirtualHost on nginx for local repos..."
read -p "enter the hostname of the nginx VirtualHost which will provides the repos: " LOCAL_YUM_SERVER_IP
cat >> /etc/nginx/conf.d/repos.conf <<EOF
server {
        listen   80;
        server_name  $LOCAL_YUM_SERVER_IP; 
        root   /var/www/html/repos;
        location / {
                index  index.php index.html index.htm;
                autoindex on; #enable directory indexing
        }
}
EOF
nginx -t && nginx -s reload

echo -e "\n\n"


echo "create a cronjob to update the repos from Internet daily..."
cat >> /etc/cron.daily/update-localrepos <<EOF
#!/bin/bash

LOCAL_REPOS=”base centosplus extras updates”

for REPO in ${LOCAL_REPOS}; do
reposync -g -l -d -m --repoid=$REPO --newest-only --download-metadata --download_path=/var/www/html/repos/
createrepo -g comps.xml /var/www/html/repos/$REPO/  
done
EOF

chmod 755 /etc/cron.daily/update-localrepos

echo -e "\n"
echo "Done...."





