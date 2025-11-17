# ? Checklist - Colocar Portal no Ar

## ?? FASE 1: Preparação (10 min)

### Instalar Ferramentas
- [ ] Rust instalado (`cargo --version` funciona)
- [ ] Git instalado (`git --version` funciona)
- [ ] Docker instalado (opcional)
- [ ] PostgreSQL instalado (ou Docker)
- [ ] Redis instalado (ou Docker)

**Como instalar Rust**:
```powershell
.\install-rust.ps1
# Depois: FECHAR E ABRIR novo terminal!
```

---

## ?? FASE 2: Setup Projeto (5 min)

### Configuração Inicial
- [ ] Executar `.\setup.ps1`
- [ ] Target WASM adicionado
- [ ] Trunk instalado
- [ ] SQLx CLI instalado
- [ ] Arquivo `.env` criado em `backend/`

### Editar Configurações
- [ ] Abrir `backend\.env`
- [ ] Verificar `DATABASE_URL`
- [ ] Verificar `REDIS_URL`
- [ ] Salvar arquivo

**DATABASE_URL Padrão**:
```
postgres://postgres:postgres@localhost:5432/avila_portal
```

---

## ?? FASE 3: Database (3 min)

### PostgreSQL
- [ ] PostgreSQL rodando
- [ ] Database `avila_portal` criada
- [ ] Migrations executadas

**Comandos**:
```powershell
# Com Docker
docker-compose up -d postgres redis

# Criar database (se não usar Docker)
createdb avila_portal

# Rodar migrations
cd backend
sqlx migrate run
cd ..
```

---

## ?? FASE 4: Rodar Portal (2 min)

### Backend
- [ ] Terminal 1 aberto
- [ ] `cd backend`
- [ ] `cargo run` executado
- [ ] Mensagem "Servidor rodando em http://0.0.0.0:8080" apareceu

### Frontend
- [ ] Terminal 2 aberto
- [ ] `cd frontend`
- [ ] `trunk serve --open` executado
- [ ] Browser abriu automaticamente

### Verificar
- [ ] Portal carregou em http://localhost:8080
- [ ] Navbar apareceu
- [ ] Gradientes animando
- [ ] Console sem erros (F12)

---

## ?? FASE 5: Testar Funcionalidades (5 min)

### Autenticação
- [ ] Clicar "Portal do Cliente"
- [ ] Ir para "Registre-se"
- [ ] Preencher formulário
- [ ] Conta criada com sucesso
- [ ] Redirecionado para Dashboard

### Dashboard
- [ ] Métricas carregaram
- [ ] Cards de métricas visíveis
- [ ] Atividades recentes mostradas
- [ ] Design está bonito

### Produtos
- [ ] Clicar em "Produtos" no menu
- [ ] 10 produtos listados
- [ ] Cards com hover effect
- [ ] Status coloridos corretos
- [ ] Links funcionando

### Navegação
- [ ] Menu funciona
- [ ] Rotas mudam sem reload
- [ ] Voltar/avançar do browser funciona
- [ ] 404 page funciona (teste: /rota-invalida)

---

## ?? FASE 6: Commit no GitHub (5 min)

### Preparar Commit
- [ ] `git status` (ver arquivos)
- [ ] `git add .` (adicionar tudo)
- [ ] `git commit -m "?? Initial commit - Portal v0.1.0"`

### Push para GitHub
- [ ] Repositório existe: https://github.com/avilaops/portal
- [ ] `git remote add origin https://github.com/avilaops/portal.git`
- [ ] `git push -u origin main`

**Script automático**:
```powershell
.\first-commit.bat
```

---

## ?? FASE 7: Deploy (Opcional - 15 min)

### Docker Completo
- [ ] `docker-compose up --build`
- [ ] Todos serviços rodando
- [ ] Portal acessível

### Produção
- [ ] Escolher provedor (Azure/AWS/GCP)
- [ ] Seguir `DEPLOY_CHECKLIST.md`
- [ ] Configurar domínio `portal.avila.inc`
- [ ] Configurar SSL/TLS
- [ ] Deploy realizado

---

## ?? CHECKLIST RÁPIDO (Se tiver pressa)

```powershell
# 1. Instalar Rust
.\install-rust.ps1
# FECHAR E ABRIR TERMINAL!

# 2. Setup
.\setup.ps1

# 3. Docker (se tiver)
docker-compose up -d postgres redis

# 4. Backend (Terminal 1)
cd backend
cargo run

# 5. Frontend (Terminal 2 - NOVO terminal)
cd frontend
trunk serve --open

# 6. Abrir browser
http://localhost:8080

# 7. Registrar e testar!
```

---

## ? SUCESSO!

Quando tudo estiver checado acima, você terá:

?? **Portal Avila 100% funcional**  
?? **Rust + WASM rodando**  
?? **Performance de elite**  
?? **Design sofisticado**  
?? **10 produtos integrados**  

---

## ?? SE ALGO FALHAR

1. Ler: `TROUBLESHOOTING.md`
2. Ler: `START_HERE.md`
3. Ler: `DEVELOPMENT.md`
4. Email: contato@avila.inc
5. Issue: https://github.com/avilaops/portal/issues

---

## ?? STATUS

- [ ] Rust instalado
- [ ] Setup executado
- [ ] Database rodando
- [ ] Backend rodando
- [ ] Frontend rodando
- [ ] Portal acessível
- [ ] Testes passaram
- [ ] Commit feito
- [ ] Deploy realizado

**Progresso**: ___/9 ?

---

<div align="center">

**Você consegue! ??**

**Qualquer dúvida, estamos aqui! ??**

</div>
