FROM openjdk:8-jdk-alpine
RUN apk update &&  apk --no-cache add curl   # for debug
VOLUME /tmp
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
