# ?? INÍCIO RÁPIDO - Avila Portal

## Setup em 3 Passos

### 1?? Adicionar Target WASM
```powershell
rustup target add wasm32-unknown-unknown
```

### 2?? Instalar Ferramentas
```powershell
cargo install trunk
cargo install sqlx-cli --features postgres
```

### 3?? Configurar Ambiente
```powershell
Copy-Item backend\.env.example backend\.env
```

## ?? Rodar Localmente

### Opção A: Com Docker (Recomendado)
```powershell
# Iniciar PostgreSQL e Redis
docker-compose up -d postgres redis

# Terminal 1 - Backend
cd backend
cargo run

# Terminal 2 - Frontend
cd frontend
trunk serve --open
```

### Opção B: Tudo Manual
```powershell
# Instalar PostgreSQL e Redis localmente
# Configurar backend\.env com as credenciais

# Rodar migrações
cd backend
sqlx migrate run

# Terminal 1 - Backend
cargo run

# Terminal 2 - Frontend
cd ..\frontend
trunk serve --open
```

## ?? Acessar

- **Portal**: http://localhost:8080
- **API**: http://localhost:8080/api
- **Health**: http://localhost:8080/api/health

## ?? Comandos Úteis

```powershell
# Build completo
cargo build --release

# Testes
cargo test --all

# Limpar
cargo clean

# Ver logs
$env:RUST_LOG="debug"; cargo run

# Docker completo
docker-compose up --build
```

## ?? Verificar Status

```powershell
# Health check
curl http://localhost:8080/api/health

# Produtos
curl http://localhost:8080/api/products
```

## ?? Troubleshooting

### Erro: "DATABASE_URL not found"
? Configure backend\.env com URL do PostgreSQL

### Erro: "connection refused"
? Inicie PostgreSQL e Redis primeiro

### Erro: "trunk not found"
? Execute: `cargo install trunk`

### Erro: WASM não compila
? Execute: `rustup target add wasm32-unknown-unknown`

## ?? Primeiro Login

1. Acesse http://localhost:8080
2. Clique em "Portal do Cliente"
3. Clique em "Registre-se"
4. Crie sua conta
5. Seja redirecionado para o Dashboard

Pronto! ??
