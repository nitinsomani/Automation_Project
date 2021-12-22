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

if [ -e /var/www/html/inventory.html ]
then
        echo "Inventory file already exists"
else
        touch /var/www/html/inventory.html
        echo "<b>Log Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Date Created &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size</b>" >> /var/www/html/inventory.html
fi

echo "<br>httpd-logs &nbsp;&nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp;&nbsp; `du -h /tmp/${myname}-httpd-logs-${timestamp}.tar | awk '{print $1}'`" >> /var/www/html/inventory.html

if [ -e /etc/cron.d/automation ]
then
        echo "Cron job already exists"
else
        touch /etc/cron.d/automation
        echo "0 0 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
        echo "Cron job added"
fi