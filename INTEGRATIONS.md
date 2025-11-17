# ?? Integração Avila - Ecossistema Completo

## ?? Status das Integrações

Este documento mapeia como o **Portal Avila** se conecta com todos os serviços do ecossistema.

---

## ??? Arquitetura de Integração

```
                    ???????????????????????
                    ?   Portal Avila      ?
                    ?   (Hub Central)     ?
                    ???????????????????????
                               ?
        ???????????????????????????????????????????????
        ?                      ?                      ?
   ???????????          ?????????????          ???????????
   ? API GW  ?          ?   Auth    ?          ?  Vault  ?
   ???????????          ?????????????          ???????????
        ?                     ?                      ?
   ???????????          ?????????????          ???????????
   ?  Flow   ?          ?   Pulse   ?          ? Darwin  ?
   ???????????          ?????????????          ???????????
        ?                     ?                      ?
   ???????????          ?????????????          ???????????
   ?AgentHub ?          ?    On     ?          ? Camacho ?
   ???????????          ?????????????          ???????????
        ?                     ?                      ?
   ???????????          ?????????????          ???????????
   ?  Geo AI ?          ?  Barbara  ?          ?   MRG   ?
   ???????????          ?????????????          ???????????
```

---

## ?? Serviços Integrados

### 1. ?? **Avila API** (api.avila.inc)
**Status**: ? Configurado  
**Função**: Gateway central de APIs

**Integração**:
```rust
// backend/src/services/avila_integration.rs
config.api.base_url  // https://api.avila.inc
```

**Endpoints Utilizados**:
- `GET /health` - Health check
- `POST /proxy/*` - Proxy para outros serviços

**Variáveis**:
```env
AVILA_API_URL=https://api.avila.inc
AVILA_API_KEY=your-api-key
```

---

### 2. ?? **Avila Vault** (vault.avila.inc)
**Status**: ? Configurado  
**Função**: Secrets management com AES-256-GCM

**Integração**:
```rust
// Método: vault_get_secret(key)
let secret = integration.vault_get_secret("database-password").await?;
```

**Endpoints Utilizados**:
- `GET /api/secrets/{key}` - Recuperar secret
- `POST /api/secrets` - Criar secret
- `DELETE /api/secrets/{key}` - Deletar secret

**Variáveis**:
```env
AVILA_VAULT_URL=https://vault.avila.inc
AVILA_VAULT_KEY=your-vault-key
AVILA_VAULT_ENCRYPTION_KEY=your-encryption-key
```

**Casos de Uso**:
- Armazenar JWT secrets
- Credenciais de banco
- API keys de terceiros
- Certificados SSL

---

### 3. ?? **Avila Flow** (flow.avila.inc)
**Status**: ? Configurado  
**Função**: Automação de workflows

**Integração**: Planejada Phase 2

**Endpoints**:
- `POST /api/workflows/trigger` - Trigger workflow
- `GET /api/workflows/{id}/status` - Status
- `POST /api/workflows/create` - Criar workflow

**Variáveis**:
```env
AVILA_FLOW_URL=https://flow.avila.inc
AVILA_FLOW_KEY=your-flow-key
```

**Casos de Uso**:
- Onboarding automatizado
- Notificações por email
- Processamento batch
- Integrações scheduled

---

### 4. ?? **Avila Auth** (auth.avila.inc)
**Status**: ? Configurado  
**Função**: SSO e autenticação centralizada

**Integração**: Planejada Phase 1

**Endpoints**:
- `POST /oauth/token` - Get token
- `GET /oauth/userinfo` - User info
- `POST /oauth/revoke` - Revoke token

**Variáveis**:
```env
AVILA_AUTH_URL=https://auth.avila.inc
AVILA_AUTH_CLIENT_ID=portal-client
AVILA_AUTH_CLIENT_SECRET=your-secret
```

**Casos de Uso**:
- Login SSO
- Azure AD integration
- Google/GitHub OAuth
- MFA

---

