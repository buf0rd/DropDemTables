# DropDemTables

Script(S) created to take the last IP address from a Cowrie log file and compare it to a list of stored IP addresses. If IP is found then the script will just exit. If not, the IP address is added to the log and iptables is update to DROP traffic from that specific IP.

Usage. 

chmod +x ipdropV2.sh

./ipdropV2.sh
##########################

AutoAbuseCowrie.sh 
A script based of my IPdrop script to auto drop attacker IP traffic. In addition, a whois query is made, ABUSE email obtained and emailed with login attempts to abuse email listed. Temorary files saved to /tmp. 

!!Depends on;!!
+whois
+ssmtp -- setup and configured w gmail as follows>>>

////#cat/etc/ssmtp/ssmtp.conf///

hostname=###YOURHOSTNAME####

root=myemailaddress@gmail.com

mailhub=smtp.gmail.com:587

AuthUser=####GMAIL USER NAME######

AuthPass=#####PASSWORD FOR GMAIL######

UseSTARTTLS=YES
////////////////////////////////



To use;

chmod +x AutoAbuseCowrie.sh

Edit: myemail variable to your email to receive notifications
