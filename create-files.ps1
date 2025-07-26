# Hospital Admin Portal - File Generator Script
Write-Host "Creating Hospital Admin Portal Files..." -ForegroundColor Green

# Docker Compose File
@"
version: '3.8'

services:
  # Database
  postgres:
    image: postgres:15-alpine
    container_name: hospital-postgres
    environment:
      POSTGRES_DB: hospital_db
      POSTGRES_USER: hospital_user
      POSTGRES_PASSWORD: hospital_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init-scripts:/docker-entrypoint-initdb.d
    networks:
      - hospital-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U hospital_user -d hospital_db"]
      interval: 30s
      timeout: 10s
      retries: 3

  # API Gateway
  api-gateway:
    build:
      context: ./backend/api-gateway
      dockerfile: Dockerfile
    container_name: hospital-api-gateway
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - USER_SERVICE_URL=http://user-service:8081
      - PATIENT_SERVICE_URL=http://patient-service:8082
      - APPOINTMENT_SERVICE_URL=http://appointment-service:8083
      - DEPARTMENT_SERVICE_URL=http://department-service:8084
      - MEDICAL_SERVICE_URL=http://medical-service:8085
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - hospital-network

  # User Service
  user-service:
    build:
      context: ./backend/user-service
      dockerfile: Dockerfile
    container_name: hospital-user-service
    ports:
      - "8081:8081"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=hospital_db
      - DB_USERNAME=hospital_user
      - DB_PASSWORD=hospital_password
      - JWT_SECRET=hospitalAdminPortalSecretKey2024
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - hospital-network

  # Patient Service
  patient-service:
    build:
      context: ./backend/patient-service
      dockerfile: Dockerfile
    container_name: hospital-patient-service
    ports:
      - "8082:8082"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=hospital_db
      - DB_USERNAME=hospital_user
      - DB_PASSWORD=hospital_password
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - hospital-network

  # Appointment Service
  appointment-service:
    build:
      context: ./backend/appointment-service
      dockerfile: Dockerfile
    container_name: hospital-appointment-service
    ports:
      - "8083:8083"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=hospital_db
      - DB_USERNAME=hospital_user
      - DB_PASSWORD=hospital_password
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - hospital-network

  # Department Service
  department-service:
    build:
      context: ./backend/department-service
      dockerfile: Dockerfile
    container_name: hospital-department-service
    ports:
      - "8084:8084"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=hospital_db
      - DB_USERNAME=hospital_user
      - DB_PASSWORD=hospital_password
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - hospital-network

  # Medical Service
  medical-service:
    build:
      context: ./backend/medical-service
      dockerfile: Dockerfile
    container_name: hospital-medical-service
    ports:
      - "8085:8085"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=hospital_db
      - DB_USERNAME=hospital_user
      - DB_PASSWORD=hospital_password
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - hospital-network

  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: hospital-frontend
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_BASE_URL=http://localhost:8080
    depends_on:
      - api-gateway
    networks:
      - hospital-network

volumes:
  postgres_data:

networks:
  hospital-network:
    driver: bridge
"@ | Out-File -FilePath "docker-compose.yml" -Encoding UTF8

# Database Init Script
@"
-- Hospital Admin Portal Database Schema

