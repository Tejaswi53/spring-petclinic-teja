FROM ubuntu:latest
RUN apt-get update && apt install openjdk-17-jdk -y
RUN mkdir -p /opt/pet-clinic
WORKDIR /opt/pet-clinic
ARG source_jar
COPY ${source_jar} /opt/pet-clinic
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "spring-petclinic-42-main.jar"]
      
