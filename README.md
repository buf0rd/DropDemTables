# DropDemTables

Script(S) created to be used as cronjob to take the last IP address from a Cowrie log file and compare it to a list of stored IP addresses. If IP is found then the script will just exit. If not, the IP address is added to the log and iptables is update to DROP traffic from that specific IP.

Usage. 

chmod +x ipdropV2.sh
./ipdropV2.sh
