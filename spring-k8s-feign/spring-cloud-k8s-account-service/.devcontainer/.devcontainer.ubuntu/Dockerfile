# FROM java:8-jdk
FROM ubuntu:20.04
RUN mkdir -p /Developer/java /workspaces
WORKDIR /workspaces
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone
# RUN groupadd dev && useradd -r -g dev dev

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# ARG DEBIAN_FRONTEND=noninteractive

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN chown -R $USERNAME.$USERNAME /Developer
# ADD tools/apache-maven-3.5.4.tar.gz /Developer/
ADD sources.list /etc/apt/sources.list
RUN apt update && apt install wget -y && wget 'http://mirrors.cnnic.cn/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz' \
-O /Developer/apache-maven-3.5.4-bin.tar.gz
RUN cd /Developer/ && tar zxvf apache-maven-3.5.4-bin.tar.gz
ADD settings.xml /Developer/apache-maven-3.5.4/conf/

# ADD tools/jdk-8u202-linux-x64.tar.gz /Developer/java/
# ADD tools/jdk-11.0.9_linux-x64_bin.tar.gz /Developer/java/
# ADD tools/kubectl /usr/local/bin/kubectl

ADD script.sh /Developer/
RUN bash /Developer/script.sh $USERNAME

USER $USERNAME

# RUN mkdir /home/$USERNAME/.kube/
# ADD config /home/$USERNAME/.kube/