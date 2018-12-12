#!/bin/bash
CONFIG="$1"
COMMAND="$2"
CONFIG2="/etc/apache2/sites-available/"

if [ $# -ne 2 ]
then
    echo "ERROR: $0 requires two parameters {virtual-host} {restart|reload}"
    exit 1
fi

VHOSTS_PATH=/etc/apache2/sites-available/*.conf

for FILENAME in $VHOSTS_PATH
do 
    if [ "$CONFIG2$CONFIG" == "$FILENAME" ]
    then 
        # only allow reload or restart
        if [ "$COMMAND" == "reload" ] || [ "$COMMAND" == "restart" ]
        then
            # Move the current execution state to the proper directory
            cd /etc/apache2/sites-available

            # Disable a vhost configuration
            sudo a2dissite "$CONFIG"
            sudo service apache2 "$COMMAND"

            # Enable a vhost configuration
            sudo a2ensite "$CONFIG"
            sudo service apache2 "$COMMAND"
            exit 1

        else
            echo "ERROR: $COMMAND is an invalid service command {restart|reload}"
            exit 1
        fi
    fi
done

echo "ERROR: Invalid virtual-host name. Valid host names:"
for FILENAME1 in $VHOSTS_PATH
do
    echo "${FILENAME1:29}"
done
