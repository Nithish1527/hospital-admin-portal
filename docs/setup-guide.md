# Hospital Admin Portal - Setup Guide

## Prerequisites

Before setting up the Hospital Admin Portal, ensure you have the following installed:

### Required Software
- **Java 17** or higher
- **Node.js 18** or higher
- **Docker** and **Docker Compose**
- **Maven 3.8** or higher
- **Git**

### Optional Tools
- **IntelliJ IDEA** or **Eclipse** (for backend development)
- **Visual Studio Code** (for frontend development)
- **Postman** (for API testing)

## Quick Start (Docker Compose)

The fastest way to get the entire system running is using Docker Compose:

### 1. Clone the Repository
```bash
git clone <repository-url>
cd HospitalAdminPortal
```

### 2. Start All Services
```bash
cd devops/docker-compose
docker-compose up -d
```

### 3. Access the Application
- **Frontend**: http://localhost:3000
- **API Gateway**: http://localhost:8080
- **Eureka Dashboard**: http://localhost:8761
- **Grafana**: http://localhost:3001 (admin/admin123)
- **Prometheus**: http://localhost:9090

### 4. Default Login Credentials
- **Admin**: admin / password123
- **Doctor**: dr.smith / password123

## Manual Setup

If you prefer to run services individually for development:

### Database Setup

#### 1. Start PostgreSQL
```bash
cd database/postgresql
docker-compose up -d
```

#### 2. Verify Database Connection
- **Host**: localhost:5432
- **Database**: hospital_db
- **Username**: hospital_admin
- **Password**: hospital_pass123

### Backend Services Setup

#### 1. Service Discovery (Eureka)
```bash
cd backend/service-discovery
mvn clean install
mvn spring-boot:run
```

#### 2. Config Server
```bash
cd backend/config-server
mvn clean install
mvn spring-boot:run
```

#### 3. Authentication Service
```bash
cd backend/auth-service
mvn clean install
mvn spring-boot:run
```

#### 4. Other Microservices
Start each service in separate terminals:

```bash
# Patient Service
cd backend/patient-service
mvn clean install
mvn spring-boot:run

# Appointment Service
cd backend/appointment-service
mvn clean install
mvn spring-boot:run

# Staff Service
cd backend/staff-service
mvn clean install
mvn spring-boot:run

# Report Service
cd backend/report-service
mvn clean install
mvn spring-boot:run
```

#### 5. API Gateway
```bash
cd backend/api-gateway
mvn clean install
mvn spring-boot:run
```

### Frontend Setup

#### 1. Install Dependencies
```bash
cd frontend/hospital-admin-ui
npm install
```

#### 2. Start Development Server
```bash
npm start
```

The frontend will be available at http://localhost:3000

## Configuration

### Environment Variables

#### Backend Services
Each service can be configured using environment variables:

```bash
# Database Configuration
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/hospital_db
SPRING_DATASOURCE_USERNAME=hospital_admin
SPRING_DATASOURCE_PASSWORD=hospital_pass123

# Eureka Configuration
EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://localhost:8761/eureka/

# JWT Configuration
JWT_SECRET=your-secret-key
JWT_EXPIRATION=86400000
```

#### Frontend Configuration
Create a `.env` file in the frontend directory:

```bash
REACT_APP_API_URL=http://localhost:8080/api
REACT_APP_APP_NAME=Hospital Admin Portal
REACT_APP_VERSION=1.0.0
```

### Database Migration

#### Using Flyway (Production)
```bash
cd database/flyway
flyway migrate
```

#### Manual Setup (Development)
The Docker setup automatically runs initialization scripts.

## Development Workflow

### Backend Development

#### 1. Code Structure
```
backend/
├── auth-service/
│   ├── src/main/java/com/hospital/auth/
│   │   ├── controller/
│   │   ├── service/
│   │   ├── entity/
│   │   └── repository/
│   └── src/main/resources/
└── ...
```

#### 2. Adding New Endpoints
1. Create controller class
2. Implement service logic
3. Add repository methods
4. Update security configuration
5. Write tests

