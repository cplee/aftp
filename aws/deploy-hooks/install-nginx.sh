#!/bin/sh

yum install -y nginx

sed -i 's|/usr/share/nginx/html;|/opt/aftp/app;|' /etc/nginx/nginx.conf

service nginx restart
