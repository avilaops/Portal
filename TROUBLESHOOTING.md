# ?? Troubleshooting - Avila Portal

Guia de resolução de problemas comuns.

---

## ?? Problemas de Rust/Cargo

### ? "cargo: command not found"
**Causa**: Rust não instalado ou não no PATH

**Solução**:
```bash
# Instalar Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Windows: baixar de https://rustup.rs/

# Adicionar ao PATH (reiniciar terminal depois)
source $HOME/.cargo/env
```

### ? "error: linker 'cc' not found"
**Causa**: Build tools não instalados

**Solução**:
```bash
# Ubuntu/Debian
sudo apt install build-essential

# macOS
xcode-select --install

# Windows
# Instalar Visual Studio Build Tools
```

### ? "failed to resolve: use of undeclared crate"
**Causa**: Dependência não baixada

**Solução**:
```bash
cargo clean
cargo build
```

---

## ?? Problemas de WASM/Frontend

### ? "trunk: command not found"
**Solução**:
```bash
cargo install trunk
```

### ? "error: target 'wasm32-unknown-unknown' not found"
**Solução**:
```bash
rustup target add wasm32-unknown-unknown
```

### ? Frontend não carrega (página em branco)
**Diagnóstico**:
```bash
# Verificar console do browser (F12)
# Procurar por erros de WASM ou JS
```

**Soluções**:
```bash
# 1. Rebuild
cd frontend
trunk clean
trunk build --release

# 2. Clear cache do browser
# Ctrl+Shift+Delete

# 3. Verificar se backend está rodando
curl http://localhost:8080/api/health
```

### ? "Module not found" no WASM
**Causa**: Path incorreto no Trunk.toml

**Solução**: Verificar `frontend/Trunk.toml` e paths dos assets

---

## ??? Problemas de Database

### ? "connection refused" (PostgreSQL)
**Causa**: PostgreSQL não está rodando

**Solução**:
```bash
# Docker
docker-compose up -d postgres

# Linux
sudo systemctl start postgresql

# macOS
brew services start postgresql

# Windows
# Iniciar pelo Services.msc
```

### ? "password authentication failed"
**Causa**: Senha incorreta em .env

**Solução**:
```bash
# Verificar DATABASE_URL em backend/.env
# Formato: postgres://user:password@host:port/database

# Resetar senha PostgreSQL se necessário
# psql -U postgres -c "ALTER USER postgres PASSWORD 'newpass';"
```

### ? "database does not exist"
**Solução**:
```bash
# Criar database
createdb avila_portal

# Ou via SQL
psql -U postgres -c "CREATE DATABASE avila_portal;"
```

### ? "sqlx migrate run" falha
**Diagnóstico**:
```bash
# Verificar conexão
psql $DATABASE_URL -c "SELECT 1;"

# Verificar migrations
ls backend/migrations/
```

**Solução**:
```bash
# Re-run migrations
cd backend
sqlx migrate run

# Se persistir, reset database
dropdb avila_portal
createdb avila_portal
sqlx migrate run
```

---

## ?? Problemas de Redis

### ? "connection refused" (Redis)
**Solução**:
```bash
# Docker
docker-compose up -d redis

# Linux
sudo systemctl start redis

# macOS
brew services start redis

# Windows
# Usar Docker ou WSL
```

### ? Redis crasheia
**Causa**: Falta de memória

**Solução**:
```bash
# Aumentar maxmemory no redis.conf
# ou limpar cache
redis-cli FLUSHALL
```

---

## ?? Problemas de Docker

### ? "Cannot connect to Docker daemon"
**Solução**:
```bash
# Linux
sudo systemctl start docker

# macOS/Windows
# Iniciar Docker Desktop
```

### ? "port already allocated"
**Causa**: Porta 8080, 5432 ou 6379 em uso

**Solução**:
```bash
# Descobrir processo
# Windows
netstat -ano | findstr :8080

# Linux/Mac
lsof -i :8080

# Matar processo ou mudar porta em docker-compose.yml
```

### ? Docker build muito lento
**Solução**:
```bash
# Usar cache do BuildKit
DOCKER_BUILDKIT=1 docker build -t portal .

# Ou multi-stage build (já configurado no Dockerfile)
```

---

## ?? Problemas de Autenticação

### ? "Invalid token" ao fazer request
**Causa**: Token expirado ou inválido

**Solução**:
```bash
# Fazer login novamente
# Token JWT expira em 24h por padrão

# Ou verificar JWT_SECRET no .env
# Backend e frontend devem usar o mesmo secret
```

