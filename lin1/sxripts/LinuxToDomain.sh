#!/bin/bash

#Define variables
DOMAIN="disic.local"
USERNAME="Administrator"
PASSWORD='Pa$$w0rd1'
NAMESERVER='192.168.1.1'

#Add lines to /etc/resolv.conf
echo "search $DOMAIN" | tee -a /etc/resolv.conf
echo "nameserver $NAMESERVER" | tee -a /etc/resolv.conf
# Add lines to /etc/hosts
echo "$NAMESERVER $DOMAIN" | tee -a /etc/hosts
#Join the domain
echo $PASSWORD | realm join --user=$USERNAME $DOMAIN

#Configure SSSD
sed -i 's/use_fully_qualified_names = True/use_fully_qualified_names = False/g' /etc/sssd/sssd.conf
sed -i 's/fallback_homedir = \/home\/%u@%d/fallback_homedir = \/home\/%u/g' /etc/sssd/sssd.conf
systemctl restart sssd

#Configure PAM
authselect select sssd --force

#Configure sudoers
echo "%$DOMAIN\\domain^admins ALL=(ALL) ALL" >> /etc/sudoers.d/domain-admins
