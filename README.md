# Hospital Admin Portal

A comprehensive hospital management system built with microservices architecture, featuring patient management, appointment scheduling, staff management, and reporting capabilities.

## Architecture

- **Backend**: Java Spring Boot microservices
- **Frontend**: React.js with Redux
- **Database**: PostgreSQL
- **Service Discovery**: Eureka
- **API Gateway**: Spring Cloud Gateway
- **Monitoring**: Prometheus, Grafana, ELK Stack
- **Deployment**: Docker, Kubernetes

## Quick Start

1. **Database Setup**
   ```bash
   cd database/postgresql
   docker-compose up -d
   ```

2. **Backend Services**
   ```bash
   cd devops/docker-compose
   docker-compose up -d
   ```

3. **Frontend**
   ```bash
   cd frontend/hospital-admin-ui
   npm install
   npm start
   ```

## Features

- **Patient Management**: Registration, medical records, search
- **Appointment Scheduling**: Book, reschedule, cancel appointments
- **Staff Management**: Doctor and nurse profiles, schedules
- **Reporting**: Patient statistics, appointment analytics
- **Authentication**: JWT-based secure authentication
- **Role-based Access Control**: Admin, Doctor, Nurse roles

## Documentation

See the `docs/` directory for detailed documentation:
- [Architecture Overview](docs/architecture.md)
- [Setup Guide](docs/setup-guide.md)
- [DevOps Pipeline](docs/devops-pipeline.md)
- [Security & Compliance](docs/security.md)

## License

MIT License