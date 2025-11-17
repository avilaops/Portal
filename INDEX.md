# ?? Índice de Documentação - Avila Portal

## ?? COMEÇAR AGORA

**Rust não instalado?** ? [INSTALL_RUST_FIRST.md](INSTALL_RUST_FIRST.md)  
**Rust instalado?** ? [START_HERE.md](START_HERE.md)  
**Pressa?** ? [QUICKSTART.md](QUICKSTART.md)  
**Checklist completo?** ? [CHECKLIST.md](CHECKLIST.md)

---

## ?? DOCUMENTAÇÃO POR PAPEL

### ????? Para Desenvolvedores
1. [DEVELOPMENT.md](DEVELOPMENT.md) - Guia completo de desenvolvimento
2. [ARCHITECTURE.md](ARCHITECTURE.md) - Arquitetura técnica detalhada
3. [CONTRIBUTING.md](CONTRIBUTING.md) - Como contribuir
4. [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Resolver problemas

### ?? Para Gestores/Stakeholders
1. [EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md) - Resumo executivo
2. [ROADMAP.md](ROADMAP.md) - Planejamento 12 meses
3. [STATUS.md](STATUS.md) - Status atual do projeto
4. [CHANGELOG.md](CHANGELOG.md) - Histórico de mudanças

### ?? Para DevOps
1. [DEPLOY_CHECKLIST.md](DEPLOY_CHECKLIST.md) - Deploy produção
2. [Dockerfile](Dockerfile) - Container config
3. [docker-compose.yml](docker-compose.yml) - Orquestração local
4. [.github/workflows/ci.yml](.github/workflows/ci.yml) - Pipeline CI/CD

### ?? Para Segurança
1. [SECURITY.md](SECURITY.md) - Política de segurança
2. [LICENSE](LICENSE) - Licença MIT

---

## ?? DOCUMENTAÇÃO POR TÓPICO

### ?? Começando
- [INSTALL_RUST_FIRST.md](INSTALL_RUST_FIRST.md) - Instalar Rust
- [START_HERE.md](START_HERE.md) - Guia passo-a-passo
- [QUICKSTART.md](QUICKSTART.md) - Início rápido
- [CHECKLIST.md](CHECKLIST.md) - Checklist completo

### ??? Arquitetura
- [ARCHITECTURE.md](ARCHITECTURE.md) - Design técnico
- [Backend README](backend/) - API REST
- [Frontend README](frontend/) - UI WASM
- [Shared README](shared/) - Tipos comuns

### ?? Desenvolvimento
- [DEVELOPMENT.md](DEVELOPMENT.md) - Workflow de dev
- [CONTRIBUTING.md](CONTRIBUTING.md) - Padrões de código
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Debug

### ?? Deploy
- [DEPLOY_CHECKLIST.md](DEPLOY_CHECKLIST.md) - Checklist produção
- [Dockerfile](Dockerfile) - Container build
- [docker-compose.yml](docker-compose.yml) - Orquestração

### ?? Gestão
- [ROADMAP.md](ROADMAP.md) - Planejamento futuro
- [STATUS.md](STATUS.md) - Status atual
- [CHANGELOG.md](CHANGELOG.md) - Histórico

### ?? Referência Rápida
- [SUMMARY.md](SUMMARY.md) - Resumo executivo
- [FINAL_DELIVERY.md](FINAL_DELIVERY.md) - Entrega final
- [EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md) - Visão geral

---

## ?? DOCUMENTAÇÃO POR NÍVEL

### Iniciante
1. [INSTALL_RUST_FIRST.md](INSTALL_RUST_FIRST.md) - Começar do zero
2. [START_HERE.md](START_HERE.md) - Primeiros passos
3. [QUICKSTART.md](QUICKSTART.md) - Quick start

### Intermediário
1. [DEVELOPMENT.md](DEVELOPMENT.md) - Desenvolvimento
2. [ARCHITECTURE.md](ARCHITECTURE.md) - Arquitetura
3. [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Debug

### Avançado
1. [CONTRIBUTING.md](CONTRIBUTING.md) - Contribuir
2. [DEPLOY_CHECKLIST.md](DEPLOY_CHECKLIST.md) - Deploy
3. [SECURITY.md](SECURITY.md) - Segurança

---

## ?? ENCONTRAR INFORMAÇÃO

### "Como instalar?"
? [INSTALL_RUST_FIRST.md](INSTALL_RUST_FIRST.md)

### "Como rodar?"
? [START_HERE.md](START_HERE.md) ou [QUICKSTART.md](QUICKSTART.md)

### "Erro ao rodar"
? [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

### "Como funciona?"
? [ARCHITECTURE.md](ARCHITECTURE.md)

### "Como desenvolver?"
? [DEVELOPMENT.md](DEVELOPMENT.md)

### "Como fazer deploy?"
? [DEPLOY_CHECKLIST.md](DEPLOY_CHECKLIST.md)

### "Qual o plano futuro?"
? [ROADMAP.md](ROADMAP.md)

### "Como contribuir?"
? [CONTRIBUTING.md](CONTRIBUTING.md)

### "É seguro?"
? [SECURITY.md](SECURITY.md)

### "Qual o status?"
? [STATUS.md](STATUS.md)

### "O que foi entregue?"
? [FINAL_DELIVERY.md](FINAL_DELIVERY.md) ou [SUMMARY.md](SUMMARY.md)

---

## ?? ESTRUTURA DE ARQUIVOS

### Código Fonte
```
??? backend/src/          (Backend Rust)
??? frontend/src/         (Frontend Rust ? WASM)
??? shared/src/           (Tipos compartilhados)
??? static/               (Assets estáticos)
```

### Configuração
```
??? Cargo.toml            (Workspace)
??? backend/Cargo.toml    (Backend deps)
??? frontend/Cargo.toml   (Frontend deps)
??? backend/.env          (Variáveis de ambiente)
??? docker-compose.yml    (Orquestração)
```

### Scripts
```
??? setup.*               (Setup inicial)
??? quickstart.*          (Quick start)
??? first-commit.*        (Git helper)
??? healthcheck.sh        (Monitoring)
??? Makefile              (Make commands)
```

### Documentação
```
??? *.md                  (14 guias)
??? .github/              (Templates)
```

---

## ?? FLUXO DE TRABALHO

```
1. INSTALL_RUST_FIRST.md
         ?
2. START_HERE.md ou QUICKSTART.md
         ?
3. DEVELOPMENT.md (para desenvolver)
         ?
4. TROUBLESHOOTING.md (se tiver problema)
         ?
5. DEPLOY_CHECKLIST.md (para produção)
```

---

## ?? AJUDA

### Documentação
- Leia os `.md` relevantes acima
- Use Ctrl+F para buscar

### Suporte
- ?? Email: contato@avila.inc
- ?? Issues: https://github.com/avilaops/portal/issues
- ?? Discussions: https://github.com/avilaops/portal/discussions

---

<div align="center">

## ??? MAPA DO PROJETO

```
                    portal.avila.inc
                          ?
          ?????????????????????????????????
          ?               ?               ?
      Backend         Frontend        Database
     (Rust API)     (Rust WASM)   (PostgreSQL)
          ?               ?               ?
          ?????????????????????????????????
                          ?
                    ?? Internet
                          ?
                    ?? Usuários
```

**90+ arquivos • 6,000+ linhas • 100% Rust**

</div>

---

**Criado**: Janeiro 2025  
**Versão**: 0.1.0  
**Status**: ? Completo
