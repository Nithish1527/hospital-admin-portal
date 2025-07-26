# Hospital Admin Portal

A comprehensive 3-tier microservice hospital management system built with Java Spring Boot, React.js, and PostgreSQL, fully containerized with Docker.

## 🏥 Project Overview

The Hospital Admin Portal is a production-ready, on-premise hospital management system that provides:

- **Patient Management**: Registration, medical history, and patient records
- **Appointment Scheduling**: Doctor appointments and scheduling system
- **Department Management**: Hospital department and bed management
- **Medical Records**: Electronic health records and prescription management
- **User Authentication**: Role-based access control with JWT tokens

## 🏗️ Architecture

### 3-Tier Microservice Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Frontend      │    │     Backend      │    │    Database     │
│   (React.js)    │◄───┤  (Spring Boot)   │◄───┤  (PostgreSQL)   │
│   Port: 3000    │    │   Microservices  │    │   Port: 5432    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Microservices

1. **API Gateway** (Port 8080) - Routes requests and handles CORS
2. **User Service** (Port 8081) - Authentication and user management
3. **Patient Service** (Port 8082) - Patient data management
4. **Appointment Service** (Port 8083) - Appointment scheduling
5. **Department Service** (Port 8084) - Department and bed management
6. **Medical Service** (Port 8085) - Medical records and prescriptions

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Git (for cloning the repository)

### Running the Application

1. **Clone and navigate to the project:**
   ```bash
   git clone <repository-url>
   cd hospital-admin-portal
   ```

2. **Start all services:**
   ```bash
   docker-compose up --build
   ```

3. **Access the application:**
   - **Frontend**: http://localhost:3000
   - **API Gateway**: http://localhost:8080
   - **Database**: localhost:5432

### Login Credentials

```
Username: admin
Password: admin123
```

## 📊 API Documentation

Once the services are running, access Swagger UI documentation:

- **User Service**: http://localhost:8081/swagger-ui.html
- **Patient Service**: http://localhost:8082/swagger-ui.html
- **Appointment Service**: http://localhost:8083/swagger-ui.html
- **Department Service**: http://localhost:8084/swagger-ui.html
- **Medical Service**: http://localhost:8085/swagger-ui.html

## 🗄️ Database Schema

The system uses PostgreSQL with the following main tables:

- `users` - System users (admin, doctors, nurses, staff)
- `patients` - Patient information and medical history
- `departments` - Hospital departments and locations
- `doctors` - Doctor profiles and specializations
- `appointments` - Appointment scheduling and status
- `medical_records` - Electronic health records
- `prescriptions` - Medication prescriptions
- `beds` - Hospital bed management
- `lab_tests` - Laboratory test results

## 🔧 Development

### Project Structure

```
hospital-admin-portal/
├── frontend/                 # React.js application
│   ├── src/
│   │   ├── components/      # Reusable UI components
│   │   ├── pages/          # Application pages
│   │   ├── services/       # API services
│   │   ├── store/          # Redux store and slices
│   │   └── utils/          # Utility functions
│   ├── Dockerfile
│   └── package.json
├── backend/
│   ├── api-gateway/        # Spring Cloud Gateway
│   ├── user-service/       # User management
│   ├── patient-service/    # Patient management
│   ├── appointment-service/# Appointment management
│   ├── department-service/ # Department management
│   └── medical-service/    # Medical records
├── database/
│   └── init-scripts/       # Database initialization
├── docker-compose.yml      # Docker orchestration
└── README.md
```

### Technology Stack

#### Frontend
- **Framework**: React.js 18
- **UI Library**: Material-UI (MUI)
- **State Management**: Redux Toolkit
- **Build Tool**: Vite
- **HTTP Client**: Axios

#### Backend
- **Framework**: Spring Boot 3.2
- **Security**: Spring Security with JWT
- **Database**: Spring Data JPA with PostgreSQL
- **Documentation**: OpenAPI/Swagger
- **Build Tool**: Maven

#### Infrastructure
- **Containerization**: Docker
- **Orchestration**: Docker Compose
- **Database**: PostgreSQL 15
- **Reverse Proxy**: Nginx (for frontend)

### Environment Variables

The application uses the following environment variables (configured in docker-compose.yml):

```bash
# Database
DB_HOST=postgres
DB_PORT=5432
DB_NAME=hospital_db
DB_USERNAME=hospital_user
DB_PASSWORD=hospital_password

# JWT Security
JWT_SECRET=hospitalAdminPortalSecretKey2024

# Service URLs (for API Gateway)
USER_SERVICE_URL=http://user-service:8081
PATIENT_SERVICE_URL=http://patient-service:8082
APPOINTMENT_SERVICE_URL=http://appointment-service:8083
DEPARTMENT_SERVICE_URL=http://department-service:8084
MEDICAL_SERVICE_URL=http://medical-service:8085
```

## 🔒 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Role-Based Access Control**: Different roles (ADMIN, DOCTOR, NURSE, STAFF)
- **Password Encryption**: BCrypt password hashing
- **CORS Configuration**: Proper cross-origin resource sharing
- **Input Validation**: Comprehensive data validation
- **SQL Injection Protection**: JPA/Hibernate protection

## 🩺 Features

### Dashboard
- System overview with statistics
- Quick action buttons
- Recent activities summary

### Patient Management
- Patient registration and profiles
- Medical history tracking
- Search and filter capabilities
- Emergency contact information

### Appointment System
- Schedule appointments with doctors
- View appointment calendar
- Appointment status management
- Doctor availability tracking

### Department Management
- Department information and locations
- Bed allocation and tracking
- Department statistics

### Medical Records
- Electronic health records (EHR)
- Prescription management
- Lab test results
- Medical history timeline

## 🔄 Health Checks

All services include health check endpoints:

- **Health Check URL**: `/actuator/health`
- **Monitoring**: Docker health checks with automatic restarts
- **Graceful Startup**: Services wait for database availability

## 📈 Production Deployment

### Docker Compose Production

The current setup is production-ready with:

- Multi-stage Docker builds for optimized images
- Health checks and restart policies
- Volume persistence for database
- Environment-based configuration
- Nginx reverse proxy for frontend

### Scaling Considerations

To scale individual services:

```bash
docker-compose up --scale patient-service=3 --scale appointment-service=2
```

### Backup and Recovery

Database backup:
```bash
docker exec hospital-postgres pg_dump -U hospital_user hospital_db > backup.sql
```

Database restore:
```bash
docker exec -i hospital-postgres psql -U hospital_user hospital_db < backup.sql
```

## 🛠️ Troubleshooting

### Common Issues

1. **Port Conflicts**: Ensure ports 3000, 5432, and 8080-8085 are available
2. **Memory Issues**: Increase Docker memory allocation if builds fail
3. **Database Connection**: Check if PostgreSQL is fully started before services

### Logs

View service logs:
```bash
docker-compose logs [service-name]
docker-compose logs -f  # Follow logs
```

### Service Status

Check service health:
```bash
curl http://localhost:8080/actuator/health  # API Gateway
curl http://localhost:8081/actuator/health  # User Service
# ... etc for other services
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:

1. Check the troubleshooting section
2. Review the API documentation
3. Check Docker logs for error details
4. Open an issue in the repository

---

**Hospital Admin Portal** - A comprehensive hospital management solution built for production environments.