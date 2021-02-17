#!/bin/bash

SLEEP_TIME=0.25

export NAGIOS_HOSTNAME="TEST HOSTNAME"
export NAGIOS_HOSTADDRESS="192.168.0.1"
export NAGIOS_HOSTSTATE="UP"
export NAGIOS_HOSTOUTPUT="PING OK - Paquets perdus = 0%, RTA = 0.67 ms"
export NAGIOS_NOTIFICATIONTYPE="RECOVERY"
export NAGIOS_SERVICESTATE="OK"
export NAGIOS_SERVICEDESC="[DISK] /"
export NAGIOS_SERVICEOUTPUT="DISK OK - free space: / 168534 MB (41.16% inode=100%)"
export NAGIOS_SHORTDATETIME="15-02-2021 14:49:44"
export NAGIOS_TOTALHOSTSUP="23"
export NAGIOS_TOTALHOSTSDOWN="2"
export NAGIOS_TOTALSERVICESOK="486"
export NAGIOS_TOTALSERVICEPROBLEMS="38"

sed -e 's/@PLUGINS_PATH@/./g' send-discord-host.sh > send-discord-host-tmp.sh
sed -e 's/@PLUGINS_PATH@/./g' send-discord-service.sh > send-discord-service-tmp.sh
chmod +x send-discord-host-tmp.sh send-discord-service-tmp.sh
./send-discord-host-tmp.sh
./send-discord-service-tmp.sh
sleep ${SLEEP_TIME}

export NAGIOS_NOTIFICATIONTYPE="PROBLEM"
export NAGIOS_SERVICESTATE="WARNING"
export NAGIOS_SERVICEDESC="[DISK] /"
export NAGIOS_SERVICEOUTPUT="DISK WARNING - free space: / 1684 MB (81.51% inode=100%)"
./send-discord-service-tmp.sh
sleep ${SLEEP_TIME}

export NAGIOS_SERVICESTATE="UNKNOWN"
export NAGIOS_SERVICEOUTPUT="CHECK_DIR_SIZE UNKNOWN - plugin timed out /timeout 30s/"
./send-discord-service-tmp.sh
sleep ${SLEEP_TIME}

export NAGIOS_HOSTSTATE="DOWN"
export NAGIOS_HOSTOUTPUT="(Host check timed out after 30.01 seconds)"
export NAGIOS_SERVICESTATE="CRITICAL"
export NAGIOS_SERVICEOUTPUT="DISK CRITICAL - free space: / 168 MB (96.87% inode=100%)"
./send-discord-host-tmp.sh
./send-discord-service-tmp.sh

rm -f send-discord-host-tmp.sh send-discord-service-tmp.sh
