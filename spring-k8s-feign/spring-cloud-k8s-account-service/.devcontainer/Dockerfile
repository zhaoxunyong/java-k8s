# FROM java:8-jdk
FROM centos:7
RUN mkdir -p /Developer/java /Developer/workspace
WORKDIR /Developer/workspace
# RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone
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
ADD tools/apache-maven-3.3.9.tar.gz /Developer/

ADD tools/jdk-8u241-linux-x64.tar.gz /Developer/java/
ADD tools/jdk-11.0.9_linux-x64_bin.tar.gz /Developer/java/
ADD tools/kubectl /usr/local/bin/kubectl

ADD script.sh /Developer/
RUN bash /Developer/script.sh
