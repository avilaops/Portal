#!/bin/bash

# Gerar certificado SSL auto-assinado para desenvolvimento local

echo "?? Gerando certificado SSL para desenvolvimento..."
echo ""

mkdir -p certs

openssl req -x509 -newkey rsa:4096 -nodes \
  -keyout certs/key.pem \
  -out certs/cert.pem \
  -days 365 \
  -subj "/C=BR/ST=SP/L=SaoPaulo/O=AvilaInc/OU=Dev/CN=localhost"

if [ $? -eq 0 ]; then
    echo ""
    echo "? Certificado gerado com sucesso!"
    echo ""
    echo "?? Arquivos criados:"
    echo "   - certs/cert.pem"
    echo "   - certs/key.pem"
    echo ""
    echo "??  ATENÇÃO: Este é um certificado auto-assinado apenas para desenvolvimento."
    echo "   Não use em produção!"
    echo ""
else
    echo ""
    echo "? Erro ao gerar certificado"
fi
