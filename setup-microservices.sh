#!/bin/bash

# Hospital Admin Portal - Microservices Setup Script

echo "Setting up Hospital Admin Portal Microservices..."

# Create directory structures
mkdir -p backend/{department-service,medical-service}/src/main/{java/com/hospital/{department,medical}/{entity,repository,service,controller,dto,config},resources}

# Create Patient Service Application
cat > backend/patient-service/src/main/java/com/hospital/patient/PatientServiceApplication.java << 'EOF'
package com.hospital.patient;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class PatientServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(PatientServiceApplication.class, args);
    }
}
EOF

# Create Patient Entity
cat > backend/patient-service/src/main/java/com/hospital/patient/entity/Patient.java << 'EOF'
package com.hospital.patient.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Email;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "patients")
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "patient_id", unique = true)
    private String patientId;

    @NotBlank
    @Column(name = "first_name")
    private String firstName;

    @NotBlank
    @Column(name = "last_name")
    private String lastName;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    private String phone;

    @Email
    private String email;

    private String address;

    @Column(name = "emergency_contact_name")
    private String emergencyContactName;

    @Column(name = "emergency_contact_phone")
    private String emergencyContactPhone;

    @Column(name = "blood_group")
    private String bloodGroup;

    private String allergies;

    @Column(name = "medical_history", columnDefinition = "TEXT")
    private String medicalHistory;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // Constructors, getters, setters
    public Patient() {}

    public enum Gender {
        MALE, FEMALE, OTHER
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public Gender getGender() { return gender; }
    public void setGender(Gender gender) { this.gender = gender; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getEmergencyContactName() { return emergencyContactName; }
    public void setEmergencyContactName(String emergencyContactName) { this.emergencyContactName = emergencyContactName; }

    public String getEmergencyContactPhone() { return emergencyContactPhone; }
    public void setEmergencyContactPhone(String emergencyContactPhone) { this.emergencyContactPhone = emergencyContactPhone; }

    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }

    public String getAllergies() { return allergies; }
    public void setAllergies(String allergies) { this.allergies = allergies; }

    public String getMedicalHistory() { return medicalHistory; }
    public void setMedicalHistory(String medicalHistory) { this.medicalHistory = medicalHistory; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
EOF

# Create Patient Repository
cat > backend/patient-service/src/main/java/com/hospital/patient/repository/PatientRepository.java << 'EOF'
package com.hospital.patient.repository;

import com.hospital.patient.entity.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PatientRepository extends JpaRepository<Patient, Long> {
    Optional<Patient> findByPatientId(String patientId);
    List<Patient> findByIsActiveTrue();
    
    @Query("SELECT p FROM Patient p WHERE LOWER(p.firstName) LIKE LOWER(CONCAT('%', :name, '%')) " +
           "OR LOWER(p.lastName) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Patient> findByNameContaining(@Param("name") String name);
    
    List<Patient> findByPhone(String phone);
    List<Patient> findByEmail(String email);
}
EOF

# Create Patient Controller
cat > backend/patient-service/src/main/java/com/hospital/patient/controller/PatientController.java << 'EOF'
package com.hospital.patient.controller;

import com.hospital.patient.entity.Patient;
import com.hospital.patient.repository.PatientRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/patients")
@Tag(name = "Patient Management", description = "Patient management APIs")
@CrossOrigin(origins = "*", maxAge = 3600)
public class PatientController {

    @Autowired
    private PatientRepository patientRepository;

    @GetMapping
    @Operation(summary = "Get all patients")
    public List<Patient> getAllPatients() {
        return patientRepository.findByIsActiveTrue();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get patient by ID")
    public ResponseEntity<Patient> getPatientById(@PathVariable Long id) {
        Optional<Patient> patient = patientRepository.findById(id);
        return patient.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @Operation(summary = "Create new patient")
    public Patient createPatient(@Valid @RequestBody Patient patient) {
        return patientRepository.save(patient);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update patient")
    public ResponseEntity<Patient> updatePatient(@PathVariable Long id, @Valid @RequestBody Patient patientDetails) {
        Optional<Patient> optionalPatient = patientRepository.findById(id);
        if (optionalPatient.isPresent()) {
            Patient patient = optionalPatient.get();
            // Update fields
            patient.setFirstName(patientDetails.getFirstName());
            patient.setLastName(patientDetails.getLastName());
            patient.setDateOfBirth(patientDetails.getDateOfBirth());
            patient.setGender(patientDetails.getGender());
            patient.setPhone(patientDetails.getPhone());
            patient.setEmail(patientDetails.getEmail());
            patient.setAddress(patientDetails.getAddress());
            patient.setEmergencyContactName(patientDetails.getEmergencyContactName());
            patient.setEmergencyContactPhone(patientDetails.getEmergencyContactPhone());
            patient.setBloodGroup(patientDetails.getBloodGroup());
            patient.setAllergies(patientDetails.getAllergies());
            patient.setMedicalHistory(patientDetails.getMedicalHistory());
            
            return ResponseEntity.ok(patientRepository.save(patient));
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete patient")
    public ResponseEntity<?> deletePatient(@PathVariable Long id) {
        Optional<Patient> patient = patientRepository.findById(id);
        if (patient.isPresent()) {
            Patient p = patient.get();
            p.setIsActive(false);
            patientRepository.save(p);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/search")
    @Operation(summary = "Search patients by name")
    public List<Patient> searchPatients(@RequestParam String name) {
        return patientRepository.findByNameContaining(name);
    }
}
EOF

# Create application.yml for Patient Service
cat > backend/patient-service/src/main/resources/application.yml << 'EOF'
server:
  port: 8082

spring:
  application:
    name: patient-service
  datasource:
    url: jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME:hospital_db}
    username: ${DB_USERNAME:hospital_user}
    password: ${DB_PASSWORD:hospital_password}
    driver-class-name: org.postgresql.Driver
  jpa:
    hibernate:
      ddl-auto: none
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect

management:
  endpoints:
    web:
      exposure:
        include: health,info

springdoc:
  api-docs:
    path: /api-docs
  swagger-ui:
    path: /swagger-ui.html
EOF

# Create Dockerfile for Patient Service
cat > backend/patient-service/Dockerfile << 'EOF'
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

EXPOSE 8082

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8082/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

echo "Patient Service setup completed!"

# Create similar structure for other services
echo "Creating Appointment Service..."

cat > backend/appointment-service/src/main/java/com/hospital/appointment/AppointmentServiceApplication.java << 'EOF'
package com.hospital.appointment;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AppointmentServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(AppointmentServiceApplication.class, args);
    }
}
EOF

cat > backend/appointment-service/src/main/resources/application.yml << 'EOF'
server:
  port: 8083

spring:
  application:
    name: appointment-service
  datasource:
    url: jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME:hospital_db}
    username: ${DB_USERNAME:hospital_user}
    password: ${DB_PASSWORD:hospital_password}
    driver-class-name: org.postgresql.Driver
  jpa:
    hibernate:
      ddl-auto: none
    show-sql: true

management:
  endpoints:
    web:
      exposure:
        include: health,info

springdoc:
  api-docs:
    path: /api-docs
  swagger-ui:
    path: /swagger-ui.html
EOF

cat > backend/appointment-service/Dockerfile << 'EOF'
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
EXPOSE 8083
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8083/actuator/health || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

echo "Setting up Department and Medical services..."

# Copy similar structure for department and medical services
for service in department-service medical-service; do
    port=$((8084))
    if [ "$service" = "medical-service" ]; then
        port=8085
    fi
    
    service_name=$(echo $service | sed 's/-service//')
    cap_service_name=$(echo $service_name | sed 's/.*/\u&/')
    
    cat > backend/$service/src/main/java/com/hospital/$service_name/${cap_service_name}ServiceApplication.java << EOF
package com.hospital.$service_name;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ${cap_service_name}ServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(${cap_service_name}ServiceApplication.class, args);
    }
}
EOF

    cat > backend/$service/src/main/resources/application.yml << EOF
server:
  port: $port

spring:
  application:
    name: $service
  datasource:
    url: jdbc:postgresql://\${DB_HOST:localhost}:\${DB_PORT:5432}/\${DB_NAME:hospital_db}
    username: \${DB_USERNAME:hospital_user}
    password: \${DB_PASSWORD:hospital_password}
    driver-class-name: org.postgresql.Driver
  jpa:
    hibernate:
      ddl-auto: none
    show-sql: true

management:
  endpoints:
    web:
      exposure:
        include: health,info

springdoc:
  api-docs:
    path: /api-docs
  swagger-ui:
    path: /swagger-ui.html
EOF

    cat > backend/$service/Dockerfile << EOF
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
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \\
    CMD curl -f http://localhost:$port/actuator/health || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF
done

echo "All microservices setup completed!"