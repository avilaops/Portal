#!/bin/bash

# ============================================
# Backup Automático para OneDrive
# Avila Inc - Infraestrutura
# ============================================

set -e

# Configurações
BACKUP_DIR="/mnt/c/Users/nicol/OneDrive/Avila/Backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
RETENTION_DAYS=30

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}🔄 Avila Backup to OneDrive${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "📅 Data: ${DATE}"
echo -e "📁 Destino: ${BACKUP_DIR}"
echo ""

# Cria diretório de backup se não existir
mkdir -p "$BACKUP_DIR"/{postgres,redis,minio,configs}

# ============================================
# 1. PostgreSQL Backup
# ============================================
echo -e "${YELLOW}📦 Backup PostgreSQL...${NC}"
docker exec postgres pg_dumpall -U avila > "$BACKUP_DIR/postgres/postgres-$DATE.sql"
gzip "$BACKUP_DIR/postgres/postgres-$DATE.sql"
echo -e "${GREEN}✅ PostgreSQL backup completo${NC}"
echo ""

# ============================================
# 2. Redis Backup
# ============================================
echo -e "${YELLOW}📦 Backup Redis...${NC}"
docker exec redis redis-cli BGSAVE
sleep 5
docker cp redis:/data/dump.rdb "$BACKUP_DIR/redis/redis-$DATE.rdb"
gzip "$BACKUP_DIR/redis/redis-$DATE.rdb"
echo -e "${GREEN}✅ Redis backup completo${NC}"
echo ""

# ============================================
# 3. MinIO Backup (Storage)
# ============================================
echo -e "${YELLOW}📦 Backup MinIO (S3)...${NC}"
docker exec minio sh -c "cd /data && tar -czf /tmp/minio-backup.tar.gz ."
docker cp minio:/tmp/minio-backup.tar.gz "$BACKUP_DIR/minio/minio-$DATE.tar.gz"
docker exec minio rm /tmp/minio-backup.tar.gz
echo -e "${GREEN}✅ MinIO backup completo${NC}"
echo ""

# ============================================
# 4. Configurações
# ============================================
echo -e "${YELLOW}📦 Backup Configurações...${NC}"
tar -czf "$BACKUP_DIR/configs/configs-$DATE.tar.gz" \
  -C /opt/avila \
  letsencrypt \
  monitoring \
  docker-compose.yml \
  .env.production 2>/dev/null || true
echo -e "${GREEN}✅ Configurações backup completo${NC}"
echo ""

# ============================================
# 5. Limpar backups antigos
# ============================================
echo -e "${YELLOW}🧹 Limpando backups antigos (>$RETENTION_DAYS dias)...${NC}"

find "$BACKUP_DIR/postgres" -name "*.gz" -mtime +$RETENTION_DAYS -delete
find "$BACKUP_DIR/redis" -name "*.gz" -mtime +$RETENTION_DAYS -delete
find "$BACKUP_DIR/minio" -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete
find "$BACKUP_DIR/configs" -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo -e "${GREEN}✅ Limpeza completa${NC}"
echo ""

# ============================================
# 6. Resumo
# ============================================
POSTGRES_SIZE=$(du -sh "$BACKUP_DIR/postgres" | cut -f1)
REDIS_SIZE=$(du -sh "$BACKUP_DIR/redis" | cut -f1)
MINIO_SIZE=$(du -sh "$BACKUP_DIR/minio" | cut -f1)
CONFIGS_SIZE=$(du -sh "$BACKUP_DIR/configs" | cut -f1)
TOTAL_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}✅ BACKUP COMPLETO!${NC}"
echo -e "${GREEN}=====================================${NC}"
echo ""
echo -e "📊 Tamanhos:"
echo -e "   PostgreSQL: $POSTGRES_SIZE"
echo -e "   Redis: $REDIS_SIZE"
echo -e "   MinIO: $MINIO_SIZE"
echo -e "   Configs: $CONFIGS_SIZE"
echo -e "   ${GREEN}Total: $TOTAL_SIZE${NC}"
echo ""
echo -e "📁 Backups salvos em: $BACKUP_DIR"
echo -e "☁️  OneDrive sincronizará automaticamente"
echo ""

# ============================================
# 7. Log para auditoria
# ============================================
LOG_FILE="$BACKUP_DIR/backup.log"
echo "[$DATE] Backup completo - Total: $TOTAL_SIZE" >> "$LOG_FILE"

exit 0
