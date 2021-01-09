#!/bin/bash

# Ensure apt is in non-interactive to avoid prompts

USERNAME=$1

# cat > /etc/apt/sources.list <<EOF
# deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
# deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
# deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
# deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
# deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
# deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
# EOF

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

apt-get install openjdk-8-jdk -y
#Retry...
if [[ $? != 0 ]]; then
    # sudo apt install -y default-jdk
    apt-get install openjdk-8-jdk -y
fi
apt-get install openjdk-11-jdk -y
#Retry...
if [[ $? != 0 ]]; then
    apt-get install openjdk-11-jdk -y
fi
# sudo update-alternatives --config java
# sudo update-alternatives --config javac
cat >> /etc/profile.d/java.sh << EOF
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export M2_HOME=/Developer/apache-maven-3.3.9
export GRADLE_USER_HOME=/Developer/.gradle
export PATH=\$JAVA_HOME/bin:\$M2_HOME/bin:\$PATH
EOF

. /etc/profile
# /home/$USERNAME/.bashrc

git config --global user.name "dave.zhao"
git config --global user.email dave.zhao@zerofinance.com
git config --global core.autocrlf false
git config --global core.safecrlf warn
git config --global core.filemode false
git config --global core.whitespace cr-at-eol
git config --global credential.helper store

sudo apt-get install -y bash-completion

cat >> /home/$USERNAME/.bashrc <<EOF
alias ll='ls -l'
export LANG=zh_CN.UTF-8
alias k=kubectl
source <(kubectl completion bash | sed s/kubectl/k/g)
source /usr/share/bash-completion/bash_completion
alias docker="docker -H=registry.gcalls.cn:2375"

function proxy_off(){
    unset http_proxy
    unset https_proxy
    echo -e "The proxy has been closed!"
}
function proxy_on() {
    export no_proxy="127.0.0.1,localhost,10.0.0.0/8,172.0.0.0/8,192.168.0.0/16,*.zerofinance.net,*.aliyun.com,*.163.com,*.docker-cn.com,registry.gcalls.cn"
    export http_proxy="http://192.168.3.38:1082"
    export https_proxy=$http_proxy
    echo -e "The proxy has been opened!"
}
EOF

# source /home/$USERNAME/.bashrc

#https://www.cnblogs.com/763977251-sg/p/11837130.html
#Docker installation
#https://aka.ms/vscode-remote/samples/docker-from-docker
apt-get -y install apt-transport-https ca-certificates software-properties-common
# step 2: 安装GPG证书
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
# Step 3: 写入软件源信息
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# Step 4: 更新并安装 Docker-CE
apt-get -y update
apt install python3 -y
apt-get -y install docker-ce

sudo touch /var/run/docker.sock
sudo gpasswd -a $USERNAME docker
sudo chown $USERNAME.$USERNAME /var/run/docker.sock

#telepresence
curl -s https://packagecloud.io/install/repositories/datawireio/telepresence/script.deb.sh | bash
apt install --no-install-recommends telepresence -y

#kubectl
#https://blog.csdn.net/nklinsirui/article/details/80581286
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
echo "deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" >> /etc/apt/sources.list
apt-get update
apt-get install -y kubectl