### 5. ?? **Avila Pulse** (pulse.avila.inc)
**Status**: ? Configurado  
**Função**: Telemetria e analytics

**Integração**:
```rust
// Enviar métrica
integration.pulse_send_metric("portal.login", 1.0, Some(tags)).await?;
```

**Endpoints**:
- `POST /api/metrics` - Send metric
- `GET /api/dashboards/{id}` - Get dashboard
- `WS /ws` - Real-time streaming

**Variáveis**:
```env
AVILA_PULSE_URL=https://pulse.avila.inc
AVILA_PULSE_KEY=your-pulse-key
AVILA_PULSE_WS_URL=wss://pulse.avila.inc/ws
```

**Casos de Uso**:
- Métricas de uso
- Dashboards executivos
- Alertas em tempo real
- Analytics

---

### 6. ?? **Darwin Self-Healing** (darwin.avila.inc)
**Status**: ? Configurado  
**Função**: Auto-recuperação de sistemas

**Integração**:
```rust
// Reportar problema
integration.darwin_report_issue("portal-api", "high", "Database slow").await?;
```

**Endpoints**:
- `POST /api/issues` - Report issue
- `GET /api/health/{service}` - Service health
- `POST /api/heal/{service}` - Trigger healing

**Variáveis**:
```env
AVILA_DARWIN_URL=https://darwin.avila.inc
AVILA_DARWIN_KEY=your-darwin-key
```

**Casos de Uso**:
- Detectar falhas
- Auto-restart services
- Scale automático
- Health monitoring

---

### 7. ?? **AgentHub** (agenthub.avila.inc)
**Status**: ? Configurado  
**Função**: Orquestração de agentes IA

**Integração**:
```rust
// Executar agente
let result = integration.agenthub_execute("support-agent", input).await?;
```

**Endpoints**:
- `POST /api/agents/{id}/execute` - Execute agent
- `GET /api/agents` - List agents
- `GET /api/agents/{id}/status` - Agent status

**Variáveis**:
```env
AVILA_AGENTHUB_URL=https://agenthub.avila.inc
AVILA_AGENTHUB_KEY=your-agenthub-key
```

**Casos de Uso**:
- Suporte automatizado
- Chatbot inteligente
- Análise de logs
- Automação de tasks

---

### 8. ?? **On Platform** (on.avila.inc)
**Status**: ?? Planejado (Phase 1)  
**Função**: Multi-Agent AI Platform

**Integração**: A ser implementada

**Casos de Uso**:
- 9 agentes especializados
- Orquestração complexa
- Workflows inteligentes

---

### 9. ?? **Camacho** (camacho.avila.inc)
**Status**: ?? Planejado (Phase 2)  
**Função**: Gestão de cardápios

**Casos de Uso**:
- Preview de cardápios
- Recomendações IA
- Analytics de pedidos

---

### 10. ?? **Geolocation AI** (geolocation.avila.inc)
**Status**: ?? Planejado (Phase 2)  
**Função**: Inteligência geoespacial

**Casos de Uso**:
- Rastreamento usuários
- Otimização de rotas
- Geofencing

---

## ?? Endpoints de Integração do Portal

### Status de Serviços
```bash
GET /api/integrations/health
```

**Response**:
```json
{
  "status": "ok",
  "services": [
    {
      "service_name": "Avila API",
      "status": "healthy",
      "response_time_ms": 45,
      "available": true
    },
    {
      "service_name": "Avila Vault",
      "status": "healthy",
      "response_time_ms": 32,
      "available": true
    }
  ]
}
```

---

## ?? Fluxos de Integração

### Login via SSO (Avila Auth)
```
1. User clica "Login com Avila Auth"
2. Portal redireciona ? auth.avila.inc
3. User autentica (Azure AD/Google/GitHub)
4. Auth retorna token ? Portal
5. Portal valida token
6. User logado
```

### Métricas (Avila Pulse)
```
1. User faz ação no Portal
2. Portal envia métrica ? Pulse
3. Pulse agrega e processa
4. Dashboard atualizado em tempo real
5. Alertas disparados se necessário
```

