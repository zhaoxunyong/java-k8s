FROM java:8-jdk
RUN mkdir /Developer /config
WORKDIR /Developer
ENV APPNAME=employee \
    VERSION=3.0.0-SNAPSHOT \
    CONFIG=/config/
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone

# ADD sources.list /etc/apt/sources.list

# ARG USERNAME=dev
# ARG USER_UID=1000
# ARG USER_GID=$USER_UID

# # Create the user
#     # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
# RUN groupadd --gid $USER_GID $USERNAME \
#     && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
#     && apt-get update \
#     && apt-get install -y sudo \
#     && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#     && chmod 0440 /etc/sudoers.d/$USERNAME

RUN mkdir -p /Developer/java /workspaces
RUN chown -R $USERNAME.$USERNAME /Developer

ADD tools/apache-maven-3.5.4.tar.gz /Developer/
ADD tools/jdk-8u241-linux-x64.tar.gz /Developer/java/
ADD tools/jdk-11.0.9_linux-x64_bin.tar.gz /Developer/java/
COPY tools/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

ADD script.sh /Developer/
RUN bash /Developer/script.sh