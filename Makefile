.PHONY: help setup dev build test clean docker

help:
	@echo "Avila Portal - Comandos Disponíveis"
	@echo "===================================="
	@echo ""
	@echo "  make setup      - Setup inicial do projeto"
	@echo "  make dev        - Rodar em modo desenvolvimento"
	@echo "  make build      - Build para produção"
	@echo "  make test       - Rodar testes"
	@echo "  make clean      - Limpar artifacts de build"
	@echo "  make docker     - Build e rodar com Docker"
	@echo "  make migrate    - Rodar migrações do banco"
	@echo ""

setup:
	@echo "?? Setup inicial..."
	rustup target add wasm32-unknown-unknown
	cargo install trunk
	cargo install sqlx-cli --features postgres
	cp backend/.env.example backend/.env || true
	@echo "? Setup concluído!"

dev:
	@echo "?? Iniciando modo desenvolvimento..."
	@echo "Certifique-se de que PostgreSQL e Redis estão rodando"
	@echo ""
	@echo "Terminal 1: Backend"
	@echo "cd backend && cargo run"
	@echo ""
	@echo "Terminal 2: Frontend"
	@echo "cd frontend && trunk serve --open"

build:
	@echo "?? Building backend..."
	cd backend && cargo build --release
	@echo "?? Building frontend..."
	cd frontend && trunk build --release
	@echo "? Build concluído!"

test:
	@echo "?? Rodando testes..."
	cargo test --all

clean:
	@echo "?? Limpando artifacts..."
	cargo clean
	rm -rf frontend/dist
	@echo "? Limpeza concluída!"

docker:
	@echo "?? Building e rodando com Docker..."
	docker-compose up --build

migrate:
	@echo "?? Rodando migrações..."
	cd backend && sqlx migrate run
	@echo "? Migrações concluídas!"

dev-backend:
	@echo "?? Rodando backend..."
	cd backend && cargo watch -x run

dev-frontend:
	@echo "?? Rodando frontend..."
	cd frontend && trunk serve --open

install-dev-tools:
	@echo "?? Instalando ferramentas de desenvolvimento..."
	cargo install cargo-watch
	cargo install trunk
	cargo install sqlx-cli --features postgres
	@echo "? Ferramentas instaladas!"