### ? Login não funciona
**Diagnóstico**:
```bash
# Verificar logs do backend
RUST_LOG=debug cargo run

# Verificar se usuário existe no banco
psql avila_portal -c "SELECT * FROM users WHERE email = 'seu@email.com';"
```

**Solução**:
```bash
# Criar novo usuário via API
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test123","name":"Test"}'
```

---

## ?? Problemas de Build

### ? "failed to compile"
**Diagnóstico**:
```bash
# Build verbose
cargo build --verbose

# Check específico
cargo check --workspace
```

**Soluções Comuns**:
```bash
# 1. Update Rust
rustup update

# 2. Clean + rebuild
cargo clean
cargo build

# 3. Update dependencies
cargo update
```

### ? Build muito lento
**Solução**:
```bash
# Usar linker mais rápido (Linux)
sudo apt install lld clang
# Adicionar em ~/.cargo/config.toml:
# [target.x86_64-unknown-linux-gnu]
# linker = "clang"
# rustflags = ["-C", "link-arg=-fuse-ld=lld"]

# Build incremental
cargo build --incremental
```

---

## ?? Problemas de Rede/API

### ? CORS error no frontend
**Causa**: CORS mal configurado

**Solução**: Verificar `backend/src/main.rs`:
```rust
let cors = Cors::default()
    .allowed_origin("http://localhost:8080") // Deve ser URL do frontend
    .allowed_methods(vec!["GET", "POST", "PUT", "DELETE"])
    // ...
```

### ? "Failed to fetch" no frontend
**Diagnóstico**:
```bash
# Verificar se backend está rodando
curl http://localhost:8080/api/health

# Verificar logs do browser (F12 ? Network)
```

**Solução**:
```bash
# Garantir que backend está na porta 8080
# Verificar FRONTEND_URL em backend/.env
```

### ? 500 Internal Server Error
**Diagnóstico**:
```bash
# Verificar logs do backend
# RUST_LOG=debug cargo run

# Verificar stack trace no terminal do backend
```

---

## ?? Problemas de Performance

### ? Backend lento (>100ms)
**Diagnóstico**:
```bash
# Logs com timing
RUST_LOG=debug cargo run

# Check database queries
# Adicionar logs em handlers
```

**Soluções**:
```sql
-- Adicionar índices
CREATE INDEX IF NOT EXISTS idx_name ON table(column);

-- Otimizar queries
EXPLAIN ANALYZE SELECT ...;
```

### ? Frontend lento para carregar
**Diagnóstico**:
```bash
# Build size
ls -lh frontend/dist/*.wasm

# Lighthouse audit (F12 ? Lighthouse)
```

**Soluções**:
```bash
# Otimizar bundle
cd frontend
trunk build --release

# Verificar que profile.release está em Cargo.toml
# opt-level = 'z'
# lto = true
```

---

## ?? Debug Avançado

### Backend
```bash
# Logs detalhados
RUST_LOG=trace cargo run

# Debugger (VSCode)
# Use F5 com .vscode/launch.json configurado

# Profiling
cargo install flamegraph
cargo flamegraph
```

### Frontend
```bash
# Console logs
# wasm_logger::init() já está configurado
# Usar log::info!(), log::error!(), etc

# Browser DevTools
# F12 ? Console para ver logs
# F12 ? Network para ver requests
# F12 ? Application ? Local Storage para ver tokens
```

### Database
```sql
-- Query lenta
EXPLAIN ANALYZE SELECT ...;

-- Locks
SELECT * FROM pg_locks;

-- Conexões ativas
SELECT * FROM pg_stat_activity;
```

---

## ?? Quando Tudo Falhar

### Reset Completo
```bash
# Windows
.\reset.bat

# Linux/Mac
./reset.sh

# Ou manual:
cargo clean
rm -rf frontend/dist
dropdb avila_portal
createdb avila_portal
cd backend && sqlx migrate run
```

### Pedir Ajuda
1. **GitHub Issues**: https://github.com/avilaops/portal/issues
2. **Email**: contato@avila.inc
3. **Docs**: Ler DEVELOPMENT.md e ARCHITECTURE.md

### Informações Úteis ao Reportar
- Versão Rust: `rustc --version`
- Sistema operacional
- Mensagem de erro completa
- Passos para reproduzir
- Logs relevantes

---

## ?? Resources

- [Rust Book](https://doc.rust-lang.org/book/)
- [Actix Web Docs](https://actix.rs/docs/)
- [Yew Docs](https://yew.rs/docs/getting-started/introduction)
- [SQLx Docs](https://docs.rs/sqlx/)
- [WASM Book](https://rustwasm.github.io/book/)

---

**Não encontrou sua solução?**  
Abra uma [issue](https://github.com/avilaops/portal/issues/new) ou envie email para contato@avila.inc
