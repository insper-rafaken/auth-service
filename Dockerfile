FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app

COPY api/account/account/pom.xml ./api/account/account/pom.xml
COPY api/account/account/src     ./api/account/account/src
RUN cd api/account/account && mvn install -DskipTests -q

COPY api/auth/auth/pom.xml ./api/auth/auth/pom.xml
COPY api/auth/auth/src     ./api/auth/auth/src
RUN cd api/auth/auth && mvn install -DskipTests -q

COPY api/auth/auth-service/pom.xml ./api/auth/auth-service/pom.xml
COPY api/auth/auth-service/src     ./api/auth/auth-service/src
RUN cd api/auth/auth-service && mvn clean package -DskipTests -q

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/api/auth/auth-service/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
