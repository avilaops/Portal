#!/bin/bash

# Script para resetar o ambiente de desenvolvimento

echo "?? Avila Portal - Reset Ambiente"
echo "================================"
echo ""
echo "??  ATENÇÃO: Este script irá:"
echo "   - Limpar todos os builds"
echo "   - Dropar e recriar o banco de dados"
echo "   - Limpar cache do Redis"
echo ""
read -p "Continuar? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "? Cancelado"
    exit 1
fi

echo ""
echo "?? Limpando builds..."
cargo clean
rm -rf frontend/dist

echo ""
echo "???  Resetando banco de dados..."
if command -v dropdb &> /dev/null; then
    dropdb avila_portal 2>/dev/null || true
    createdb avila_portal
    
    echo "?? Rodando migrações..."
    cd backend
    sqlx migrate run
    cd ..
    
    echo "? Banco resetado"
else
    echo "??  PostgreSQL CLI não encontrado"
    echo "   Resetar manualmente ou usar Docker:"
    echo "   docker-compose down -v"
    echo "   docker-compose up -d"
fi

echo ""
echo "?? Limpando Redis..."
if command -v redis-cli &> /dev/null; then
    redis-cli FLUSHALL
    echo "? Redis limpo"
else
    echo "??  Redis CLI não encontrado"
    echo "   Usar: docker-compose restart redis"
fi

echo ""
echo "? Reset concluído!"
echo ""
echo "?? Próximos passos:"
echo "   1. cd backend && cargo run"
echo "   2. cd frontend && trunk serve"
echo ""
