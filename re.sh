#!/bin/bash
CONFIG="$1"
COMMAND="$2"
CONFIG2="/etc/apache2/sites-available/"

if [ $# -ne 2 ]
then
    echo -e "ERROR: $0 requires two parameters \nA virtual-host configuration \nA service command"
    exit 1
fi

VHOSTS_PATH=/etc/apache2/sites-available/*.conf

for FILENAME in $VHOSTS_PATH
do 
    if [ "$CONFIG2$CONFIG" == "$FILENAME" ] || [ "$CONFIG2$CONFIG.conf" == "$FILENAME" ]
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
            echo -e "ERROR: $COMMAND is an invalid service command. \nValid service commands: \nrestart \nreload"
            exit 1
        fi
    fi
done

echo -e "ERROR: Invalid virtual-host name. \nValid host names:"
for FILENAME1 in $VHOSTS_PATH
do
    echo "${FILENAME1:29:-5}"
done
