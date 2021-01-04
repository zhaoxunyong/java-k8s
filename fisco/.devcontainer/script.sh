#!/bin/bash

# Ensure apt is in non-interactive to avoid prompts

USERNAME=$1

echo "nameserver 8.8.8.8" >> /etc/resolv.conf

cat > /etc/apt/sources.list <<EOF
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
EOF

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt install sudo
apt install git net-tools curl wget vim screen curl -y

echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

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

# cat >> /etc/profile.d/java.sh << EOF
# export JAVA_HOME=/Developer/java/jdk1.8.0_241
# export M2_HOME=/Developer/apache-maven-3.3.9
# export GRADLE_USER_HOME=/Developer/.gradle
# export PATH=\$JAVA_HOME/bin:\$M2_HOME/bin:\$PATH
# EOF

# . /etc/profile

# git config --global user.name "$USERNAME"
# git config --global user.email $USERNAME@zerofinance.com
# git config --global core.autocrlf false
# git config --global core.safecrlf warn
# git config --global core.filemode false
# git config --global core.whitespace cr-at-eol
# git config --global credential.helper store

# sudo apt-get install -y bash-completion

cat >> /home/$USERNAME/.bashrc <<EOF
alias ll='ls -l'
export LANG=zh_CN.UTF-8

function proxy_off(){
    unset http_proxy
    unset https_proxy
    echo -e "The proxy has been closed!"
}
function proxy_on() {
    export no_proxy="127.0.0.1,localhost,10.0.0.0/8,172.0.0.0/8,192.168.0.0/16,*.zerofinance.net,*.aliyun.com,*.163.com,*.docker-cn.com,registry.gcalls.cn"
    export http_proxy="http://192.168.101.175:1082"
    export https_proxy=$http_proxy
    echo -e "The proxy has been opened!"
}
EOF

source /home/$USERNAME/.bashrc

