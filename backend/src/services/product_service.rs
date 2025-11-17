use sqlx::SqlitePool;
use crate::{models::Product, error::ApiError};

pub struct ProductService {
    pool: SqlitePool,
}

impl ProductService {
    pub fn new(pool: SqlitePool) -> Self {
        Self { pool }
    }

    pub async fn list_all(&self) -> Result<Vec<Product>, ApiError> {
        let products = sqlx::query_as::<_, Product>(
            "SELECT * FROM products"
        )
        .fetch_all(&self.pool)
        .await?;
        
        Ok(products)
    }

    pub async fn find_by_id(&self, id: &str) -> Result<Option<Product>, ApiError> {
        let product = sqlx::query_as::<_, Product>(
            "SELECT * FROM products WHERE id = ?"
        )
        .bind(id)
        .fetch_optional(&self.pool)
        .await?;
        
        Ok(product)
    }
}
