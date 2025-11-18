use crate::{error::ApiError, models::User};
use sqlx::SqlitePool;

#[allow(dead_code)]
pub struct UserService {
    pool: SqlitePool,
}

#[allow(dead_code)]
impl UserService {
    pub fn new(pool: SqlitePool) -> Self {
        Self { pool }
    }

    pub async fn find_by_id(&self, id: String) -> Result<Option<User>, ApiError> {
        let user = sqlx::query_as::<_, User>("SELECT * FROM users WHERE id = ?")
            .bind(id)
            .fetch_optional(&self.pool)
            .await?;

        Ok(user)
    }

    pub async fn find_by_email(&self, email: &str) -> Result<Option<User>, ApiError> {
        let user = sqlx::query_as::<_, User>("SELECT * FROM users WHERE email = ?")
            .bind(email)
            .fetch_optional(&self.pool)
            .await?;

        Ok(user)
    }
}
