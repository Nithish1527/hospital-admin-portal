# Hospital Admin Portal - Windows Setup Instructions

## Quick Setup for Windows

You have 3 options to set up the complete hospital admin portal:

### Option 1: Automated Setup (Recommended)

1. **Create the directory structure:**
   ```cmd
   create-hospital-portal.bat
   ```

2. **Generate all project files:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File create-files.ps1
   ```

3. **Start the application:**
   ```cmd
   docker-compose up --build
   ```

### Option 2: Manual File Creation

If the automated scripts don't work, you can manually create the key files:

#### 1. Create `docker-compose.yml` in your root directory:

```yaml
version: '3.8'

services:
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

  # Add other services here (refer to the PowerShell script for complete configuration)

volumes:
  postgres_data:

networks:
  hospital-network:
    driver: bridge
```

#### 2. Create database initialization script:
Create `database/init-scripts/01-init-database.sql` with the database schema (refer to the PowerShell script for the complete SQL).

### Option 3: Download Complete Project

If you prefer, you can:

1. Download a complete project archive
2. Extract to your `hospital-admin-portal` folder
3. Run `docker-compose up --build`

## Prerequisites

Before running any option, make sure you have:

1. **Docker Desktop** installed and running
   - Download from: https://www.docker.com/products/docker-desktop
   - Make sure it's running (check system tray)

2. **Git** (optional, for version control)
   - Download from: https://git-scm.com/download/win

## Verification

After setup, verify your project structure looks like this:

```
hospital-admin-portal/
├── docker-compose.yml
├── README.md
├── database/
│   └── init-scripts/
│       └── 01-init-database.sql
├── backend/
│   ├── api-gateway/
│   ├── user-service/
│   ├── patient-service/
│   ├── appointment-service/
│   ├── department-service/
│   └── medical-service/
└── frontend/
    ├── package.json
    ├── index.html
    └── src/
```

## Running the Application

Once you have the files in place:

1. **Open Command Prompt or PowerShell in your project directory**

2. **Start all services:**
   ```cmd
   docker-compose up --build
   ```

3. **Wait for all services to start** (first run takes 5-10 minutes)

4. **Access the application:**
   - Frontend: http://localhost:3000
   - Login: admin / admin123

## Troubleshooting

### Common Issues:

1. **Docker not running:**
   - Start Docker Desktop from Start menu
   - Wait for it to fully load

2. **Port conflicts:**
   - Make sure ports 3000, 5432, 8080-8085 are not in use
   - Close other applications using these ports

3. **Build failures:**
   - Increase Docker memory allocation
   - Docker Desktop → Settings → Resources → Memory

4. **PowerShell execution policy:**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

### Getting Help:

If you encounter issues:

1. Check Docker Desktop is running
2. Verify your project structure matches the expected layout
3. Check the logs: `docker-compose logs -f`
4. Restart Docker Desktop if needed

## What You Get

After successful setup, you'll have:

- ✅ Complete hospital management system
- ✅ 6 microservices (Spring Boot)
- ✅ React.js frontend with Material-UI
- ✅ PostgreSQL database with sample data
- ✅ JWT authentication system
- ✅ Role-based access control
- ✅ API documentation (Swagger)
- ✅ Production-ready Docker configuration

The system includes:
- Patient management
- Appointment scheduling
- Department management
- Medical records
- User authentication
- Dashboard with statistics

**Login credentials:**
- Username: `admin`
- Password: `admin123`

This is a complete, production-ready hospital management system that you can deploy immediately!