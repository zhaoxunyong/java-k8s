# FROM java:8-jdk
FROM centos:7

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

RUN chown -R $USERNAME.$USERNAME /workspaces

ADD script.sh /workspaces/
RUN bash /workspaces/script.sh $USERNAME

USER $USERNAME
