# Database Setup Guide

## PostgreSQL Setup

### Local Development with Docker

1. Navigate to the PostgreSQL directory:
   ```bash
   cd database/postgresql
   ```

2. Start PostgreSQL and pgAdmin:
   ```bash
   docker-compose up -d
   ```

3. Access pgAdmin at http://localhost:5050
   - Email: admin@hospital.com
   - Password: admin123

4. Connect to PostgreSQL:
   - Host: postgres
   - Port: 5432
   - Database: hospital_db
   - Username: hospital_admin
   - Password: hospital_pass123

### Database Schema

The database includes the following main tables:
- `users` - Authentication and user management
- `patients` - Patient information and medical history
- `staff` - Hospital staff and doctors
- `appointments` - Appointment scheduling
- `medical_records` - Patient medical records
- `departments` - Hospital departments

### Flyway Migrations

For production deployments, use Flyway for database migrations:

1. Configure Flyway settings in `flyway/conf/flyway.conf`
2. Place migration scripts in `flyway/migrations/`
3. Run migrations:
   ```bash
   flyway migrate
   ```

### Sample Data

The initialization scripts include sample data for testing:
- 5 users with different roles
- 5 patients with medical information
- 3 staff members (doctors and nurses)
- 5 appointments
- Sample medical records

### Security Notes

- Change default passwords in production
- Use environment variables for sensitive data
- Enable SSL/TLS for database connections
- Implement proper backup and recovery procedures