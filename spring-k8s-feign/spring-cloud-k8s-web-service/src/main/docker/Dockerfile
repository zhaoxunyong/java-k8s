# FROM java:8-jdk
# RUN mkdir /app
# WORKDIR /app
# ENV APPNAME=web-service \
#     VERSION=0.0.1-SNAPSHOT \
#     CONFIG=/config/
# RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone
# COPY target/${APPNAME}-${VERSION}.jar /app/
# ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar /app/${APPNAME}-${VERSION}.jar --spring.config.location=${CONFIG} --spring.profiles.active=@spring.profile@"]
# EXPOSE 8080

# FROM zerofinance/devcontainer:20.04
# FROM registry.cn-shenzhen.aliyuncs.com/zerofinance/container:20.04
# FROM zerofinance/devcontainer:7
FROM registry.cn-shenzhen.aliyuncs.com/zerofinance/container:7

# RUN sudo mkdir -p /works/log/ && sudo chown -R dev.dev /works/log/
# RUN sudo mkdir -p /app/ && sudo chown -R dev.dev /app/
WORKDIR /app/

ENV APPNAME=web-service
ENV VERSION=0.0.1-SNAPSHOT
ENV CONFIG=/config/
COPY target/${APPNAME}-${VERSION}.jar /app/
ENTRYPOINT ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar /app/${APPNAME}-${VERSION}.jar --spring.config.location=${CONFIG} --spring.profiles.active=@spring.profile@"]
EXPOSE 8080
