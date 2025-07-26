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
                // User Service Routes
                .route("user-service", r -> r.path("/api/auth/**", "/api/users/**")
                        .uri("${USER_SERVICE_URL:http://localhost:8081}"))
                
                // Patient Service Routes
                .route("patient-service", r -> r.path("/api/patients/**")
                        .uri("${PATIENT_SERVICE_URL:http://localhost:8082}"))
                
                // Appointment Service Routes
                .route("appointment-service", r -> r.path("/api/appointments/**")
                        .uri("${APPOINTMENT_SERVICE_URL:http://localhost:8083}"))
                
                // Department Service Routes
                .route("department-service", r -> r.path("/api/departments/**", "/api/beds/**")
                        .uri("${DEPARTMENT_SERVICE_URL:http://localhost:8084}"))
                
                // Medical Service Routes
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