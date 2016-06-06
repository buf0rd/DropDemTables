#!/bin/bash

attackerip="$(cat /home/cowrie/cowrie/log/cowrie.log | grep -Eoa '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | tail -1)"
name=/tmp/ssmtp_mailTEMP.txt
myemail=oddsecdotnet@gmail.com
subject="IP Dropped"
abuse="$(whois 116.31.116.16 | grep abuse | tail -1 | egrep -o "\b[[:alnum:]_-]+@[[:alnum:]_-]{2,}\.[[:alnum:]]{2,}\b")"
if grep -q $attackerip /tmp/attackerlist.txt; then

echo $attackerip already incorporated into firewall

else
/sbin/iptables -A INPUT -s "$attackerip" -j DROP


echo $attackerip >> /tmp/attackerlist.txt
echo $attackerip added to iptables firewall

fi

/sbin/iptables -L INPUT > /tmp/attackerlistTMP.txt

if grep -q $attackerip /tmp/attackerlistTMP.txt; then

echo $attackerip reverified

else
/sbin/iptables -A INPUT -s "$attackerip" -j DROP
echo Retrying
fi

#######mail it all from  https://gist.github.com/SBejga/ab009201a16370289250 #############

echo "To: $myemail" > $name
echo "From: $myemail" >> $name
echo "Subject: Attack mitigated | IP dropped | ABUSE REPORT!!!" >> $name
echo "$attackerip" >> $name
whois $attackerip >> $name
cat /home/cowrie/cowrie/log/cowrie.log | grep $attackerip >> $name

# exec ssmtp command with tmp txt file we have created
cat $name | ssmtp oddsecdotnet@gmail.com, $abuse
echo $abuse

# remove tmp file again
rm $name

### echo Scripted by @drian ###
exit 0
