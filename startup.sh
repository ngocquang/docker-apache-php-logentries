#!/bin/bash

echo "RUNNING..."

#####################################
### DOWNLOAD REMOTE CONFIGURATION
CONFIG_LOCAL_FILE="/var/www/private/config.yml"
CONFIG_LOCAL_FILE_PHP="/var/www/private/config.php"

# Download environment config if environment passed
if [ -z "$CONFIG_URL" ];
then
    echo "Get default config.yml from image"
else
    echo "Config URL detected. Download config file: ${CONFIG_URL}"

    # Download from curl
    response=$(curl -k --write-out %{http_code} --silent --output ${CONFIG_LOCAL_FILE} ${CONFIG_URL})

    if [ $response -eq 200 ];
    then
        echo "downloaded config file OK. Checking file content is valid..."

        # Check valid file contents (in this case, contains string 'host')
        if grep -Fq "token" ${CONFIG_LOCAL_FILE}
        then
            echo "VALID."

            if grep -Fq "$" ${CONFIG_LOCAL_FILE}
            then
	            echo "Prepend the <?php for this file content..."
	            sed -i -e '1i<?php \' ${CONFIG_LOCAL_FILE}
                mv ${CONFIG_LOCAL_FILE} ${CONFIG_LOCAL_FILE_PHP}
            fi

        else
            echo "INVALID file content (not found text 'token' in config file)."
            echo "Exit."
            exit 1
        fi
    else

        # Stop this container because can not download config file.
        #
        echo "File Not Found. HTTP Status Code: ${response}."
        echo "Exit."
        exit 1
    fi
fi


#############################################$
# Replace environment LOGENTRIES_TOKEN
envtpl /etc/syslog-ng/conf.d/logentries.conf.tpl
sed -i "s/log { source(s_src); filter(f_cron);/#log { source(s_src); filter(f_cron);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/log { source(s_src); filter(f_daemon);/#log { source(s_src); filter(f_daemon);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/log { source(s_src); filter(f_kern);/#log { source(s_src); filter(f_kern);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/log { source(s_src); filter(f_lpr);/#log { source(s_src); filter(f_lpr);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/log { source(s_src); filter(f_syslog3);/#log { source(s_src); filter(f_syslog3);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/log { source(s_src); filter(f_user);/#log { source(s_src); filter(f_user);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/log { source(s_src); filter(f_uucp);/#log { source(s_src); filter(f_uucp);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/log { source(s_src); filter(f_mail);/#log { source(s_src); filter(f_mail);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/log { source(s_src); filter(f_news);/#log { source(s_src); filter(f_news);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/log { source(s_src); filter(f_console);/#log { source(s_src); filter(f_console);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/log { source(s_src); filter(f_crit);/#log { source(s_src); filter(f_crit);/g" /etc/syslog-ng/syslog-ng.conf
sed -i "s/destination(d_xconsole); };/#destination(d_xconsole); };/g" /etc/syslog-ng/syslog-ng.conf


service syslog-ng restart

#envtpl /var/tasks.sh.tpl
#chmod +x /var/tasks.sh

/var/tasks.sh

## run supervisord
supervisord

# add locale VietNam
locale-gen vi_VN

#chown www-data:www-data /var/www/html -R

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND

# Call parent entrypoint (CMD)
#/sbin/my_init
