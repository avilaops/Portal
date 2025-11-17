# ?? AÇÃO NECESSÁRIA: Instalar Rust

## ?? SITUAÇÃO ATUAL

O Rust **NÃO** está instalado no seu sistema.

---

## ? SOLUÇÃO RÁPIDA (5 minutos)

### OPÇÃO 1: Instalador Automático

Execute este comando no PowerShell:

```powershell
.\install-rust.ps1
```

Ou execute este no CMD:

```cmd
install-rust.bat
```

### OPÇÃO 2: Manual (Se script falhar)

1. **Abra**: https://rustup.rs/
   
2. **Baixe**: `rustup-init.exe`
   
3. **Execute** o arquivo baixado
   
4. Quando perguntado, escolha: **1** (instalação padrão)
   
5. Aguarde a instalação (2-3 minutos)
   
6. **IMPORTANTE**: FECHE este terminal e ABRA um NOVO

---

## ? VERIFICAR INSTALAÇÃO

Abra um **NOVO terminal** e execute:

```powershell
cargo --version
```

Deve mostrar algo como:
```
cargo 1.75.0 (ou superior)
```

Se mostrar, está **INSTALADO** ?

---

## ?? DEPOIS DE INSTALAR

Execute estes comandos (em ordem):

```powershell
# 1. Setup do projeto
.\setup.ps1

# 2. Iniciar Docker (se tiver)
docker-compose up -d postgres redis

# 3. Terminal 1 - Backend
cd backend
cargo run

# 4. Terminal 2 - Frontend
cd frontend
trunk serve --open
```

---

## ?? RESULTADO FINAL

Você verá:

```
? Browser abre automaticamente
? Portal carrega em http://localhost:8080
? Design sofisticado com gradientes
? 10 produtos listados
? Tudo funcionando perfeitamente!
```

---

## ?? SE TIVER PROBLEMA

1. **Ler**: TROUBLESHOOTING.md
2. **Ler**: START_HERE.md
3. **Email**: contato@avila.inc

---

<div align="center">

## ?? INSTALAR RUST AGORA

### Windows PowerShell:
```powershell
.\install-rust.ps1
```

### Windows CMD:
```cmd
install-rust.bat
```

### Ou baixe de:
**https://rustup.rs/**

---

**Depois de instalar: FECHE e ABRA um NOVO terminal!**

Então execute: `.\setup.ps1`

</div>

---

**Status**: ?? Rust não instalado  
**Ação**: Instalar Rust  
**Tempo**: 5 minutos  
**Dificuldade**: ?????
