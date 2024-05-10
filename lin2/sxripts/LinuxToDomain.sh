#!/bin/bash

#vars
DOMAIN="disic.local"
NAMESERVER='192.168.2.1'
USERNAME="Administrator"
PASSWORD='Pa$$w0rd1'

#Install packages
#dnf install -y realmd sssd oddjob oddjob-mkhomedir samba-common-tools adcli

#Modify /etc/resolv.conf
echo "search $DOMAIN" | tee -a /etc/resolv.conf
echo "nameserver $NAMESERVER" | tee -a /etc/resolv.conf
#Modify /etc/hosts
echo "$NAMESERVER $DOMAIN" | tee -a /etc/hosts
#Add to Domain
echo $PASSWORD | realm join --user=$USERNAME $DOMAIN
#Configure SSSD
sed -i 's/use_fully_qualified_names = True/use_fully_qualified_names = False/g' /etc/sssd/sssd.conf
sed -i 's/fallback_homedir = \/home\/%u@%d/fallback_homedir = \/home\/%u/g' /etc/sssd/sssd.conf
systemctl restart sssd
#Configure PAM
authselect select sssd --force
#Define sudoers
echo "%$DOMAIN\\domain^admins ALL=(ALL) ALL" >> /etc/sudoers.d/domain-admins
