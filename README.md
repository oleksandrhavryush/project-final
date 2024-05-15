# JiraRush Project

## Introduction
JiraRush is a comprehensive task management system, similar to Jira or Trello. It's designed to track any activity, from project management tasks to personal to-do lists. This project serves as a showcase of my skills and abilities.

## Features Implemented
1. **Project Structure Understanding (Onboarding)**: Familiarized with the project structure and workflow.
2. **Social Media Removal**: Removed VK and Yandex social media integrations.
3. **Sensitive Information Management**: Moved sensitive information like login credentials, database password, OAuth identifiers, and mail settings to a separate properties file. These values are read from the environment variables during server startup.
4. **Test Database Configuration**: Refactored tests to use an in-memory H2 database instead of PostgreSQL. This required simplifying some test data scripts due to feature differences between H2 and PostgreSQL.
5. **Controller Method Testing**: Wrote tests for all public methods in the `ProfileRestController`. This includes both successful and unsuccessful paths.
6. **File Upload Refactoring**: Refactored the `FileUtil#upload` method to use a modern approach for file system interaction.
7. **Task Tagging**: Added functionality to add tags to tasks. This includes both REST API and service implementation. The front-end implementation is optional.
8. **Time Tracking**: Implemented methods to calculate the time a task spent in work and testing. This required adding three records to the `ACTIVITY` table in the `changelog.sql` script.
9. **Dockerfile Creation**: Wrote a Dockerfile for the main server.
10. **Docker Compose Configuration**: Wrote a docker-compose file to run the server container along with the database and nginx. This required some modifications to the `config/nginx.conf` file.
11. **Localization**: Added localization for email templates and the `index.html` start page in five languages: English, Ukrainian, German, Chinese, and Arabic.

## Conclusion
All tasks have been successfully completed. The system is now more secure, efficient, and user-friendly. Looking forward to the next set of improvements!

## How to Run
1. Clone the project.
2. Run a local PostgreSQL server. I recommend doing this through Docker.
3. Build the project using `mvn clean install`.
4. Run the Spring Boot application (`JiraRushApplication`) with the `prod` profile.
5. Enjoy!
