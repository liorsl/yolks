#!/bin/bash

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')
export INTERNAL_IP
echo "Internal ip is $INTERNAL_IP"

cd /home/container || exit 1

APACHE_PID_FILE=/home/container/apache2.pid
export APACHE_PID_FILE

APACHE_DOCUMENT_ROOT=/home/container/wwwdocs
export APACHE_DOCUMENT_ROOT

# Disable for now since it disabled console logging so there is no way to know when the server have started
#APACHE_LOG_DIR=/home/container/logs
#export APACHE_LOG_DIR

if [ -f "apache2.conf" ]; then
   echo "Found existing apache installation."
else
   	echo "Copying configuration files..."
   cp -a /etc/apache2/* .
   mkdir wwwdocs
   chmod +x wwwdocs
   rm envvars
fi

# Output php version
php -v

# Included with the image
# Script source: https://github.com/docker-library/php/blob/master/apache2-foreground
#apache2-foreground -c "DocumentRoot /var/www/html_debug/"

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
