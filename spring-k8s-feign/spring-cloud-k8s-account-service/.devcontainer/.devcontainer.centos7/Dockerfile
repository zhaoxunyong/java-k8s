# FROM java:8-jdk
FROM centos:7
RUN mkdir -p /Developer/java /workspaces
WORKDIR /workspaces
# RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone
ADD Centos-7.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum install -y wget sudo
# RUN groupadd dev && useradd -r -g dev dev
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
# [Optional] Add sudo support. Omit if you don't need to install software after connecting.
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

RUN chown -R $USERNAME.$USERNAME /Developer

# ADD tools/apache-maven-3.5.4.tar.gz /Developer/
# ADD tools/jdk-8u241-linux-x64.tar.gz /Developer/java/
# ADD tools/jdk-11.0.9_linux-x64_bin.tar.gz /Developer/java/
# ADD tools/kubectl /usr/local/bin/kubectl

RUN wget 'http://mirrors.cnnic.cn/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz' \
-O /Developer/apache-maven-3.5.4-bin.tar.gz
RUN cd /Developer/ && tar zxvf apache-maven-3.5.4-bin.tar.gz
ADD settings.xml /Developer/apache-maven-3.5.4/conf/

ADD script.sh /Developer/
RUN bash /Developer/script.sh $USERNAME

USER $USERNAME
