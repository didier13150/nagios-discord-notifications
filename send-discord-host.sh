#!/bin/bash

##############################################################################
# All vars in this section can be overriden in discord-conf.sh file
# NAGIOS_DOMAIN is used to generate URLs,
# NAGIOS_NAME is usefull to distinguish several nagios server instances.
#NAGIOS_DOMAIN="https://nagios.example.com"
#NAGIOS_NAME="Nagios LAN"
NAGIOS_DOMAIN=
NAGIOS_NAME=

# Webhook URL, change this to your webhook URL
#WEBHOOK_URL="https://discordapp.com/api/webhooks/id/token"
WEBHOOK_URL=

# Where to log (nowhere by default)
LOG_FILE="/dev/null"
##############################################################################

if [ -f "@PLUGINS_PATH@/discord-conf.sh" ]
then
    source @PLUGINS_PATH@/discord-conf.sh
else
    echo "Cannot source conf file: @PLUGINS_PATH@/discord-conf.sh"
    exit 1
fi

status="unknown"

# Define colors
declare -A COLOR
COLOR[critical]="13632027"
COLOR[warning]="16098851"
COLOR[ok]="8311585"
COLOR[unknown]="16760087"

declare -A ICON
ICON[ok]="https://icons.iconarchive.com/icons/tatice/cristal-intense/128/ok-icon.png"
ICON[warning]="https://icons.iconarchive.com/icons/oxygen-icons.org/oxygen/128/Status-dialog-warning-icon.png"
ICON[critical]="https://icons.iconarchive.com/icons/oxygen-icons.org/oxygen/128/Actions-window-close-icon.png"
ICON[unknown]="https://icons.iconarchive.com/icons/tatice/cristal-intense/128/FAQ-icon.png"

if [ "${NAGIOS_NOTIFICATIONTYPE}" == "PROBLEM" ]
then
  status="critical"
elif [ "${NAGIOS_NOTIFICATIONTYPE}" == "RECOVERY" ]
then
  status="ok"
fi

# totals
hosts_total=$(( $NAGIOS_TOTALHOSTSUP + $NAGIOS_TOTALHOSTSDOWN ))
services_total=$(( $NAGIOS_TOTALSERVICESOK + $NAGIOS_TOTALSERVICEPROBLEMS ))

json_data="{\"content\":\"${NAGIOS_HOSTNAME} ${NAGIOS_HOSTSTATE}\",
    \"username\":\"${NAGIOS_NAME}\",
    \"avatar_url\":\"https://a.fsdn.com/allura/p/nagios/icon?1579016798?&w=90\",
    \"tts\":false,
    \"embeds\":[{
            \"title\":\"${NAGIOS_HOSTNAME} is ${NAGIOS_HOSTSTATE} (${NAGIOS_NOTIFICATIONTYPE})\",
            \"type\":\"rich\",
            \"description\":\"\",
            \"url\":\"${NAGIOS_DOMAIN}/cgi-bin/extinfo.cgi?type=1&host=$(echo "${NAGIOS_HOSTNAME}" | sed s/\ /\+/g)\",
            \"timestamp\":\"$(date -u '+%Y-%m-%dT%H:%M:%S')\",
            \"color\":${COLOR[${status}]},
            \"footer\":{
                \"text\":\"${NAGIOS_TOTALHOSTSUP}/${hosts_total} hosts up, ${NAGIOS_TOTALSERVICESOK}/${services_total} services ok\",
                \"icon_url\": \"https://a.fsdn.com/allura/p/nagios/icon?1579016798?&w=90\"
            },
            \"thumbnail\":{
                \"url\":\"${ICON[${status}]}\"
            },
            \"fields\":[
                {\"name\":\"Hostname\",\"value\":\"${NAGIOS_HOSTNAME} (${NAGIOS_HOSTADDRESS})\",\"inline\":false},
                {\"name\":\"Host State\",\"value\":\"${NAGIOS_HOSTSTATE}\",\"inline\":false},
                {\"name\":\"Host Data\",\"value\":\"${NAGIOS_HOSTOUTPUT}\",\"inline\":false},
                {\"name\":\"Notification Type\",\"value\":\"${NAGIOS_NOTIFICATIONTYPE}\",\"inline\":false},
                {\"name\":\"Event Time\",\"value\":\"${NAGIOS_SHORTDATETIME}\",\"inline\":false}
            ]
        }]
}"

curl -v -H "Content-Type:application/json" -X POST --data "${json_data}" "${WEBHOOK_URL}" 1>>${LOG_FILE} 2>&1
exit $?
