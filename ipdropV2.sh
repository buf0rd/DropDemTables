#!/bin/bash

attackerip="$(cat /home/cowrie/cowrie/log/cowrie.log | grep -Eoa '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | tail -1)"

if grep -q $attackerip "/var/www/html/files/attackerlist.txt"; then

echo $attackerip already incorporated into firewall

else
iptables -A INPUT -s "$attackerip" -j DROP

iptables -L INPUT > /var/www/html/files/attackerlist.txt
#echo $attackerip >> /var/www/html/files/attackerlist.txt
echo $attackerip added to iptables firewall

fi

### echo Scripted by @drian ###
exit 0

