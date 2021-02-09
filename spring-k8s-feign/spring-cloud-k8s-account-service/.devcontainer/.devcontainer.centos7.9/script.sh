#!/bin/bash

USERNAME=$1

#关闭内核安全(如果是vagrant方式，第一次完成后需要重启vagrant才能生效。)
sed -i 's;SELINUX=.*;SELINUX=disabled;' /etc/selinux/config
setenforce 0
getenforce

cat /etc/NetworkManager/NetworkManager.conf|grep "dns=none" > /dev/null
if [[ $? != 0 ]]; then
  echo "dns=none" >> /etc/NetworkManager/NetworkManager.conf
  systemctl restart NetworkManager.service
fi

ln -sf /usr/share/zoneinfo/Asia/Chongqing /etc/localtime

#logined limit
cat /etc/security/limits.conf|grep 100000 > /dev/null
if [[ $? != 0 ]]; then
cat >> /etc/security/limits.conf  << EOF
*               soft    nofile             100000
*               hard    nofile             100000
*               soft    nproc              100000
*               hard    nproc              100000
EOF
fi

sed -i 's;4096;100000;g' /etc/security/limits.d/20-nproc.conf

#systemd service limit
cat /etc/systemd/system.conf|egrep '^DefaultLimitCORE' > /dev/null
if [[ $? != 0 ]]; then
cat >> /etc/systemd/system.conf << EOF
DefaultLimitCORE=infinity
DefaultLimitNOFILE=100000
DefaultLimitNPROC=100000
EOF
fi

#echo "vm.swappiness = 10" >> /etc/sysctl.conf
cat /etc/sysctl.conf|grep "net.ipv4.ip_local_port_range" > /dev/null
if [[ $? != 0 ]]; then
cat >> /etc/sysctl.conf  << EOF
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.ip_forward = 1
EOF
sysctl -p
fi

su - root -c "ulimit -a"

# yum install -y htop

# yum -y install bind-utils bridge-utils ntpdate setuptool iptables \
#  system-config-securitylevel-tui system-config-network-tui \
#  ntsysv net-tools lrzsz telnet lsof vim dos2unix unix2dos zip unzip

#https://openjdk.java.net/install/
yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel
cat >> /etc/profile.d/java.sh << EOF
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.275.b01-0.el7_9.x86_64
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
