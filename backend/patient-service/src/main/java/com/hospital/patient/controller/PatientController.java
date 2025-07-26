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
