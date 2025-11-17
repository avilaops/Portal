# Avila Portal - Arquitetura Técnica

## Visão Geral

Portal unificado 100% Rust + WebAssembly para centralizar todos os produtos Avila Inc.

## Stack

### Backend
- **Linguagem**: Rust 1.75+
- **Framework**: Actix-web 4.9
- **Database**: PostgreSQL 16
- **Cache**: Redis 7
- **Auth**: JWT + bcrypt

### Frontend
- **Linguagem**: Rust
- **Framework**: Yew 0.21 (React-like)
- **Target**: WebAssembly (wasm32-unknown-unknown)
- **Build**: Trunk
- **Router**: Yew Router 0.18

## Estrutura de Diretórios

```
portal/
??? backend/
?   ??? src/
?   ?   ??? main.rs              # Entry point
?   ?   ??? config.rs            # Configurações
?   ?   ??? error.rs             # Error handling
?   ?   ??? models.rs            # Database models
?   ?   ??? auth.rs              # Auth service
?   ?   ??? handlers/            # HTTP handlers
?   ?   ??? middleware/          # Middlewares
?   ?   ??? services/            # Business logic
?   ??? migrations/              # SQL migrations
?   ??? Cargo.toml
??? frontend/
?   ??? src/
?   ?   ??? main.rs              # Entry point
?   ?   ??? pages/               # Page components
?   ?   ??? components/          # Reusable components
?   ?   ??? services/            # API client
?   ?   ??? hooks/               # Custom hooks
?   ?   ??? utils/               # Utilities
?   ??? index.html
?   ??? Cargo.toml
??? shared/
?   ??? src/
?       ??? lib.rs               # Tipos compartilhados
??? static/
    ??? index.html               # HTML principal
    ??? styles/
        ??? main.css             # Design system
```

## Fluxo de Dados

```
[Usuário] 
    ?
[Frontend WASM]
    ? HTTP/JSON
[Backend API]
    ?
[PostgreSQL + Redis]
```

## Autenticação

1. Usuário faz login com email/senha
2. Backend valida e gera JWT token
3. Token armazenado no localStorage
4. Todas requests incluem header `Authorization: Bearer <token>`
5. Backend valida token em cada request protegida

## Database Schema

### users
- id (UUID)
- email (VARCHAR, unique)
- password_hash (VARCHAR)
- name (VARCHAR)
- company (VARCHAR, nullable)
- role (VARCHAR)
- created_at, updated_at (TIMESTAMPTZ)

### products
- id (VARCHAR)
- name (VARCHAR)
- description (TEXT)
- url (VARCHAR)
- status (VARCHAR)
- icon (VARCHAR)
- category (VARCHAR)
- created_at (TIMESTAMPTZ)

### product_features
- id (UUID)
- product_id (VARCHAR, FK)
- feature (TEXT)
- created_at (TIMESTAMPTZ)

### activities
- id (UUID)
- user_id (UUID, FK)
- action (VARCHAR)
- resource (VARCHAR)
- timestamp (TIMESTAMPTZ)
- ip_address (VARCHAR, nullable)

## API Endpoints

### Públicos
- `POST /api/auth/login` - Login
- `POST /api/auth/register` - Registro
- `GET /api/health` - Health check

### Protegidos (requer JWT)
- `GET /api/auth/me` - Dados do usuário
- `GET /api/products` - Lista produtos
- `GET /api/products/{id}` - Produto específico
- `GET /api/dashboard/metrics` - Métricas do dashboard

## Design System

### Cores
- Primary: #00d4ff (cyan)
- Secondary: #7c3aed (purple)
- Background: #0a0e27 (dark blue)
- Success: #10b981
- Error: #ef4444

### Tipografia
- Primary: Inter
- Mono: JetBrains Mono

### Componentes
- Navbar com backdrop blur
- Cards com glass morphism
- Gradientes animados
- Sombras com glow effect
- Transições suaves (250ms)

## Performance

### Frontend (WASM)
- Tamanho: ~200KB (gzipped)
- Carregamento: <1s
- Renderização: 60fps

### Backend
- Latência: <50ms
- Throughput: >1000 req/s
- Concorrência: Async/await

## Segurança

- HTTPS obrigatório em produção
- JWT com expiração de 24h
- Senhas hasheadas com bcrypt (cost 12)
- CORS configurado
- SQL injection protection (SQLx)
- XSS protection (Yew sanitiza)
- Rate limiting (futuro)

## Deploy

### Docker
```bash
docker-compose up --build
```

### Manual
```bash
# Backend
cd backend && cargo build --release

# Frontend
cd frontend && trunk build --release
```

## Monitoramento

- Health check em `/api/health`
- Logs estruturados (env_logger)
- Métricas (futuro: Prometheus)
- Tracing (futuro: OpenTelemetry)

## Roadmap

### Phase 1 (Atual)
- ? Autenticação JWT
- ? Dashboard básico
- ? Lista de produtos
- ? Design system

### Phase 2
- SSO com Azure AD
- Integração com produtos
- Métricas em tempo real
- Notificações

### Phase 3
- Multi-tenant
- Roles avançadas
- Analytics
- API Gateway

## Desenvolvimento

### Setup
```bash
make setup
```

### Run
```bash
# Terminal 1
cd backend && cargo run

# Terminal 2
cd frontend && trunk serve
```

### Test
```bash
cargo test --all
```

### Build
```bash
make build
```

## Produtos Integrados

1. **Avila Vault** - Secrets management
2. **Avila Pulse** - Telemetria executiva
3. **On Platform** - Multi-Agent AI
4. **Darwin** - Self-healing
5. **AgentHub** - Orquestração IA
6. **Camacho** - Cardápios IA
7. **Geolocation AI** - Geoespacial
8. **Barbara WebGL** - Plataforma 3D
9. **MRG** - Logística
10. **Reports** - Automação de relatórios
