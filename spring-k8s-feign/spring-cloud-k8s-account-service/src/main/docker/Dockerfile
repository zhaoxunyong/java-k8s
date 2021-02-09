# FROM java:8-jdk
FROM registry.cn-shenzhen.aliyuncs.com/zerofinance/container:7.9

WORKDIR /workspaces

ENV APPNAME=account-service
ENV VERSION=0.0.1-SNAPSHOT
ENV CONFIG=/config/

COPY target/${APPNAME}-${VERSION}.jar /workspaces/

ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar /workspaces/${APPNAME}-${VERSION}.jar --spring.config.location=${CONFIG} --spring.profiles.active=@spring.profile@"]
EXPOSE 8080

