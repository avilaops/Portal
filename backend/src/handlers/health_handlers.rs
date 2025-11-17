use actix_web::{web, HttpResponse};
use sqlx::SqlitePool;

pub async fn health_check(_pool: web::Data<SqlitePool>) -> HttpResponse {
    HttpResponse::Ok().json(serde_json::json!({
        "status": "healthy",
        "service": "avila-portal",
        "timestamp": chrono::Utc::now().to_rfc3339(),
    }))
}
