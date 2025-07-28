-- Sample data for Hospital Admin Portal

-- Insert sample users (passwords are hashed for 'password123')
INSERT INTO users (username, email, password_hash, role) VALUES
('admin', 'admin@hospital.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1VQ2LGS8.1UOyC.si.UOyC.si.UOyC.s', 'ADMIN'),
('dr.smith', 'dr.smith@hospital.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1VQ2LGS8.1UOyC.si.UOyC.si.UOyC.s', 'DOCTOR'),
('dr.johnson', 'dr.johnson@hospital.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1VQ2LGS8.1UOyC.si.UOyC.si.UOyC.s', 'DOCTOR'),
('nurse.wilson', 'nurse.wilson@hospital.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1VQ2LGS8.1UOyC.si.UOyC.si.UOyC.s', 'NURSE'),
('receptionist', 'receptionist@hospital.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1VQ2LGS8.1UOyC.si.UOyC.si.UOyC.s', 'RECEPTIONIST');

-- Insert departments
INSERT INTO departments (name, description) VALUES
('Cardiology', 'Heart and cardiovascular system'),
('Neurology', 'Brain and nervous system'),
('Orthopedics', 'Bones, joints, and muscles'),
('Pediatrics', 'Children healthcare'),
('Emergency', 'Emergency medical care');

-- Insert sample staff
INSERT INTO staff (staff_id, user_id, first_name, last_name, specialization, department, phone, email, hire_date, salary) VALUES
('DOC001', 2, 'John', 'Smith', 'Cardiologist', 'Cardiology', '+1-555-0101', 'dr.smith@hospital.com', '2020-01-15', 150000.00),
('DOC002', 3, 'Sarah', 'Johnson', 'Neurologist', 'Neurology', '+1-555-0102', 'dr.johnson@hospital.com', '2019-03-20', 160000.00),
('NUR001', 4, 'Emily', 'Wilson', 'Registered Nurse', 'Emergency', '+1-555-0103', 'nurse.wilson@hospital.com', '2021-06-10', 65000.00);

-- Insert sample patients
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, phone, email, address, emergency_contact_name, emergency_contact_phone, blood_type, allergies) VALUES
('PAT001', 'Michael', 'Brown', '1985-07-15', 'MALE', '+1-555-1001', 'michael.brown@email.com', '123 Main St, City, State 12345', 'Jane Brown', '+1-555-1002', 'O+', 'Penicillin'),
('PAT002', 'Lisa', 'Davis', '1990-03-22', 'FEMALE', '+1-555-1003', 'lisa.davis@email.com', '456 Oak Ave, City, State 12345', 'Tom Davis', '+1-555-1004', 'A-', 'None'),
('PAT003', 'Robert', 'Miller', '1978-11-08', 'MALE', '+1-555-1005', 'robert.miller@email.com', '789 Pine St, City, State 12345', 'Mary Miller', '+1-555-1006', 'B+', 'Shellfish'),
('PAT004', 'Jennifer', 'Wilson', '1995-05-30', 'FEMALE', '+1-555-1007', 'jennifer.wilson@email.com', '321 Elm St, City, State 12345', 'David Wilson', '+1-555-1008', 'AB+', 'Latex'),
('PAT005', 'James', 'Taylor', '1982-09-12', 'MALE', '+1-555-1009', 'james.taylor@email.com', '654 Maple Ave, City, State 12345', 'Susan Taylor', '+1-555-1010', 'O-', 'None');

-- Insert sample appointments
INSERT INTO appointments (appointment_id, patient_id, doctor_id, appointment_date, appointment_time, status, reason) VALUES
('APT001', 1, 1, '2024-01-15', '09:00:00', 'SCHEDULED', 'Regular checkup'),
('APT002', 2, 2, '2024-01-15', '10:30:00', 'CONFIRMED', 'Headache consultation'),
('APT003', 3, 1, '2024-01-16', '14:00:00', 'SCHEDULED', 'Chest pain evaluation'),
('APT004', 4, 2, '2024-01-16', '11:00:00', 'COMPLETED', 'Follow-up visit'),
('APT005', 5, 1, '2024-01-17', '15:30:00', 'SCHEDULED', 'Heart palpitations');

-- Insert sample medical records
INSERT INTO medical_records (patient_id, doctor_id, appointment_id, diagnosis, treatment, prescription, notes) VALUES
(4, 2, 4, 'Migraine headache', 'Rest and medication', 'Sumatriptan 50mg as needed', 'Patient responded well to treatment. Follow-up in 2 weeks if symptoms persist.');

-- Update department heads
UPDATE departments SET head_of_department = 1 WHERE name = 'Cardiology';
UPDATE departments SET head_of_department = 2 WHERE name = 'Neurology';