#### 3. Testing
```bash
# Run unit tests
mvn test

# Run integration tests
mvn verify
```

### Frontend Development

#### 1. Code Structure
```
frontend/hospital-admin-ui/src/
├── components/
├── pages/
├── services/
├── redux/
│   ├── actions/
│   ├── reducers/
│   └── store.js
└── App.js
```

#### 2. Adding New Features
1. Create component/page
2. Add Redux actions/reducers
3. Implement API service calls
4. Add routing
5. Style with Bootstrap

#### 3. Testing
```bash
# Run tests
npm test

# Build for production
npm run build
```

## API Documentation

### Accessing API Docs
Once the services are running, API documentation is available at:
- **Swagger UI**: http://localhost:8080/swagger-ui.html
- **OpenAPI Spec**: http://localhost:8080/v3/api-docs

### Key Endpoints

#### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/validate` - Token validation

#### Patients
- `GET /api/patients` - List patients
- `POST /api/patients` - Create patient
- `PUT /api/patients/{id}` - Update patient
- `DELETE /api/patients/{id}` - Delete patient

#### Appointments
- `GET /api/appointments` - List appointments
- `POST /api/appointments` - Create appointment
- `PUT /api/appointments/{id}` - Update appointment
- `DELETE /api/appointments/{id}` - Cancel appointment

## Troubleshooting

### Common Issues

#### 1. Service Discovery Issues
**Problem**: Services not registering with Eureka
**Solution**: 
- Check Eureka server is running
- Verify network connectivity
- Check service configuration

#### 2. Database Connection Issues
**Problem**: Cannot connect to PostgreSQL
**Solution**:
- Verify PostgreSQL is running
- Check connection parameters
- Ensure database exists

#### 3. Frontend API Calls Failing
**Problem**: CORS or network errors
**Solution**:
- Check API Gateway is running
- Verify CORS configuration
- Check network connectivity

#### 4. Authentication Issues
**Problem**: JWT token validation failing
**Solution**:
- Check JWT secret configuration
- Verify token expiration
- Check Auth Service logs

### Logging

#### Backend Services
Logs are available in the console output or can be configured to write to files:

```bash
# View logs for a specific service
docker logs hospital-auth

# Follow logs in real-time
docker logs -f hospital-auth
```

#### Frontend
Browser developer tools console shows frontend logs and errors.

### Health Checks

#### Service Health
Check service health at:
- http://localhost:8081/actuator/health (Auth Service)
- http://localhost:8082/actuator/health (Patient Service)
- etc.

#### Database Health
```bash
# Connect to PostgreSQL
docker exec -it hospital-postgres psql -U hospital_admin -d hospital_db

# Check tables
\dt
```

## Production Deployment

### Docker Images
Build production images:

```bash
# Backend services
cd backend/auth-service
docker build -t hospital/auth-service:latest .

# Frontend
cd frontend/hospital-admin-ui
docker build -t hospital/frontend:latest .
```

### Kubernetes Deployment
```bash
cd devops/kubernetes
kubectl apply -f deployments/
kubectl apply -f services/
kubectl apply -f ingress/
```

### Environment-Specific Configuration
- Use environment variables for configuration
- Separate configuration files for dev/staging/prod
- Use secrets management for sensitive data

## Monitoring and Maintenance

### Health Monitoring
- Prometheus metrics at http://localhost:9090
- Grafana dashboards at http://localhost:3001
- Application logs via ELK stack

### Database Maintenance
- Regular backups using provided scripts
- Monitor database performance
- Update statistics and reindex as needed

### Security Updates
- Regularly update dependencies
- Monitor security advisories
- Apply patches promptly

## Support

### Documentation
- API documentation: Swagger UI
- Code documentation: JavaDoc and JSDoc
- Architecture diagrams: `/docs/diagrams/`

### Getting Help
- Check logs for error messages
- Review configuration settings
- Consult API documentation
- Check GitHub issues

### Contributing
1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Submit pull request
5. Follow code review process