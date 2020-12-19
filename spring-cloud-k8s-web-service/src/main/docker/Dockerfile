FROM java:8-jdk
RUN mkdir /app
WORKDIR /app
ENV APPNAME=web-service \
    VERSION=0.0.1-SNAPSHOT \
    CONFIG=/config/
RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone
COPY target/${APPNAME}-${VERSION}.jar /app/
ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar /app/${APPNAME}-${VERSION}.jar --spring.config.location=${CONFIG} --spring.profiles.active=@spring.profile@"]
EXPOSE 8080