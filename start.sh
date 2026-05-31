#!/bin/bash
# Build and start the FYP application with Docker Compose

set -e

echo "🔨 Building Docker image..."
docker build -t fyp-api:latest -f Dockerfile .

echo ""
echo "📦 Starting services with Docker Compose..."
docker compose up -d

echo ""
echo "⏳ Waiting for services to be healthy..."
sleep 10

echo ""
echo "✅ Services started successfully!"
echo ""
echo "📋 Service Status:"
docker compose ps

echo ""
echo "🔗 API Access:"
echo "   - API: http://localhost:8000"
echo "   - Swagger Docs: http://localhost:8000/api/docs"
echo "   - ReDoc: http://localhost:8000/api/redoc"
echo "   - Health Check: http://localhost:8000/api/health"
echo ""
echo "🗄️ Database:"
echo "   - Host: localhost"
echo "   - Port: 5432"
echo "   - User: fyp_user"
echo "   - Password: fyp_password"
echo "   - Database: fyp_db"
echo ""
echo "💾 Redis:"
echo "   - Host: localhost"
echo "   - Port: 6379"
echo ""
echo "📋 Useful Commands:"
echo "   - View logs: docker compose logs -f api"
echo "   - Stop services: docker compose down"
echo "   - Stop and remove volumes: docker compose down -v"
echo "   - Rebuild: docker compose build --no-cache"
