FROM maven:3.9.6-amazoncorretto-17 as build
WORKDIR app/
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:17-jdk-slim-buster
WORKDIR /app
COPY --from=build /app/target/jira-1.0.jar /app/JiraRush.jar
COPY ./resources /app/resources
COPY ./.env /app/.env
EXPOSE 8080
CMD ["java", "-jar", "JiraRush.jar"]
