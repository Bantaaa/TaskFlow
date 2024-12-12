# TaskFlow - Task Management Platform

## Overview
TaskFlow is a collaborative task management platform built with Jakarta EE, designed to streamline project management and team coordination. The platform offers advanced features like tag-based search, scheduling constraints, and automated status updates to enhance productivity in dynamic work environments.

## Technical Specifications

### Version Information
- **Current Version:** 1.2.0
- **Java Version:** JDK 11
- **Build System:** Maven 3.x

### Dependencies
- Jakarta EE (10.0.0)
- Hibernate ORM (6.2.7.Final)
- PostgreSQL (42.7.2)
- Jakarta Servlet (6.1.0)
- Jakarta Server Pages (4.0.0)
- JSTL (3.0.0)
- JUnit Jupiter (5.11.2)
- Mockito (3.7.7)
- Commons Validator (1.7)

## Features

### Core Functionality (v1.0.0)
- User management system with CRUD operations
- User attributes include:
  - Username
  - Password
  - First Name
  - Last Name
  - Email
  - Manager Assignment
- Robust JEE architecture
- Organized project structure

### Task Management (v1.1.0)
- **Task Creation Rules:**
  - No backdated tasks
  - Multiple tags required
  - 3-day advance planning
  - Tasks must be completed before deadline
- **Task Assignment System:**
  - Self-assignment capabilities
  - 2 daily tokens for task replacement
  - 1 monthly token for task deletion
  - Self-created tasks can be deleted without token use

### Advanced Features (v1.2.0)
- **Manager-Specific Features:**
  - Mandatory reassignment for replaced tasks
  - Manager-replaced tasks are locked from token modifications
  - Comprehensive overview of employee tasks
  - Performance analytics including:
    - Completion percentages by tag
    - Weekly, monthly, and yearly filters
    - Token usage tracking

- **Automated Systems:**
  - 24-hour task status updates
  - Automatic marking of overdue tasks
  - Double token bonus system for delayed manager responses (>12 hours)

## Installation

### Prerequisites
- JDK 11
- Maven 3.x
- PostgreSQL Database
- Jakarta EE compatible application server (GlassFish/Tomcat/WildFly)

### Quick Start
1. Clone the repository:
```bash
git clone https://github.com/bantaaa/taskflow.git
```

2. Navigate to project directory:
```bash
cd taskflow
```

3. Build the project:
```bash
mvn clean install
```

4. Deploy the generated WAR file to your application server

## Database Configuration
Configure your database connection in `src/main/resources/META-INF/persistence.xml` with your PostgreSQL credentials.

## Running Tests
```bash
mvn test
```

## Project Context
TaskFlow emerged from a collaborative effort to address gaps in existing task management tools. Built with Jakarta EE, the platform emphasizes innovation and user feedback, incorporating features like advanced tag-based search, scheduling constraints, and automated status updates. The project aims to be a catalyst for improved collaboration and project success, simplifying task management complexities for individuals, team leaders, and managers in dynamic work environments.

## Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Support
For support, please open an issue in the GitHub repository or contact the development team.

---
Built with ❤️ using Jakarta EE
