#!/bin/bash

# Health check script para monitoramento

API_URL="${1:-http://localhost:8080}"

echo "?? Avila Portal - Health Check"
echo "=============================="
echo "API: $API_URL"
echo ""

# Backend
echo "?? Backend..."
response=$(curl -s -w "\n%{http_code}" "$API_URL/api/health")
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n-1)

if [ "$http_code" = "200" ]; then
    echo "? Backend: OK"
    echo "$body" | jq -r '.status, .version, .database' 2>/dev/null || echo "$body"
else
    echo "? Backend: FAIL (HTTP $http_code)"
    exit 1
fi

echo ""

# Database
echo "???  Database..."
db_status=$(echo "$body" | jq -r '.database' 2>/dev/null)
if [ "$db_status" = "healthy" ]; then
    echo "? Database: OK"
else
    echo "? Database: FAIL"
    exit 1
fi

echo ""

# Frontend (verificar se carrega)
echo "?? Frontend..."
frontend_response=$(curl -s -o /dev/null -w "%{http_code}" "$API_URL")
if [ "$frontend_response" = "200" ]; then
    echo "? Frontend: OK"
else
    echo "? Frontend: FAIL (HTTP $frontend_response)"
    exit 1
fi

echo ""
echo "? Todos os serviços: OK"
exit 0
