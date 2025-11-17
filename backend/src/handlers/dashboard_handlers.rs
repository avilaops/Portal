use actix_web::{web, HttpResponse};
use sqlx::SqlitePool;
use avila_portal_shared::DashboardMetrics;

pub async fn get_dashboard(pool: web::Data<SqlitePool>) -> HttpResponse {
    let total_users = sqlx::query_scalar::<_, i64>("SELECT COUNT(*) FROM users")
        .fetch_one(pool.get_ref())
        .await
        .unwrap_or(0);

    let active_products = sqlx::query_scalar::<_, i64>(
        "SELECT COUNT(*) FROM products WHERE status = 'online'"
    )
    .fetch_one(pool.get_ref())
    .await
    .unwrap_or(0);

    let total_activities = sqlx::query_scalar::<_, i64>("SELECT COUNT(*) FROM activities")
        .fetch_one(pool.get_ref())
        .await
        .unwrap_or(0);

    let metrics = DashboardMetrics {
        total_users,
        active_products,
        total_activities,
    };

    HttpResponse::Ok().json(metrics)
}
