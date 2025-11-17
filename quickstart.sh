#!/bin/bash

# Quick start com Docker - mais rápido para testar

echo "?? Avila Portal - Quick Start"
echo "=============================="
echo ""
echo "Iniciando com Docker Compose..."
echo ""

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "? Docker não encontrado. Instale: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "? Docker Compose não encontrado. Instale: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "? Docker encontrado"
echo ""

# Criar .env se não existir
if [ ! -f backend/.env ]; then
    echo "?? Criando arquivo .env..."
    cp backend/.env.example backend/.env
fi

# Iniciar serviços
echo "?? Iniciando PostgreSQL e Redis..."
docker-compose up -d postgres redis

echo ""
echo "? Aguardando serviços ficarem prontos..."
sleep 5

echo ""
echo "?? Rodando migrações..."
cd backend
sqlx migrate run 2>/dev/null || echo "??  Configure DATABASE_URL em .env"
cd ..

echo ""
echo "? Serviços prontos!"
echo ""
echo "?? Próximos passos:"
echo "   Terminal 1 - Backend:"
echo "   cd backend && cargo run"
echo ""
echo "   Terminal 2 - Frontend:"
echo "   cd frontend && trunk serve --open"
echo ""
echo "?? Portal: http://localhost:8080"
echo "?? PostgreSQL: localhost:5432"
echo "?? Redis: localhost:6379"
echo ""
