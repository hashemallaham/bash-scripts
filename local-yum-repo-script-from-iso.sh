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



# mount the iso file
sudo mount -o loop rhel-8.0-x86_64-dvd.iso /mnt
if [ $? -ne 0 ]
then
    echo "Error: please modify the script to match the iso file name and make sure that it is existed in the current directory."
    exit 1
else
    echo "mounted at /mnt"
fi


# clean up the old repo config file on the server
rm -f /etc/yum.repos.d/*.repo

# creating the local dir where we will store the repo in
mkdir /local_repo
chmod -R /local_repo


# copy the repo data to the to the local dir
cd /mnt
tar cvf - . | (cd /local_repo/; tar xvf -)





# optional, create a repo config file to enable the yum local repo on the server itself also
touch /etc/yum.repos.d/local-dvdrom.repo
chmod  u+rw,g+r,o+r  /etc/yum.repos.d/local-dvdrom.repo
cat >>/etc/yum.repos.d/local-dvdrom.repo <<EOF
[LocalRepo_BaseOS]
name=LocalRepo_BaseOS
metadata_expire=-1
enabled=1
gpgcheck=1
baseurl=file:///local_repo/BaseOS/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[LocalRepo_AppStream]
name=LocalRepo_AppStream
metadata_expire=-1
enabled=1
gpgcheck=1
baseurl=file:///local_repo/AppStream/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF



# install yum utilites
yum install createrepo  yum-utils -y

# create the local repo where the copied data stored, then check that the repo created successfully
createrepo /local_repo/
chmod -R /local_repo
yum clean all && yum repolist


# install and enable nginx
yum install nginx -y
systemctl enable --now nginx


# create the nginx config file
cat >/etc/nginx/nginx.conf <<EOF
user  root;
worker_processes  auto;
error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    server {
	    listen       80 default_server;
        server_name  _;
        root         /local_repo/;

        location / {
                allow all;
                sendfile on;
                sendfile_max_chunk 1m;
                autoindex on;
                autoindex_exact_size off;
                autoindex_format html;
                autoindex_localtime on;
        }
	  error_page 404 /404.html;
            location = /40x.html {
        }

	  error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
    include /etc/nginx/conf.d/*.conf;
}
EOF



# reload the nginx
nginx -t && nginx -s reload


echo "Done..."
