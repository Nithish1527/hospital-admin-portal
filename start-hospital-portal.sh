#!/bin/bash

echo "🏥 Starting Hospital Admin Portal..."
echo "======================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Stop any existing containers
echo "🛑 Stopping any existing containers..."
docker-compose down

# Build and start all services
echo "🚀 Building and starting all services..."
echo "This may take a few minutes on first run..."
docker-compose up --build -d

# Wait for services to be healthy
echo "⏳ Waiting for services to start..."
sleep 30

# Check service health
echo "🔍 Checking service health..."

services=(
    "postgres:5432"
    "api-gateway:8080"
    "user-service:8081"
    "patient-service:8082"
    "appointment-service:8083"
    "department-service:8084"
    "medical-service:8085"
    "frontend:3000"
)

for service in "${services[@]}"; do
    name=$(echo $service | cut -d: -f1)
    port=$(echo $service | cut -d: -f2)
    
    if docker-compose ps | grep -q "$name.*Up"; then
        echo "✅ $name is running"
    else
        echo "❌ $name is not running"
    fi
done

echo ""
echo "🎉 Hospital Admin Portal is starting up!"
echo "======================================"
echo ""
echo "📱 Frontend Application:"
echo "   URL: http://localhost:3000"
echo "   Login: admin / admin123"
echo ""
echo "🔌 API Gateway:"
echo "   URL: http://localhost:8080"
echo ""
echo "📚 API Documentation:"
echo "   User Service:        http://localhost:8081/swagger-ui.html"
echo "   Patient Service:     http://localhost:8082/swagger-ui.html"
echo "   Appointment Service: http://localhost:8083/swagger-ui.html"
echo "   Department Service:  http://localhost:8084/swagger-ui.html"
echo "   Medical Service:     http://localhost:8085/swagger-ui.html"
echo ""
echo "💾 Database:"
echo "   Host: localhost:5432"
echo "   Database: hospital_db"
echo "   Username: hospital_user"
echo ""
echo "📊 Useful Commands:"
echo "   View logs:           docker-compose logs -f"
echo "   Stop services:       docker-compose down"
echo "   Restart services:    docker-compose restart"
echo "   Check status:        docker-compose ps"
echo ""
echo "⚡ The application should be ready in about 2-3 minutes."
echo "   If you see any errors, check the logs with: docker-compose logs -f"