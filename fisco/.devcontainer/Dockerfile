# FROM java:8-jdk
FROM ubuntu:20.04
RUN mkdir -p /Developer/workspace
WORKDIR /Developer/workspace
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
# ADD tools/apache-maven-3.3.9.tar.gz /Developer/

# ADD tools/jdk-8u241-linux-x64.tar.gz /Developer/java/
# ADD tools/jdk-11.0.9_linux-x64_bin.tar.gz /Developer/java/
# ADD tools/kubectl /usr/local/bin/kubectl


ADD script.sh /Developer/
RUN bash /Developer/script.sh $USERNAME

USER $USERNAME
ADD fisco.sh /Developer/
RUN bash /Developer/fisco.sh
