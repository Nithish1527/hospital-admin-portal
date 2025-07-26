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

-- Appointments table
CREATE TABLE appointments (
    id BIGSERIAL PRIMARY KEY,
    appointment_number VARCHAR(20) UNIQUE NOT NULL,
    patient_id BIGINT REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id BIGINT REFERENCES doctors(id) ON DELETE CASCADE,
    department_id BIGINT REFERENCES departments(id),
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    duration_minutes INTEGER DEFAULT 30,
    status VARCHAR(20) DEFAULT 'SCHEDULED' CHECK (status IN ('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW')),
    reason_for_visit TEXT,
    notes TEXT,
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Medical Records table
CREATE TABLE medical_records (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id BIGINT REFERENCES doctors(id),
    appointment_id BIGINT REFERENCES appointments(id),
    record_date DATE NOT NULL,
    diagnosis TEXT,
    symptoms TEXT,
    treatment_plan TEXT,
    notes TEXT,
    vital_signs JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Prescriptions table
CREATE TABLE prescriptions (
    id BIGSERIAL PRIMARY KEY,
    medical_record_id BIGINT REFERENCES medical_records(id) ON DELETE CASCADE,
    patient_id BIGINT REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id BIGINT REFERENCES doctors(id),
    prescription_number VARCHAR(20) UNIQUE NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration_days INTEGER NOT NULL,
    instructions TEXT,
    prescribed_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Beds table
CREATE TABLE beds (
    id BIGSERIAL PRIMARY KEY,
    bed_number VARCHAR(20) NOT NULL,
    department_id BIGINT REFERENCES departments(id) ON DELETE CASCADE,
    room_number VARCHAR(10),
    bed_type VARCHAR(20) NOT NULL CHECK (bed_type IN ('GENERAL', 'ICU', 'PRIVATE', 'SEMI_PRIVATE')),
    is_occupied BOOLEAN DEFAULT false,
    patient_id BIGINT REFERENCES patients(id),
    admission_date TIMESTAMP,
    discharge_date TIMESTAMP,
    daily_rate DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(bed_number, department_id)
);

-- Lab Tests table
CREATE TABLE lab_tests (
    id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id BIGINT REFERENCES doctors(id),
    test_name VARCHAR(100) NOT NULL,
    test_type VARCHAR(50) NOT NULL,
    test_date DATE NOT NULL,
    result_date DATE,
    result_value TEXT,
    normal_range VARCHAR(50),
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key constraints
ALTER TABLE departments ADD CONSTRAINT fk_departments_head_doctor 
    FOREIGN KEY (head_doctor_id) REFERENCES doctors(id);

-- Create indexes for better performance
CREATE INDEX idx_patients_patient_id ON patients(patient_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_medical_records_patient ON medical_records(patient_id);
CREATE INDEX idx_prescriptions_patient ON prescriptions(patient_id);
CREATE INDEX idx_beds_department ON beds(department_id);
CREATE INDEX idx_lab_tests_patient ON lab_tests(patient_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);

-- Insert sample data

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

-- Insert sample doctor users
INSERT INTO users (username, email, password, first_name, last_name, role) VALUES
('dr.smith', 'dr.smith@hospital.com', '$2a$10$7XjzPvMUeRdFe.uNcpFP/uzgXZJnYHT8nH7hI4aWx4QxGKEBZqD/i', 'John', 'Smith', 'DOCTOR'),
('dr.johnson', 'dr.johnson@hospital.com', '$2a$10$7XjzPvMUeRdFe.uNcpFP/uzgXZJnYHT8nH7hI4aWx4QxGKEBZqD/i', 'Sarah', 'Johnson', 'DOCTOR'),
('dr.brown', 'dr.brown@hospital.com', '$2a$10$7XjzPvMUeRdFe.uNcpFP/uzgXZJnYHT8nH7hI4aWx4QxGKEBZqD/i', 'Michael', 'Brown', 'DOCTOR');

-- Insert doctors
INSERT INTO doctors (user_id, license_number, specialization, department_id, qualification, experience_years, consultation_fee) VALUES
(2, 'MD001234', 'Cardiologist', 1, 'MD in Cardiology', 10, 200.00),
(3, 'MD001235', 'Neurologist', 2, 'MD in Neurology', 8, 250.00),
(4, 'MD001236', 'Orthopedic Surgeon', 3, 'MD in Orthopedics', 12, 300.00);

-- Insert sample patients
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, phone, email, address, emergency_contact_name, emergency_contact_phone, blood_group) VALUES
('P001', 'Alice', 'Cooper', '1985-03-15', 'FEMALE', '+1-555-1001', 'alice.cooper@email.com', '123 Main St, City, State', 'Bob Cooper', '+1-555-1002', 'O+'),
('P002', 'David', 'Wilson', '1978-07-22', 'MALE', '+1-555-1003', 'david.wilson@email.com', '456 Oak Ave, City, State', 'Mary Wilson', '+1-555-1004', 'A+'),
('P003', 'Emma', 'Davis', '1990-11-08', 'FEMALE', '+1-555-1005', 'emma.davis@email.com', '789 Pine Rd, City, State', 'James Davis', '+1-555-1006', 'B+');

-- Insert sample beds
INSERT INTO beds (bed_number, department_id, room_number, bed_type, daily_rate) VALUES
('C001', 1, '201', 'GENERAL', 150.00),
('C002', 1, '201', 'GENERAL', 150.00),
('N001', 2, '301', 'ICU', 400.00),
('N002', 2, '302', 'PRIVATE', 300.00),
('O001', 3, '101', 'GENERAL', 120.00);

-- Update trigger function for updated_at columns
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add triggers to update updated_at automatically
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON departments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_patients_updated_at BEFORE UPDATE ON patients FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_doctors_updated_at BEFORE UPDATE ON doctors FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_appointments_updated_at BEFORE UPDATE ON appointments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_medical_records_updated_at BEFORE UPDATE ON medical_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_prescriptions_updated_at BEFORE UPDATE ON prescriptions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_beds_updated_at BEFORE UPDATE ON beds FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lab_tests_updated_at BEFORE UPDATE ON lab_tests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();