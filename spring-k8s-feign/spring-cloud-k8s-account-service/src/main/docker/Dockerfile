# FROM java:8-jdk
FROM registry.cn-shenzhen.aliyuncs.com/zerofinance/container:7
WORKDIR /app
ENV APPNAME=account-service \
    VERSION=0.0.1-SNAPSHOT \
    CONFIG=/config/
COPY target/${APPNAME}-${VERSION}.jar /app/
ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar /app/${APPNAME}-${VERSION}.jar --spring.config.location=${CONFIG} --spring.profiles.active=@spring.profile@"]
EXPOSE 8080

