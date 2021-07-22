#!/bin/bash
cd /home/container

# Output php version
php -v

# Included with the image
# Script source: https://github.com/docker-library/php/blob/master/apache2-foreground
#apache2-foreground -c "DocumentRoot /var/www/html_debug/"

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}

