#!/bin/bash

# ============================================
# Setup Oracle Cloud Free Tier
# Avila Inc - Infraestrutura Completa
# ============================================

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}"
echo "============================================"
echo "🚀 Setup Avila Infrastructure"
echo "   Oracle Cloud Free Tier"
echo "   4 ARM CPUs + 24GB RAM"
echo "============================================"
echo -e "${NC}"

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}❌ Execute como root: sudo bash setup-oracle-cloud.sh${NC}"
  exit 1
fi

# ============================================
# 1. Atualizar sistema
# ============================================
echo -e "${YELLOW}📦 Atualizando sistema...${NC}"
apt update && apt upgrade -y
echo -e "${GREEN}✅ Sistema atualizado${NC}\n"

# ============================================
# 2. Instalar dependências
# ============================================
echo -e "${YELLOW}📦 Instalando dependências...${NC}"
apt install -y \
  curl \
  wget \
  git \
  vim \
  htop \
  ufw \
  fail2ban \
  ca-certificates \
  gnupg \
  lsb-release

echo -e "${GREEN}✅ Dependências instaladas${NC}\n"

# ============================================
# 3. Instalar Docker
# ============================================
echo -e "${YELLOW}🐳 Instalando Docker...${NC}"

# Remove versões antigas
apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Adicionar repositório Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Iniciar Docker
systemctl enable docker
systemctl start docker

echo -e "${GREEN}✅ Docker instalado${NC}\n"

# ============================================
# 4. Configurar Firewall
# ============================================
echo -e "${YELLOW}🔥 Configurando firewall...${NC}"

# Configurar UFW
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp     # SSH
ufw allow 80/tcp     # HTTP
ufw allow 443/tcp    # HTTPS
ufw allow 8080/tcp   # Traefik Dashboard

# Habilitar
ufw --force enable

echo -e "${GREEN}✅ Firewall configurado${NC}\n"

# ============================================
# 5. Configurar Fail2ban
# ============================================
echo -e "${YELLOW}🛡️  Configurando Fail2ban...${NC}"

cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = 22
logpath = /var/log/auth.log
EOF

systemctl enable fail2ban
systemctl restart fail2ban

echo -e "${GREEN}✅ Fail2ban configurado${NC}\n"

# ============================================
# 6. Criar estrutura de diretórios
# ============================================
echo -e "${YELLOW}📁 Criando estrutura...${NC}"

mkdir -p /opt/avila/{letsencrypt,monitoring/{prometheus,grafana,loki,promtail},scripts,backups}

# Baixar arquivos do GitHub
cd /opt/avila
git clone https://github.com/avilaops/Portal.git portal

# Copiar docker-compose
cp portal/docker-compose.avila-full.yml docker-compose.yml
cp portal/.env.production.example .env.production

echo -e "${GREEN}✅ Estrutura criada${NC}\n"

# ============================================
# 7. Configurar swap (para ARM)
# ============================================
echo -e "${YELLOW}💾 Configurando swap...${NC}"

fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

echo -e "${GREEN}✅ Swap configurado (4GB)${NC}\n"

# ============================================
# 8. Configurar cron para backups
# ============================================
echo -e "${YELLOW}⏰ Configurando backups automáticos...${NC}"

cp /opt/avila/portal/scripts/backup-to-onedrive.sh /opt/avila/scripts/
chmod +x /opt/avila/scripts/backup-to-onedrive.sh

# Adicionar cron job (3h da manhã, todo dia)
(crontab -l 2>/dev/null; echo "0 3 * * * /opt/avila/scripts/backup-to-onedrive.sh >> /var/log/avila-backup.log 2>&1") | crontab -

echo -e "${GREEN}✅ Backups automáticos configurados${NC}\n"

# ============================================
# 9. Otimizações de sistema
# ============================================
echo -e "${YELLOW}⚡ Aplicando otimizações...${NC}"

# Limites do sistema
cat >> /etc/security/limits.conf <<EOF
* soft nofile 65536
* hard nofile 65536
* soft nproc 32768
* hard nproc 32768
EOF

# Sysctl
cat >> /etc/sysctl.conf <<EOF
# Avila optimizations
fs.file-max = 2097152
vm.swappiness = 10
vm.overcommit_memory = 1
net.core.somaxconn = 65536
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.ip_local_port_range = 1024 65535
EOF

sysctl -p

echo -e "${GREEN}✅ Otimizações aplicadas${NC}\n"

# ============================================
# 10. Resumo final
# ============================================
echo -e "${GREEN}"
echo "============================================"
echo "✅ SETUP COMPLETO!"
echo "============================================"
echo -e "${NC}"
echo ""
echo -e "${BLUE}📋 Próximos passos:${NC}"
echo ""
echo "1. Configure as variáveis de ambiente:"
echo -e "   ${YELLOW}vim /opt/avila/.env.production${NC}"
echo ""
echo "2. Inicie os serviços:"
echo -e "   ${YELLOW}cd /opt/avila${NC}"
echo -e "   ${YELLOW}docker compose up -d${NC}"
echo ""
echo "3. Configure DNS no Cloudflare:"
echo "   portal.avila.inc  → A → $(curl -s ifconfig.me)"
echo "   api.avila.inc     → A → $(curl -s ifconfig.me)"
echo "   auth.avila.inc    → A → $(curl -s ifconfig.me)"
echo "   *.avila.inc       → A → $(curl -s ifconfig.me)"
echo ""
echo "4. Monitore os logs:"
echo -e "   ${YELLOW}docker compose logs -f${NC}"
echo ""
echo -e "${GREEN}🎉 Servidor pronto para produção!${NC}"
echo ""

# Salvar info do servidor
SERVER_IP=$(curl -s ifconfig.me)
echo "Server IP: $SERVER_IP" > /opt/avila/server-info.txt
echo "Setup Date: $(date)" >> /opt/avila/server-info.txt

exit 0
