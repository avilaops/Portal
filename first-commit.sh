#!/bin/bash

# Script para primeiro commit no GitHub

echo "?? Avila Portal - Primeiro Commit"
echo "================================="
echo ""

# Verificar se está em um repo git
if [ ! -d ".git" ]; then
    echo "?? Inicializando repositório Git..."
    git init
    git branch -M main
else
    echo "? Repositório Git já existe"
fi

echo ""
echo "?? Adicionando arquivos..."
git add .

echo ""
echo "?? Criando commit..."
git commit -m "?? feat: Initial commit - Avila Portal v0.1.0

- Backend completo em Rust (Actix-web)
- Frontend completo em WASM (Yew)
- Autenticação JWT
- Dashboard executivo
- 10 produtos integrados
- Design system sofisticado
- Docker + CI/CD
- 80+ arquivos criados

Stack: 100% Rust + WebAssembly
Zero dependências de terceiros (runtime)"

echo ""
echo "?? Configurando remote (se não existir)..."
git remote add origin https://github.com/avilaops/portal.git 2>/dev/null || echo "Remote já existe"

echo ""
echo "?? Enviando para GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "? Push concluído com sucesso!"
    echo ""
    echo "?? Repositório: https://github.com/avilaops/portal"
    echo ""
else
    echo ""
    echo "??  Erro no push. Possíveis causas:"
    echo "   - Repositório remoto não existe"
    echo "   - Sem permissão de escrita"
    echo "   - Conflitos com commits existentes"
    echo ""
    echo "Execute manualmente:"
    echo "   git push -u origin main --force"
fi