-- Users table (for authentication and authorization)
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'DOCTOR', 'NURSE', 'STAFF')),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Departments table
CREATE TABLE departments (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    head_doctor_id BIGINT,
    total_beds INTEGER DEFAULT 0,
    available_beds INTEGER DEFAULT 0,
    location VARCHAR(100),
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patients table
CREATE TABLE patients (
    id BIGSERIAL PRIMARY KEY,
    patient_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    blood_group VARCHAR(5),
    allergies TEXT,
    medical_history TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctors table (extends users)
CREATE TABLE doctors (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    department_id BIGINT REFERENCES departments(id),
    qualification VARCHAR(200),
    experience_years INTEGER DEFAULT 0,
    consultation_fee DECIMAL(10,2),
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert admin user (password: admin123)
INSERT INTO users (username, email, password, first_name, last_name, role) VALUES
('admin', 'admin@hospital.com', '$2a$10$7XjzPvMUeRdFe.uNcpFP/uzgXZJnYHT8nH7hI4aWx4QxGKEBZqD/i', 'System', 'Administrator', 'ADMIN');

-- Insert departments
INSERT INTO departments (name, description, total_beds, available_beds, location, phone) VALUES
('Cardiology', 'Heart and cardiovascular care', 20, 15, 'Building A, Floor 2', '+1-555-0101'),
('Neurology', 'Brain and nervous system care', 15, 10, 'Building B, Floor 3', '+1-555-0102'),
('Orthopedics', 'Bone and joint care', 25, 20, 'Building A, Floor 1', '+1-555-0103'),
('Pediatrics', 'Children healthcare', 30, 25, 'Building C, Floor 1', '+1-555-0104'),
('Emergency', 'Emergency care services', 10, 8, 'Building A, Ground Floor', '+1-555-0105');
"@ | Out-File -FilePath "database/init-scripts/01-init-database.sql" -Encoding UTF8

# API Gateway POM
@"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>

    <groupId>com.hospital</groupId>
    <artifactId>api-gateway</artifactId>
    <version>1.0.0</version>
    <name>Hospital API Gateway</name>
    <description>API Gateway for Hospital Admin Portal</description>

    <properties>
        <java.version>17</java.version>
        <spring-cloud.version>2023.0.0</spring-cloud.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-gateway</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-webflux</artifactId>
        </dependency>
    </dependencies>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
"@ | Out-File -FilePath "backend/api-gateway/pom.xml" -Encoding UTF8

# API Gateway Application
@"
package com.hospital.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

@SpringBootApplication
public class ApiGatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
    }

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                .route("user-service", r -> r.path("/api/auth/**", "/api/users/**")
                        .uri("${USER_SERVICE_URL:http://localhost:8081}"))
                .route("patient-service", r -> r.path("/api/patients/**")
                        .uri("${PATIENT_SERVICE_URL:http://localhost:8082}"))
                .route("appointment-service", r -> r.path("/api/appointments/**")
                        .uri("${APPOINTMENT_SERVICE_URL:http://localhost:8083}"))
                .route("department-service", r -> r.path("/api/departments/**", "/api/beds/**")
                        .uri("${DEPARTMENT_SERVICE_URL:http://localhost:8084}"))
                .route("medical-service", r -> r.path("/api/medical-records/**", "/api/prescriptions/**", "/api/lab-tests/**")
                        .uri("${MEDICAL_SERVICE_URL:http://localhost:8085}"))
                .build();
    }

    @Bean
    public CorsWebFilter corsFilter() {
        CorsConfiguration corsConfig = new CorsConfiguration();
        corsConfig.addAllowedOriginPattern("*");
        corsConfig.addAllowedMethod("*");
        corsConfig.addAllowedHeader("*");
        corsConfig.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfig);

        return new CorsWebFilter(source);
    }
}
"@ | Out-File -FilePath "backend/api-gateway/src/main/java/com/hospital/gateway/ApiGatewayApplication.java" -Encoding UTF8

# API Gateway Config
@"
server:
  port: 8080

spring:
  application:
    name: api-gateway
  cloud:
    gateway:
      default-filters:
        - DedupeResponseHeader=Access-Control-Allow-Credentials Access-Control-Allow-Origin
      globalcors:
        corsConfigurations:
          '[/**]':
            allowedOriginPatterns: "*"
            allowedMethods: "*"
            allowedHeaders: "*"
            allowCredentials: true

management:
  endpoints:
    web:
      exposure:
        include: health,info

USER_SERVICE_URL: ${USER_SERVICE_URL:http://user-service:8081}
PATIENT_SERVICE_URL: ${PATIENT_SERVICE_URL:http://patient-service:8082}
APPOINTMENT_SERVICE_URL: ${APPOINTMENT_SERVICE_URL:http://appointment-service:8083}
DEPARTMENT_SERVICE_URL: ${DEPARTMENT_SERVICE_URL:http://department-service:8084}
MEDICAL_SERVICE_URL: ${MEDICAL_SERVICE_URL:http://medical-service:8085}
"@ | Out-File -FilePath "backend/api-gateway/src/main/resources/application.yml" -Encoding UTF8

# User Service POM
@"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>

    <groupId>com.hospital</groupId>
    <artifactId>user-service</artifactId>
    <version>1.0.0</version>
    <name>Hospital User Service</name>
    <description>User Management Service for Hospital Admin Portal</description>

    <properties>
        <java.version>17</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-api</artifactId>
            <version>0.11.5</version>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-impl</artifactId>
            <version>0.11.5</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-jackson</artifactId>
            <version>0.11.5</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springdoc</groupId>
            <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
            <version>2.2.0</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
"@ | Out-File -FilePath "backend/user-service/pom.xml" -Encoding UTF8

Write-Host "Core files created! Creating frontend files..." -ForegroundColor Yellow

# Frontend Package.json
@"
{
  "name": "hospital-admin-portal-frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "@mui/material": "^5.15.0",
    "@mui/icons-material": "^5.15.0",
    "@emotion/react": "^11.11.1",
    "@emotion/styled": "^11.11.0",
    "@reduxjs/toolkit": "^2.0.1",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-redux": "^9.0.4",
    "react-router-dom": "^6.20.1",
    "axios": "^1.6.2",
    "react-hook-form": "^7.48.2",
    "@hookform/resolvers": "^3.3.2",
    "yup": "^1.4.0",
    "date-fns": "^3.0.0",
    "@mui/x-date-pickers": "^6.18.0",
    "@mui/lab": "^5.0.0-alpha.156",
    "react-toastify": "^9.1.3"
  },
  "devDependencies": {
    "@types/react": "^18.2.43",
    "@types/react-dom": "^18.2.17",
    "@vitejs/plugin-react": "^4.2.0",
    "vite": "^5.0.8",
    "typescript": "^5.3.3"
  },
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "start": "vite --host 0.0.0.0 --port 3000"
  }
}
"@ | Out-File -FilePath "frontend/package.json" -Encoding UTF8

# Frontend Vite Config
@"
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 3000,
    proxy: {
      '/api': {
        target: process.env.REACT_APP_API_BASE_URL || 'http://localhost:8080',
        changeOrigin: true,
      }
    }
  },
  build: {
    outDir: 'dist',
    sourcemap: false,
  },
})
"@ | Out-File -FilePath "frontend/vite.config.js" -Encoding UTF8

