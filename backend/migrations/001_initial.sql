CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name TEXT NOT NULL,
    company TEXT,
    role TEXT NOT NULL DEFAULT 'user',
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

CREATE TABLE IF NOT EXISTS products (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    url TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'online',
    icon TEXT NOT NULL,
    category TEXT NOT NULL,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS product_features (
    id TEXT PRIMARY KEY,
    product_id TEXT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    feature TEXT NOT NULL,
    created_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_product_features_product_id ON product_features(product_id);

CREATE TABLE IF NOT EXISTS activities (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action TEXT NOT NULL,
    resource TEXT NOT NULL,
    timestamp TEXT NOT NULL,
    ip_address TEXT
);

CREATE INDEX IF NOT EXISTS idx_activities_user_id ON activities(user_id);
CREATE INDEX IF NOT EXISTS idx_activities_timestamp ON activities(timestamp DESC);

INSERT OR IGNORE INTO products (id, name, description, url, status, icon, category, created_at) VALUES
    ('avila-vault', 'Avila Vault', 'Secrets management with AES-256-GCM', 'https://vault.avila.inc', 'online', '??', 'security', datetime('now')),
    ('avila-pulse', 'Avila Pulse', 'Executive telemetry hub', 'https://pulse.avila.inc', 'development', '??', 'analytics', datetime('now')),
    ('on-platform', 'On Platform', 'Multi-Agent AI Platform', 'https://on.avila.inc', 'development', '??', 'ai', datetime('now')),
    ('darwin', 'Darwin Self-Healing', 'Autonomous healing system', 'https://darwin.avila.inc', 'online', '??', 'infrastructure', datetime('now')),
    ('agenthub', 'AgentHub', 'AI orchestration platform', 'https://agenthub.avila.inc', 'online', '??', 'ai', datetime('now')),
    ('camacho', 'Camacho', 'Menu management system', 'https://camacho.avila.inc', 'online', '??', 'saas', datetime('now')),
    ('geolocation', 'Geolocation AI', 'Geospatial intelligence', 'https://geolocation.avila.inc', 'online', '??', 'ai', datetime('now')),
    ('barbara', 'Barbara WebGL', '3D interactive platform', 'https://barbara.avila.inc', 'online', '??', 'saas', datetime('now')),
    ('mrg', 'MRG Logistics', 'Thermal box management', 'https://mrgcaixastermicas.com.br', 'online', '??', 'saas', datetime('now')),
    ('reports', 'Reports Automation', 'Report automation framework', 'https://portal.avila.inc/reports', 'online', '??', 'analytics', datetime('now'));