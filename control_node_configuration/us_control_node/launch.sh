#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>The value of MY_VARIABLE is: WOOOO <h1>" > /var/www/html/index.html
