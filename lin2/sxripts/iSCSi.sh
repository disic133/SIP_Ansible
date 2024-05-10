
#!/bin/bash
firewall-cmd --reload

targetcli <<EOF
cd /iscsi
create iqn.2024-03.com.disic:sip
cd iqn.2024-03.com.disic:sip/tpg1
cd /
exit
EOF

targetcli <<EOF
cd /backstores/block
create block1 /dev/sdc
cd /iscsi/iqn.2024-03.com.disic:sip/tpg1/luns
create /backstores/block/block1
exit
EOF

targetcli <<EOF
cd /iscsi/iqn.2024-03.com.disic:sip/tpg1/acls
create iqn.2024-03.com.disic:sipinit
exit
EOF

targetcli <<EOF
cd /iscsi/iqn.2024-03.com.disic:sip/tpg1/portals
delete ip_address=0.0.0.0 ip_port=3260
create 192.168.2.10
exit
EOF

systemctl restart target.service
