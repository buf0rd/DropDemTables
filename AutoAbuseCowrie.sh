#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

attackerip="$(cat /home/cowrie/cowrie/log/cowrie.log | grep -Eoa '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | tail -1)"
form=/tmp/ssmtp_mailTEMP.txt
myemail=YOUREMAIL@gmail.com ###change me to your own email. otherwise you are defeating purpose of script
subject="IP Dropped"
abuse="$(whois $attackerip | grep abuse | tail -1 | egrep -o "\b[[:alnum:]_-]+@[[:alnum:]_-]{2,}\.[[:alnum:]]{2,}\b")"

/sbin/iptables -L INPUT > /tmp/attackerlistTMP.txt

iptablesverify=/tmp/attackerlistTMP.txt

if grep -q $attackerip /tmp/attackerlist.txt; then

echo $attackerip already incorporated into firewall

exit 0

else
/sbin/iptables -A INPUT -s "$attackerip" -j DROP


echo $attackerip >> /tmp/attackerlist.txt
echo $attackerip added to iptables firewall

fi


if grep -q $attackerip $iptablesverify; then

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
rm $iptablesverify

### echo Scripted by @drian ###
exit 0


