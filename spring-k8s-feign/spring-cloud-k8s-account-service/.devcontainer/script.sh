#!/bin/bash

# yum install -y wget sudo
# RUN groupadd dev && useradd -r -g dev dev
# USERNAME=dev
# USER_UID=1000
# USER_GID=$USER_UID
# Create the user
# [Optional] Add sudo support. Omit if you don't need to install software after connecting.
# groupadd --gid $USER_GID $USERNAME \
#   && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
#   && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#   && chmod 0440 /etc/sudoers.d/$USERNAME
# chown -R $USERNAME.$USERNAME /Developer /config

#关闭内核安全(如果是vagrant方式，第一次完成后需要重启vagrant才能生效。)
sed -i 's;SELINUX=.*;SELINUX=disabled;' /etc/selinux/config
setenforce 0
getenforce

cat /etc/NetworkManager/NetworkManager.conf|grep "dns=none" > /dev/null
if [[ $? != 0 ]]; then
  echo "dns=none" >> /etc/NetworkManager/NetworkManager.conf
  systemctl restart NetworkManager.service
fi

# systemctl disable iptables
# systemctl stop iptables
# systemctl disable firewalld
# systemctl stop firewalld

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

# echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.local
# echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled"  >> /etc/rc.local
# chmod +x /etc/rc.local
# chmod +x /etc/rc.d/rc.local
# systemctl enable rc-local.service

# yum -y install gcc kernel-devel
mv -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
#wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

yum -y install epel-release

sudo mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
sudo mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup

cat > /etc/yum.repos.d/epel.repo  << EOF
[epel]
name=Extra Packages for Enterprise Linux 7 - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/\$basearch
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=\$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - \$basearch - Debug
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/\$basearch/debug
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-7&arch=\$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 7 - \$basearch - Source
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/SRPMS
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=\$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1
EOF

yum clean all
yum makecache

yum install -y htop git

# systemctl disable chronyd.service
# systemctl stop chronyd.service
# yum -y install ntp
# timedatectl set-timezone Asia/Shanghai
# systemctl enable ntpd
# systemctl start ntpd

#yum -y install createrepo rpm-sign rng-tools yum-utils 
# yum -y install bind-utils bridge-utils ntpdate setuptool iptables system-config-securitylevel-tui system-config-network-tui \
# ntsysv net-tools lrzsz bridge-utils \
# htop telnet lsof vim dos2unix unix2dos zip unzip \
# openssl openssh-server openssh-clients initscripts rpcbind psmisc
#systemctl enable sshd
#systemctl enable rpcbind

yum -y install bind-utils bridge-utils ntpdate setuptool iptables \
 system-config-securitylevel-tui system-config-network-tui \
 ntsysv net-tools lrzsz telnet lsof vim dos2unix unix2dos zip unzip

# mkdir -p /works/soft
# cd /works/soft
# cp -a /vagrant/soft /works/
# tar zxvf jdk-8u241-linux-x64.tar.gz 
# cat > /etc/profile.d/java.sh << EOF
cat >> /etc/profile << EOF
export JAVA_HOME=/Developer/java/jdk1.8.0_241
export M2_HOME=/Developer/apache-maven-3.3.9
export GRADLE_USER_HOME=/Developer/.gradle
export PATH=\$JAVA_HOME/bin:\$M2_HOME/bin:\$PATH
EOF

. /etc/profile
# /home/$USERNAME/.bashrc

#https://www.cnblogs.com/763977251-sg/p/11837130.html
#Docker installation
#https://aka.ms/vscode-remote/samples/docker-from-docker
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum makecache fast
sudo yum -y install docker-ce

touch /var/run/docker.sock
sudo gpasswd -a dev docker
chown dev.dev /var/run/docker.sock