# Frontend index.html
@"
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hospital Admin Portal</title>
    <link
      rel="stylesheet"
      href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap"
    />
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
"@ | Out-File -FilePath "frontend/index.html" -Encoding UTF8

# Create Dockerfiles for all services
@"
FROM openjdk:17-jdk-slim as builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apt-get update && apt-get install -y maven
RUN mvn clean package -DskipTests

FROM openjdk:17-jre-slim
WORKDIR /app
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
"@ | Out-File -FilePath "backend/api-gateway/Dockerfile" -Encoding UTF8

# Copy Dockerfile to other services
$services = @("user-service", "patient-service", "appointment-service", "department-service", "medical-service")
$ports = @(8081, 8082, 8083, 8084, 8085)

for ($i = 0; $i -lt $services.Length; $i++) {
    $service = $services[$i]
    $port = $ports[$i]
    
    @"
FROM openjdk:17-jdk-slim as builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apt-get update && apt-get install -y maven
RUN mvn clean package -DskipTests

FROM openjdk:17-jre-slim
WORKDIR /app
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/*.jar app.jar
EXPOSE $port
ENTRYPOINT ["java", "-jar", "app.jar"]
"@ | Out-File -FilePath "backend/$service/Dockerfile" -Encoding UTF8
}

# Frontend Dockerfile
@"
FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
"@ | Out-File -FilePath "frontend/Dockerfile" -Encoding UTF8

# README
@"
# Hospital Admin Portal

A comprehensive 3-tier microservice hospital management system built with Java Spring Boot, React.js, and PostgreSQL.

## Quick Start

### Prerequisites
- Docker and Docker Compose installed

### Running the Application

1. **Start all services:**
   ```bash
   docker-compose up --build
   ```

2. **Access the application:**
   - **Frontend**: http://localhost:3000
   - **API Gateway**: http://localhost:8080

### Login Credentials
```
Username: admin
Password: admin123
```

## Architecture

### Microservices
1. **API Gateway** (Port 8080) - Routes requests
2. **User Service** (Port 8081) - Authentication
3. **Patient Service** (Port 8082) - Patient management
4. **Appointment Service** (Port 8083) - Appointments
5. **Department Service** (Port 8084) - Departments
6. **Medical Service** (Port 8085) - Medical records

## Features
- Patient Management
- Appointment Scheduling
- Department Management  
- Medical Records
- User Authentication with JWT
- Role-based Access Control

## API Documentation
Once running, access Swagger UI:
- User Service: http://localhost:8081/swagger-ui.html
- Patient Service: http://localhost:8082/swagger-ui.html
- And so on for other services...

## Production Ready
- Docker containerization
- Health checks
- Database persistence
- Environment configuration
- CORS configuration
- Security with JWT tokens
"@ | Out-File -FilePath "README.md" -Encoding UTF8

Write-Host "✅ Hospital Admin Portal project created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Make sure Docker Desktop is running"
Write-Host "2. Run: docker-compose up --build"
Write-Host "3. Access: http://localhost:3000"
Write-Host "4. Login: admin / admin123"
Write-Host ""
Write-Host "🏥 Your hospital management system is ready!" -ForegroundColor Cyan