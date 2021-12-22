#!/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
myname="nitin"
s3_bucket="upgrad-nitin1"

sudo apt update -y
sudo apt install apache2 -y

if [ `service apache2 status | grep running | wc -l` == 1 ]
then
	echo "Apache2 webserver is already running"
else
	echo "Apache2 webserver is not running"
	echo "Now Starting the apache2 webserver"
	sudo service apache2 start 

fi

if [ `service apache2 status | grep enabled | wc -l` == 1 ]
then
	echo "Apache2 webserver is already enabled"
else
	echo "Apache2 webserver is not enabled"
	echo "Now Enabling the apache2 webserver"
	sudo systemctl enable apache2
fi

cd /var/log/apache2/

tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar *.log

echo "now copying all the logs to aws s3 bucket"

aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar