  GNU nano 2.4.2                                           File: ipdropV2.sh                                                                                              

#!/bin/bash

attackerip="$(cat /home/cowrie/cowrie/log/cowrie.log | grep -Eoa '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | tail -1)"

if grep -q $attackerip /var/www/html/files/attackerlist.txt; then

echo $attackerip already incorporated into firewall

else
/sbin/iptables -n -A INPUT -s "$attackerip" -j DROP


echo $attackerip >> /var/www/html/files/attackerlist.txt
echo $attackerip added to iptables firewall

fi

/sbin/iptables -n -L INPUT > /var/www/html/files/attackerlistTMP.txt

if grep -q $attackerip /var/www/html/files/attackerlistTMP.txt; then

echo $attackerip reverified

else
/sbin/iptables -n -A INPUT -s "$attackerip" -j DROP
echo Retrying
fi
### echo Scripted by @drian ###
exit 0




