# Task Management System

A robust web-based task management application built with Java EE technologies. This system allows users to create, organize, and track tasks efficiently while providing team collaboration features and administrative controls.

## 🌟 Features

### Task Organization
- **Task Creation**: Create detailed tasks with descriptions and metadata
- **Categorization**: Organize tasks into custom categories
- **Priority & Due Dates**: Set task priorities and deadlines for better planning
- **Status Tracking**: Monitor task progress (Pending, In Progress, Completed)

### User Management
- **Secure Authentication**: User registration and login with encrypted password storage
- **Admin Panel**: Comprehensive user administration and management (not yet implemented)
- **Role-Based Access**: Different permission levels for users and administrators

### Reporting & Analytics
- **Productivity Metrics**: Track individual and team performance
- **Completion Reports**: Generate detailed task completion reports
- **Export Functionality**: Export reports for external analysis

## 🛠 Technology Stack

### Backend
- **Java EE**: Enterprise-grade Java application framework
- **Servlets & JSP**: Server-side processing and dynamic web pages
- **JDBC**: Direct database connectivity and operations
- **Maven**: Dependency management and build automation

### Frontend
- **HTML5**: Modern semantic markup
- **CSS3**: Advanced styling with modern features
- **JavaScript**: Interactive client-side functionality
- **Bootstrap 5**: Responsive design framework
- **FontAwesome**: Professional icon library

### Database
- **PostgresSQL**: Reliable relational database management
- **Alternative Support**: Compatible with other SQL databases

### Development Tools
- **Maven**: Project build and dependency management
- **Apache Tomcat**: Servlet container for deployment

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **JDK 11 or higher** - [Download Oracle JDK](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://openjdk.org/)
- **Apache Tomcat 9+** - [Download Tomcat](https://tomcat.apache.org/download-90.cgi)
- **Maven 3.6+** - [Download Maven](https://maven.apache.org/download.cgi)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YourUsername/TMS-008.git
   cd task-management-system
   ```

2. **Database Configuration**

   Create a `.env` file in the project root directory:
   ```properties
   # Database Configuration
   DB_URL=jdbc:mysql://localhost:3306/taskmanager
   DB_USERNAME=your_username
   DB_PASSWORD=your_password
   
   # Testing Configuration
   TESTING_USERNAME=test_user
   TESTING_EMAIL=test@example.com
   TESTING_PASSWORD=test_password
   ```

3. **Build the Application**
   ```bash
   mvn clean package
   ```

4. **Deploy & Run**

   **Option A: Deploy to Tomcat**
    - Copy the generated WAR file from `target/` to your Tomcat `webapps/` directory
    - Start Tomcat server

   **Option B: Run with Maven**
   ```bash
   mvn tomcat7:run
   ```

5. **Access the Application**

   Open your browser and navigate to:
   ```
   http://localhost:8080/taskmanager
   ```

## 🗄 Database Setup

### Database Schema Creation

Execute the following SQL script to create the required database structure:

```sql



## 🔧 Configuration

### Environment Variables

The application uses environment variables for configuration. Create a `.env` file with the following settings:

```properties
# Database Settings
DB_HOST=localhost
DB_PORT=5432
DB_NAME=taskmanager
DB_USERNAME=your_db_username
DB_PASSWORD=your_db_password


# Testing Configuration
TEST_DB_NAME=taskmanager_test
TESTING_USERNAME=test_user
TESTING_EMAIL=test@example.com
TESTING_PASSWORD=test_password
```

## 🧪 Testing

Run the test suite with Maven:

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=TaskServiceTest

# Generate test coverage report
mvn jacoco:report
```

### Docker Deployment (Optional)

```dockerfile
FROM tomcat:9-jdk11
COPY target/taskmanager.war /usr/local/tomcat/webapps/
EXPOSE 8080
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style Guidelines

- Follow Java naming conventions
- Use proper indentation (4 spaces)
- Add comments for complex logic
- Write unit tests for new features


**Built with ❤️ by Buntu William**