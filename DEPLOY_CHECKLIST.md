# ? Checklist de Deploy - Produção

## ?? Pré-Deploy

### Código
- [ ] Todos os testes passando (`cargo test --all`)
- [ ] Sem warnings do Clippy (`cargo clippy`)
- [ ] Código formatado (`cargo fmt`)
- [ ] Build de release funciona (`cargo build --release`)
- [ ] Frontend compila WASM (`trunk build --release`)
- [ ] Docker build funciona (`docker build -t portal .`)

### Configuração
- [ ] `.env.production` configurado corretamente
- [ ] `JWT_SECRET` gerado (forte, 64+ chars)
- [ ] URLs de produção configuradas
- [ ] CORS atualizado para domínio real
- [ ] SSL/TLS configurado

### Database
- [ ] Backup do banco atual
- [ ] Migrations testadas em staging
- [ ] Índices otimizados
- [ ] Connection pooling configurado
- [ ] Monitoramento de queries lentas ativo

### Segurança
- [ ] Secrets não estão no código
- [ ] `.env` no `.gitignore`
- [ ] Senhas fortes configuradas
- [ ] Rate limiting ativo
- [ ] HTTPS obrigatório
- [ ] Headers de segurança (HSTS, CSP, etc)

---

## ?? Deploy

### 1. Build de Produção

```bash
# Backend
cd backend
cargo build --release

# Frontend
cd ../frontend
trunk build --release
```

### 2. Docker (Recomendado)

```bash
# Build
docker build -t ghcr.io/avilaops/portal:latest .

# Push
docker push ghcr.io/avilaops/portal:latest

# Deploy
docker-compose -f docker-compose.prod.yml up -d
```

### 3. Verificação

```bash
# Health check
curl https://portal.avila.inc/api/health

# Teste de login
curl -X POST https://portal.avila.inc/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@avila.inc","password":"test123"}'
```

---

## ?? Pós-Deploy

### Monitoramento
- [ ] Logs sendo coletados
- [ ] Métricas sendo coletadas
- [ ] Alertas configurados
- [ ] Dashboard de monitoramento ativo
- [ ] Health check endpoints respondendo

### Performance
- [ ] Load time < 2s
- [ ] API latency < 100ms
- [ ] Database queries otimizadas
- [ ] CDN configurado (se aplicável)
- [ ] Caching funcionando

### Funcionalidade
- [ ] Login funciona
- [ ] Registro funciona
- [ ] Dashboard carrega
- [ ] Produtos listam
- [ ] Todas as rotas funcionam

### Segurança
- [ ] HTTPS funcionando
- [ ] Certificado SSL válido
- [ ] Headers de segurança presentes
- [ ] Rate limiting ativo
- [ ] Logs de auditoria funcionando

---

## ?? Monitoramento Contínuo

### Métricas a Acompanhar

#### Performance
- Response time (p50, p95, p99)
- Throughput (req/s)
- Error rate
- Memory usage
- CPU usage

#### Negócio
- Usuários ativos
- Logins/dia
- Features mais usadas
- Tempo médio de sessão
- Taxa de conversão

#### Infraestrutura
- Database connections
- Redis hit rate
- Disk usage
- Network bandwidth
- SSL cert expiration

---

## ?? Rollback Plan

### Se algo der errado:

```bash
# 1. Reverter Docker
docker-compose down
docker-compose up -d --force-recreate --build [previous_version]

# 2. Reverter Database
psql avila_portal < backup_YYYYMMDD.sql

# 3. Notificar
# - Usuários via status page
# - Equipe via Slack/Teams
# - Stakeholders via email
```

---

## ?? Configurações Específicas

### Azure (Exemplo)

```bash
# App Service
az webapp create \
  --resource-group avila-rg \
  --plan avila-plan \
  --name portal-avila \
  --runtime "DOCKER|ghcr.io/avilaops/portal:latest"

# Database
az postgres flexible-server create \
  --resource-group avila-rg \
  --name avila-portal-db \
  --admin-user avilaadmin \
  --admin-password [STRONG_PASSWORD] \
  --sku-name Standard_B2s

# Redis
az redis create \
  --resource-group avila-rg \
  --name avila-portal-cache \
  --location eastus \
  --sku Basic \
  --vm-size c0
```

### AWS (Exemplo)

```bash
# ECR
aws ecr create-repository --repository-name avila/portal

# ECS/Fargate
aws ecs create-cluster --cluster-name avila-portal

# RDS PostgreSQL
aws rds create-db-instance \
  --db-instance-identifier avila-portal-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --master-username avilaadmin \
  --master-user-password [STRONG_PASSWORD]

# ElastiCache Redis
aws elasticache create-cache-cluster \
  --cache-cluster-id avila-portal-cache \
  --cache-node-type cache.t3.micro \
  --engine redis
```

### Cloudflare (CDN)

```bash
# Configurar DNS
# portal.avila.inc ? [YOUR_IP]

# Ativar:
# - SSL/TLS Full (strict)
# - Always Use HTTPS
# - Auto Minify (HTML, CSS, JS)
# - Brotli compression
# - HTTP/3 (QUIC)
```

---

## ?? Checklist Final

### Antes de Anunciar
- [ ] Tudo testado em produção
- [ ] Documentação atualizada
- [ ] Equipe treinada
- [ ] Suporte preparado
- [ ] Monitoramento ativo
- [ ] Backup configurado
- [ ] Rollback testado

### Comunicação
- [ ] Email para usuários beta
- [ ] Post em redes sociais
- [ ] Atualizar website
- [ ] Press release (se aplicável)

---

**Data de Deploy**: __________  
**Responsável**: __________  
**Status**: [ ] Sucesso [ ] Rollback [ ] Parcial
