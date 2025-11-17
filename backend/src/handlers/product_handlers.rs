use actix_web::{web, HttpResponse};
use sqlx::SqlitePool;
use crate::models::{Product as DbProduct};
use avila_portal_shared::Product;

pub async fn list_products(pool: web::Data<SqlitePool>) -> HttpResponse {
    match sqlx::query_as::<_, DbProduct>("SELECT * FROM products")
        .fetch_all(pool.get_ref())
        .await
    {
        Ok(products) => {
            let products: Vec<Product> = products.into_iter().map(|p| Product {
                id: p.id.clone(),
                name: p.name.clone(),
                description: p.description.clone(),
                url: p.url.clone(),
                status: p.status(),
                icon: p.icon.clone(),
                features: vec![],
                category: p.category(),
            }).collect();
            
            HttpResponse::Ok().json(products)
        }
        Err(e) => HttpResponse::InternalServerError().json(serde_json::json!({
            "error": format!("Database error: {}", e)
        })),
    }
}

pub async fn get_product(
    pool: web::Data<SqlitePool>,
    path: web::Path<String>,
) -> HttpResponse {
    let product_id = path.into_inner();

    match sqlx::query_as::<_, DbProduct>("SELECT * FROM products WHERE id = ?")
        .bind(&product_id)
        .fetch_one(pool.get_ref())
        .await
    {
        Ok(p) => {
            let product = Product {
                id: p.id.clone(),
                name: p.name.clone(),
                description: p.description.clone(),
                url: p.url.clone(),
                status: p.status(),
                icon: p.icon.clone(),
                features: vec![],
                category: p.category(),
            };
            
            HttpResponse::Ok().json(product)
        }
        Err(_) => HttpResponse::NotFound().json(serde_json::json!({
            "error": "Product not found"
        })),
    }
}
