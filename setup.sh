#!/bin/bash

# Script de setup inicial do Avila Portal

set -e

echo "?? Avila Portal - Setup Inicial"
echo "================================"
echo ""

# Verificar Rust
if ! command -v cargo &> /dev/null; then
    echo "? Rust não encontrado. Instalando..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
else
    echo "? Rust encontrado: $(rustc --version)"
fi

# Adicionar target WASM
echo ""
echo "?? Adicionando target wasm32-unknown-unknown..."
rustup target add wasm32-unknown-unknown

# Instalar Trunk
if ! command -v trunk &> /dev/null; then
    echo ""
    echo "?? Instalando Trunk..."
    cargo install trunk
else
    echo "? Trunk já instalado"
fi

# Instalar SQLx CLI
if ! command -v sqlx &> /dev/null; then
    echo ""
    echo "?? Instalando SQLx CLI..."
    cargo install sqlx-cli --features postgres
else
    echo "? SQLx CLI já instalado"
fi

# Setup PostgreSQL
echo ""
echo "???  Configurando PostgreSQL..."
if command -v createdb &> /dev/null; then
    createdb avila_portal 2>/dev/null || echo "Database já existe"
else
    echo "??  PostgreSQL não encontrado. Configure manualmente ou use Docker:"
    echo "   docker-compose up -d postgres redis"
fi

# Copiar .env
echo ""
echo "??  Configurando variáveis de ambiente..."
if [ ! -f backend/.env ]; then
    cp backend/.env.example backend/.env
    echo "? Arquivo .env criado em backend/"
    echo "??  Configure as variáveis em backend/.env conforme necessário"
else
    echo "? Arquivo .env já existe"
fi

# Rodar migrações
echo ""
echo "?? Rodando migrações do banco..."
cd backend
sqlx migrate run || echo "??  Falha ao rodar migrações. Configure o DATABASE_URL em .env"
cd ..

echo ""
echo "? Setup concluído!"
echo ""
echo "?? Próximos passos:"
echo "   1. Configure backend/.env com suas credenciais"
echo "   2. Inicie o backend: cd backend && cargo run"
echo "   3. Em outro terminal, inicie o frontend: cd frontend && trunk serve"
echo ""
echo "?? O portal estará disponível em http://localhost:8080"
echo ""