### Secrets (Avila Vault)
```
1. Portal precisa de secret
2. Faz request ? Vault
3. Vault descriptografa e retorna
4. Portal usa secret
5. Secret nunca persiste em memória
```

### Auto-Healing (Darwin)
```
1. Portal detecta erro
2. Reporta ? Darwin
3. Darwin analisa
4. Darwin aplica fix
5. Portal volta ao normal
```

---

## ?? Configuração

### 1. Configurar .env
```bash
cp backend/.env.example backend/.env
# Editar backend/.env com suas credenciais
```

### 2. Obter API Keys
- Vault: https://vault.avila.inc/settings/api-keys
- Pulse: https://pulse.avila.inc/settings/api-keys
- Darwin: https://darwin.avila.inc/settings/api-keys
- AgentHub: https://agenthub.avila.inc/settings/api-keys

### 3. Testar Integração
```bash
cargo run
curl http://localhost:8080/api/integrations/health
```

---

## ?? Roadmap de Integrações

### ? Phase 0 (Atual)
- [x] Estrutura de integração
- [x] Configuração de serviços
- [x] Health check básico

### ?? Phase 1 (Fevereiro 2025)
- [ ] SSO com Avila Auth
- [ ] Métricas para Pulse
- [ ] Secrets do Vault
- [ ] AgentHub chatbot

### ?? Phase 2 (Março 2025)
- [ ] Darwin auto-healing
- [ ] Flow automations
- [ ] On Platform agents
- [ ] Camacho integration

### ?? Phase 3 (Abril 2025)
- [ ] Geolocation tracking
- [ ] Barbara 3D embeds
- [ ] MRG logistics
- [ ] Reports automation

---

## ?? Testes de Integração

```rust
#[actix_web::test]
async fn test_vault_integration() {
    let config = AvilaServicesConfig::from_env();
    let integration = AvilaIntegration::new(config);
    
    // Test get secret
    let result = integration.vault_get_secret("test-key").await;
    assert!(result.is_ok());
}

#[actix_web::test]
async fn test_pulse_integration() {
    let config = AvilaServicesConfig::from_env();
    let integration = AvilaIntegration::new(config);
    
    // Test send metric
    let result = integration.pulse_send_metric("test.metric", 123.45, None).await;
    assert!(result.is_ok());
}
```

---

## ?? Documentação das APIs

### Avila Vault
- Docs: https://vault.avila.inc/docs
- OpenAPI: https://vault.avila.inc/openapi.json

### Avila Pulse
- Docs: https://pulse.avila.inc/docs
- WebSocket: wss://pulse.avila.inc/ws

### Darwin
- Docs: https://darwin.avila.inc/docs
- Status: https://status.darwin.avila.inc

### AgentHub
- Docs: https://agenthub.avila.inc/docs
- Agents: https://agenthub.avila.inc/catalog

---

## ?? Segurança

### Autenticação
- API Keys via headers `X-API-Key`
- JWT tokens via `Authorization: Bearer`
- mTLS para comunicação sensível (futuro)

### Secrets
- Nunca commitar API keys
- Usar Vault para secrets críticos
- Rotacionar keys regularmente

### Rate Limiting
- 1000 req/min por serviço
- 100 req/min para Vault
- Burst allowed: 20 req/s

---

## ?? Monitoramento

### Health Checks
```bash
# Status de todas integrações
curl http://localhost:8080/api/integrations/health

# Status específico
curl https://vault.avila.inc/health
curl https://pulse.avila.inc/health
curl https://darwin.avila.inc/health
```

### Logs
```bash
# Ver logs de integração
RUST_LOG=avila_integration=debug cargo run
```

---

## ?? Próximos Passos

1. **Testar conexões** com cada serviço
2. **Obter API keys** válidas
3. **Implementar** integrações Phase 1
4. **Monitorar** performance
5. **Expandir** para Phase 2

---

**Criado**: Janeiro 2025  
**Status**: ? Estrutura pronta  
**Próximo**: Implementar Phase 1
