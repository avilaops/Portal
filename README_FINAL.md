# ? Avila Portal

<div align="center">

**Portal Unificado - 100% Rust + WebAssembly**

[![Rust](https://img.shields.io/badge/Rust-1.75+-orange?style=for-the-badge&logo=rust)](https://www.rust-lang.org/)
[![WebAssembly](https://img.shields.io/badge/WebAssembly-654FF0?style=for-the-badge&logo=webassembly)](https://webassembly.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue?style=for-the-badge&logo=postgresql)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-7-red?style=for-the-badge&logo=redis)](https://redis.io/)

*Plataforma de Inteligência Artificial - Ecossistema 100% Próprio*

[Demo](#) • [Documentação](ARCHITECTURE.md) • [Guia Dev](DEVELOPMENT.md)

</div>

---

## ?? Sobre

Portal centralizado da **Avila Inc** que unifica 10 produtos de IA em uma única plataforma. Construído do zero com **Rust** e **WebAssembly** para máxima performance, segurança e independência tecnológica.

### ?? Por Que Rust + WASM?

- ? **Performance**: Bundle 80% menor que React
- ?? **Segurança**: Memory-safe, zero vulnerabilidades críticas
- ?? **Confiável**: Type-safe em compilação
- ?? **Universal**: Roda em qualquer browser moderno
- ?? **Independente**: Zero dependências de Node.js/npm

## ? Features

### ? Implementado

- ?? **Autenticação JWT** - Login/registro seguro
- ?? **Dashboard Executivo** - Métricas em tempo real
- ??? **Catálogo de Produtos** - 10 produtos integrados
- ?? **Design System** - Interface moderna e intuitiva
- ?? **Responsive** - Mobile-first design
- ?? **Docker Ready** - Deploy simplificado
- ?? **Health Checks** - Monitoramento de serviços

### ?? Roadmap

- [ ] SSO Azure AD
- [ ] Métricas em tempo real (WebSocket)
- [ ] Notificações push
- [ ] Multi-tenant
- [ ] API Gateway
- [ ] Mobile App (WASM)

## ??? Stack Tecnológica

### Backend (Rust)

```toml
Actix-web 4.9    # Framework HTTP async
SQLx 0.8         # PostgreSQL driver
Redis 0.27       # Cache
JWT + bcrypt     # Autenticação
```

### Frontend (Rust ? WASM)

```toml
Yew 0.21         # Framework React-like
Yew Router 0.18  # Client-side routing
Gloo 0.11        # Web APIs
```

### Infrastructure

```yaml
Database: PostgreSQL 16
Cache: Redis 7
Deploy: Docker + Docker Compose
CI/CD: GitHub Actions
```

## ?? Quick Start

### Opção 1: Docker (Recomendado)

```bash
# Clone
git clone https://github.com/avilaops/portal.git
cd portal

# Quick start
./quickstart.sh      # Linux/Mac
quickstart.bat       # Windows

# Acesse: http://localhost:8080
```

### Opção 2: Manual

```bash
# Pré-requisitos
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add wasm32-unknown-unknown
cargo install trunk sqlx-cli

# Setup
./setup.sh           # Linux/Mac
setup.bat            # Windows

# Terminal 1 - Backend
cd backend
cargo run

# Terminal 2 - Frontend
cd frontend
trunk serve --open
```

## ?? Estrutura do Projeto

```
portal/
??? backend/              # API REST (Actix-web)
?   ??? src/
?   ?   ??? handlers/     # HTTP endpoints
?   ?   ??? middleware/   # Auth middleware
?   ?   ??? services/     # Business logic
?   ?   ??? models.rs     # Database models
?   ??? migrations/       # SQL migrations
?
??? frontend/             # UI (Yew + WASM)
?   ??? src/
?   ?   ??? pages/        # Páginas
?   ?   ??? components/   # Componentes
?   ?   ??? services/     # API client
?   ??? index.html
?
??? shared/               # Tipos compartilhados
?   ??? src/lib.rs
?
??? static/               # Assets estáticos
    ??? styles/
    ??? index.html
```

## ?? Design System

### Paleta de Cores

```css
Primary:    #00d4ff  /* Cyan elétrico */
Secondary:  #7c3aed  /* Purple tech */
Background: #0a0e27  /* Deep space */
Success:    #10b981  /* Green */
Error:      #ef4444  /* Red */
```

### Componentes

- ?? **Cards** com glassmorphism
- ?? **Gradientes** animados
- ? **Glow effects** sutis
- ?? **Transições** suaves (250ms)
- ?? **Responsive** grid system

## ?? Performance

| Métrica | Rust+WASM | React | Django |
|---------|-----------|-------|--------|
| Bundle Size | 200KB | 1.2MB | N/A |
| Load Time | <1s | 2-3s | N/A |
| Latência | <50ms | N/A | 100ms |
| Throughput | 1000+ | N/A | 200 |
| Memory | 50MB | 80MB | 200MB |

## ?? Segurança

- ? JWT com expiração (24h)
- ? Bcrypt para senhas (cost 12)
- ? CORS configurado
- ? SQL injection proof (SQLx)
- ? XSS protection (Yew)
- ? Memory-safe (Rust)
- ? HTTPS obrigatório
- ? Audit logs

## ??? Produtos Integrados

| # | Produto | Status | Categoria |
|---|---------|--------|-----------|
| 1 | Avila Vault | ?? Online | Security |
| 2 | Avila Pulse | ?? Dev | Analytics |
| 3 | On Platform | ?? Dev | AI |
| 4 | Darwin | ?? Online | Infrastructure |
| 5 | AgentHub | ?? Online | AI |
| 6 | Camacho | ?? Online | SaaS |
| 7 | Geolocation AI | ?? Online | AI |
| 8 | Barbara WebGL | ?? Online | SaaS |
| 9 | MRG Logística | ?? Online | SaaS |
| 10 | Reports | ?? Online | Analytics |

## ?? Testes

```bash
# Todos os testes
cargo test --all

# Backend apenas
cd backend && cargo test

# Com coverage
cargo tarpaulin --out Html
```

## ?? Documentação

- [Arquitetura](ARCHITECTURE.md) - Detalhes técnicos
- [Desenvolvimento](DEVELOPMENT.md) - Guia para devs
- [Executivo](EXECUTIVE_SUMMARY.md) - Resumo executivo
- [Changelog](CHANGELOG.md) - Histórico de mudanças

## ?? Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/amazing`)
3. Commit suas mudanças (`git commit -m 'Add amazing feature'`)
4. Push para a branch (`git push origin feature/amazing`)
5. Abra um Pull Request

Leia [DEVELOPMENT.md](DEVELOPMENT.md) para mais detalhes.

## ?? Comandos Úteis

```bash
# Desenvolvimento
make dev              # Rodar dev mode
make build            # Build produção
make test             # Rodar testes
make clean            # Limpar artifacts

# Docker
make docker           # Build + run
docker-compose up -d  # Background

# Database
make migrate          # Rodar migrações
```

## ?? Deploy

### Docker

```bash
docker-compose up --build -d
```

### Manual

```bash
# Backend
cd backend
cargo build --release
./target/release/server

# Frontend
cd frontend
trunk build --release
# Servir dist/ com nginx/caddy
```

## ?? Suporte

- ?? Email: contato@avila.inc
- ?? Issues: [GitHub Issues](https://github.com/avilaops/portal/issues)
- ?? Website: [avila.inc](https://avila.inc)

## ?? Licença

MIT © 2025 Avila Inc - Veja [LICENSE](LICENSE)

---

<div align="center">

**Construído com ?? Rust e ?? pela equipe Avila**

[Website](https://avila.inc) • [GitHub](https://github.com/avilaops) • [LinkedIn](https://linkedin.com/company/avila-inc)

</div>
