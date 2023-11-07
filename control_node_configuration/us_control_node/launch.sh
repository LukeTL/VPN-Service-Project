#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "The value of MY_VARIABLE is: $MY_VARIABLE" > /var/www/html/index.html