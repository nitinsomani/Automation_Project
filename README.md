# Automation_Project

Automation Script

1. updated all the packages of ubuntu server.
2. install Apache2 webserver and check if apache is already installed and enabled. If not, install and enable.
3. Create the tar for apache2 logs AND move those logs to the S3 bucket.
4. create inventory.html file and upload all the logs for s3 bucket.
5. modify script to create a cron job if it is not created.
6. This cron job should be executed every day.