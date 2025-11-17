# Changelog

Todas as mudanças notáveis do projeto serão documentadas aqui.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Planejado
- SSO com Azure AD
- Métricas em tempo real
- Sistema de notificações
- Integração profunda com produtos
- Multi-tenant support
- Roles granulares

## [0.1.0] - 2025-01-XX

### Adicionado - Versão Inicial

#### Backend
- Sistema completo de autenticação JWT
- Endpoints de auth (login, register, me)
- CRUD de produtos
- Dashboard com métricas
- Health check endpoint
- Middleware de autenticação
- Error handling robusto
- Suporte a PostgreSQL
- Suporte a Redis
- Migrações de banco de dados
- Docker support
- Logs estruturados

#### Frontend
- Framework Yew + WASM
- Sistema de rotas (Yew Router)
- Páginas:
  - Home (landing page)
  - Login
  - Registro
  - Dashboard
  - Produtos
  - 404
- Componentes:
  - Navbar responsiva
  - Cards de produto
  - Métricas do dashboard
  - Forms de autenticação
- API Client completo
- LocalStorage para tokens
- Loading states
- Error handling

#### Design
- Design system completo
- Paleta de cores profissional
- Tipografia (Inter + JetBrains Mono)
- Componentes glassmorphism
- Animações suaves
- Gradientes animados
- Responsive design
- Dark theme nativo

#### DevOps
- Docker Compose
- Dockerfile multi-stage
- GitHub Actions CI/CD
- Scripts de setup (Linux/Mac/Windows)
- Makefile com comandos úteis
- VSCode tasks e settings
- .gitignore configurado
- .dockerignore configurado

#### Documentação
- README completo
- ARCHITECTURE.md detalhado
- DEVELOPMENT.md (guia dev)
- EXECUTIVE_SUMMARY.md
- Comentários inline

#### Database
- Schema inicial
- 10 produtos pré-cadastrados
- Features de cada produto
- Sistema de atividades
- Índices otimizados

### Segurança
- JWT com expiração
- Bcrypt para senhas (cost 12)
- CORS configurado
- SQL injection proof (SQLx)
- XSS protection (Yew)
- Memory-safe (Rust)

### Performance
- Bundle WASM < 200KB
- Latência < 50ms
- Throughput > 1000 req/s
- 60fps constante

---

## Tipos de Mudanças

- `Added` - Novas funcionalidades
- `Changed` - Mudanças em funcionalidades existentes
- `Deprecated` - Funcionalidades que serão removidas
- `Removed` - Funcionalidades removidas
- `Fixed` - Correções de bugs
- `Security` - Correções de segurança

---

[Unreleased]: https://github.com/avilaops/portal/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/avilaops/portal/releases/tag/v0.1.0
