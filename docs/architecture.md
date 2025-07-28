# Hospital Admin Portal - Architecture Overview

## System Architecture

The Hospital Admin Portal is built using a microservices architecture with the following components:

### Backend Services

#### 1. Service Discovery (Eureka Server)
- **Port**: 8761
- **Purpose**: Service registration and discovery
- **Technology**: Spring Cloud Netflix Eureka

#### 2. API Gateway
- **Port**: 8080
- **Purpose**: Single entry point for all client requests
- **Technology**: Spring Cloud Gateway
- **Features**:
  - Request routing
  - Load balancing
  - Authentication
  - Rate limiting

#### 3. Authentication Service
- **Port**: 8081
- **Purpose**: User authentication and authorization
- **Features**:
  - JWT token generation and validation
  - Role-based access control
  - User management
  - Password encryption

#### 4. Patient Service
- **Port**: 8082
- **Purpose**: Patient data management
- **Features**:
  - Patient registration
  - Medical history
  - Patient search and filtering
  - CRUD operations

#### 5. Appointment Service
- **Port**: 8083
- **Purpose**: Appointment scheduling and management
- **Features**:
  - Appointment booking
  - Schedule management
  - Status tracking
  - Conflict resolution

#### 6. Staff Service
- **Port**: 8084
- **Purpose**: Hospital staff management
- **Features**:
  - Staff registration
  - Department management
  - Availability tracking
  - Role assignment

#### 7. Report Service
- **Port**: 8085
- **Purpose**: Analytics and reporting
- **Features**:
  - Statistical reports
  - Data visualization
  - Export functionality
  - Trend analysis

### Frontend

#### React.js Application
- **Port**: 3000
- **Technology**: React 18, Redux Toolkit, Bootstrap
- **Features**:
  - Responsive design
  - Real-time updates
  - Role-based UI
  - Interactive dashboards

### Database

#### PostgreSQL
- **Port**: 5432
- **Purpose**: Primary data storage
- **Features**:
  - ACID compliance
  - Advanced indexing
  - Full-text search
  - Data integrity constraints

### Monitoring & Observability

#### Prometheus
- **Port**: 9090
- **Purpose**: Metrics collection and monitoring

#### Grafana
- **Port**: 3001
- **Purpose**: Metrics visualization and alerting

## Data Flow

1. **Client Request**: Frontend sends request to API Gateway
2. **Authentication**: Gateway validates JWT token with Auth Service
3. **Service Discovery**: Gateway discovers target service via Eureka
4. **Business Logic**: Target service processes request
5. **Database**: Service interacts with PostgreSQL database
6. **Response**: Data flows back through the same path

## Security Architecture

### Authentication Flow
1. User submits credentials to Auth Service
2. Auth Service validates against database
3. JWT token generated with user roles
4. Token included in subsequent requests
5. Gateway validates token for each request

### Authorization
- Role-based access control (RBAC)
- Method-level security annotations
- Resource-level permissions
- API endpoint protection

## Scalability Considerations

### Horizontal Scaling
- Each microservice can be scaled independently
- Load balancing through API Gateway
- Database connection pooling
- Stateless service design

### Performance Optimization
- Database indexing strategy
- Caching mechanisms
- Asynchronous processing
- Connection pooling

## Deployment Architecture

### Development Environment
- Docker Compose for local development
- Hot reloading for frontend
- Database migrations with Flyway

### Production Environment
- Kubernetes orchestration
- Container registry
- CI/CD pipeline
- Health checks and monitoring

## Technology Stack

### Backend
- **Framework**: Spring Boot 3.2
- **Language**: Java 17
- **Database**: PostgreSQL 15
- **Security**: Spring Security + JWT
- **Documentation**: OpenAPI 3.0

### Frontend
- **Framework**: React 18
- **State Management**: Redux Toolkit
- **UI Library**: React Bootstrap
- **Charts**: Chart.js
- **HTTP Client**: Axios

### DevOps
- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **CI/CD**: Jenkins
- **Monitoring**: Prometheus + Grafana
- **Logging**: ELK Stack

## API Design

### RESTful Principles
- Resource-based URLs
- HTTP methods for operations
- Status codes for responses
- JSON data format

### API Versioning
- URL path versioning (/api/v1/)
- Backward compatibility
- Deprecation strategy

### Error Handling
- Consistent error response format
- Appropriate HTTP status codes
- Detailed error messages
- Logging and monitoring

## Data Model

### Core Entities
- **Users**: Authentication and authorization
- **Patients**: Patient information and medical history
- **Staff**: Hospital personnel and roles
- **Appointments**: Scheduling and status tracking
- **Medical Records**: Patient care documentation
- **Departments**: Organizational structure

### Relationships
- One-to-many: Patient to Appointments
- Many-to-one: Appointments to Doctor
- One-to-many: Staff to Departments
- One-to-many: Patient to Medical Records

## Quality Attributes

### Reliability
- Service redundancy
- Circuit breaker pattern
- Graceful degradation
- Data backup and recovery

### Performance
- Response time < 200ms for most operations
- Support for 1000+ concurrent users
- Database query optimization
- Caching strategies

### Security
- HTTPS encryption
- JWT token security
- SQL injection prevention
- XSS protection
- CSRF protection

### Maintainability
- Clean code principles
- Comprehensive testing
- Documentation
- Code reviews
- Continuous integration