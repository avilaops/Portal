use std::env;

#[derive(Clone, Debug)]
pub struct Config {
    pub database_url: String,
    #[allow(dead_code)]
    pub redis_url: String,
    pub jwt_secret: String,
    pub jwt_expiration: i64,
    pub host: String,
    pub port: u16,
    pub frontend_url: String,
}

impl Config {
    pub fn from_env() -> Self {
        Self {
            database_url: env::var("DATABASE_URL")
                .unwrap_or_else(|_| "sqlite://portal.db".to_string()),
            redis_url: env::var("REDIS_URL")
                .unwrap_or_else(|_| "redis://localhost:6379".to_string()),
            jwt_secret: env::var("JWT_SECRET")
                .unwrap_or_else(|_| "avila-dev-secret-key".to_string()),
            jwt_expiration: env::var("JWT_EXPIRATION")
                .unwrap_or_else(|_| "86400".to_string())
                .parse()
                .unwrap_or(86400),
            host: env::var("HOST")
                .unwrap_or_else(|_| "127.0.0.1".to_string()),
            port: env::var("PORT")
                .unwrap_or_else(|_| "8080".to_string())
                .parse()
                .unwrap_or(8080),
            frontend_url: env::var("FRONTEND_URL")
                .unwrap_or_else(|_| "http://localhost:8080".to_string()),
        }
    }
}
