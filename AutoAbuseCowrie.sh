#!/bin/bash

attackerip="$(cat /home/cowrie/cowrie/log/cowrie.log | grep -Eoa '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | tail -1)"
form=/tmp/ssmtp_mailTEMP.txt
myemail=oddsecdotnet@gmail.com
subject="IP Dropped"
abuse="$(whois $attackerip | grep abuse | tail -1 | egrep -o "\b[[:alnum:]_-]+@[[:alnum:]_-]{2,}\.[[:alnum:]]{2,}\b")"
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

#The email magic

echo "To: $myemail" > $form
echo "From: $myemail" >> $form
echo "Subject: Attack mitigated |drop| ABUSE REPORT from your domain $attackerip" >> $form
echo "$attackerip" >> $form
whois $attackerip >> $form
cat /home/cowrie/cowrie/log/cowrie.log | grep $attackerip >> $form

cat $form | ssmtp $myemail, $abuse
echo $abuse

# Cleanup email template above.
rm $form

### echo Scripted by @drian ###
exit 0
