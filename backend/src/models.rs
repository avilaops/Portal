use sqlx::FromRow;
use serde::{Deserialize, Serialize};
use avila_portal_shared::{UserRole, ProductStatus, ProductCategory};

#[derive(Debug, Clone, FromRow, Serialize, Deserialize)]
pub struct User {
    pub id: String,
    pub email: String,
    pub password_hash: String,
    pub name: String,
    pub company: Option<String>,
    pub role: String,
    pub created_at: String,
    pub updated_at: String,
}

impl User {
    pub fn role(&self) -> UserRole {
        match self.role.as_str() {
            "admin" => UserRole::Admin,
            "developer" => UserRole::Developer,
            "guest" => UserRole::Guest,
            _ => UserRole::User,
        }
    }
}

#[derive(Debug, Clone, FromRow, Serialize, Deserialize)]
pub struct Product {
    pub id: String,
    pub name: String,
    pub description: String,
    pub url: String,
    pub status: String,
    pub icon: String,
    pub category: String,
    pub created_at: String,
}

impl Product {
    pub fn status(&self) -> ProductStatus {
        match self.status.as_str() {
            "development" => ProductStatus::Development,
            "maintenance" => ProductStatus::Maintenance,
            "offline" => ProductStatus::Offline,
            _ => ProductStatus::Online,
        }
    }

    pub fn category(&self) -> ProductCategory {
        match self.category.as_str() {
            "analytics" => ProductCategory::Analytics,
            "ai" => ProductCategory::AI,
            "infrastructure" => ProductCategory::Infrastructure,
            "saas" => ProductCategory::SaaS,
            _ => ProductCategory::Security,
        }
    }
}

#[derive(Debug, Clone, FromRow, Serialize, Deserialize)]
pub struct Activity {
    pub id: String,
    pub user_id: String,
    pub action: String,
    pub resource: String,
    pub timestamp: String,
    pub ip_address: Option<String>,
}
