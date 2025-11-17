# ?? PASSO-A-PASSO - Rodar o Portal Agora!

## ? CAMINHO RÁPIDO (3 Passos)

### ?? Você está aqui:
`C:\Users\nicol\OneDrive\Avila\1.2 - Avilaops\1.2.2 - Products\1.2.2.1 - Portal`

---

## PASSO 1: Instalar Rust (5 minutos)

### Opção A: Script Automático (Recomendado)
```powershell
.\install-rust.ps1
```

### Opção B: Manual
1. Abra: https://rustup.rs/
2. Baixe `rustup-init.exe`
3. Execute e escolha opção padrão (1)
4. **FECHE e ABRA um NOVO terminal**

### Verificar
```powershell
cargo --version
# Deve mostrar: cargo 1.XX.X
```

Se não funcionar: **Feche e abra o terminal novamente!**

---

## PASSO 2: Setup do Projeto (3 minutos)

```powershell
# Executar script de setup
.\setup.ps1
```

Isso vai:
- ? Adicionar target WASM
- ? Instalar Trunk (frontend)
- ? Instalar SQLx CLI (database)
- ? Criar arquivo .env
- ? Iniciar Docker (se tiver)

---

## PASSO 3: Rodar o Portal (2 minutos)

### Terminal 1 - Backend
```powershell
cd backend
cargo run
```

Aguarde aparecer:
```
Servidor rodando em http://0.0.0.0:8080
```

### Terminal 2 - Frontend (abra NOVO terminal)
```powershell
cd frontend
trunk serve --open
```

### ?? Pronto!
O browser vai abrir automaticamente em:
**http://localhost:8080**

---

## ?? ALTERNATIVA: Docker (Se tiver Docker instalado)

```powershell
# Iniciar PostgreSQL + Redis
docker-compose up -d postgres redis

# Aguardar 10 segundos
Start-Sleep -Seconds 10

# Rodar migrações
cd backend
sqlx migrate run

# Rodar backend
cargo run
```

---

## ?? TROUBLESHOOTING RÁPIDO

### "cargo: command not found"
? Instale Rust (Passo 1)  
? Feche e abra NOVO terminal

### "trunk: command not found"
```powershell
cargo install trunk
```

### "DATABASE_URL not found"
```powershell
# Opção 1: Docker
docker-compose up -d postgres redis

# Opção 2: Editar backend\.env
# Mudar DATABASE_URL para seu PostgreSQL local
```

### "sqlx migrate run" falha
```powershell
# Criar database manualmente
# Depois:
cd backend
sqlx migrate run
```

---

## ?? COMANDOS RESUMIDOS

```powershell
# 1. Instalar Rust (primeira vez apenas)
.\install-rust.ps1

# 2. FECHAR e ABRIR novo terminal

# 3. Setup (primeira vez apenas)
.\setup.ps1

# 4. Rodar (sempre)
# Terminal 1:
cd backend
cargo run

# Terminal 2:
cd frontend
trunk serve --open
```

---

## ?? TESTAR O PORTAL

1. **Abrir**: http://localhost:8080
2. **Clicar**: "Portal do Cliente"
3. **Clicar**: "Registre-se"
4. **Criar**: sua conta
5. **Ver**: Dashboard com métricas
6. **Navegar**: pelos produtos

---

## ?? PRÓXIMOS PASSOS (Depois de rodar)

1. ? Portal funcionando
2. ?? Customizar design em `static/styles/main.css`
3. ?? Adicionar features
4. ?? Deploy com Docker
5. ?? Publicar no GitHub

---

## ?? DICAS

### Desenvolvimento Rápido
```powershell
# Backend com hot-reload
cargo install cargo-watch
cd backend
cargo watch -x run

# Frontend já tem hot-reload com trunk serve
```

### Ver Logs Detalhados
```powershell
$env:RUST_LOG="debug"
cargo run
```

### Limpar Tudo e Recomeçar
```powershell
cargo clean
Remove-Item -Recurse -Force frontend\dist
```

---

## ?? PRECISA DE AJUDA?

1. **Ler**: TROUBLESHOOTING.md
2. **Email**: contato@avila.inc
3. **Issue**: https://github.com/avilaops/portal/issues

---

<div align="center">

## ?? BORA LÁ!

**Execute os 3 passos acima e veja a mágica acontecer!**

?? **Rust** + ?? **WASM** = ? **Performance Insana**

</div>

---

**Tempo total estimado**: 10 minutos  
**Dificuldade**: ????? (Fácil)  
**Resultado**: Portal completo rodando! ??
