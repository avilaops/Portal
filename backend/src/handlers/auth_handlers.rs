use actix_web::{web, HttpResponse};
use sqlx::SqlitePool;
use uuid::Uuid;
use chrono::Utc;
use avila_portal_shared::{LoginRequest, RegisterRequest, LoginResponse, UserResponse, ApiResponse};

use crate::{
    auth::AuthService,
    config::Config,
    error::ApiError,
    models::User,
};

pub async fn login(
    pool: web::Data<SqlitePool>,
    config: web::Data<Config>,
    body: web::Json<LoginRequest>,
) -> Result<HttpResponse, ApiError> {
    let user = sqlx::query_as::<_, User>(
        "SELECT * FROM users WHERE email = ?"
    )
    .bind(&body.email)
    .fetch_optional(pool.get_ref())
    .await?
    .ok_or_else(|| ApiError::Unauthorized("Invalid credentials".to_string()))?;

    let auth_service = AuthService::new(config.jwt_secret.clone(), config.jwt_expiration);
    
    if !auth_service.verify_password(&body.password, &user.password_hash)? {
        return Err(ApiError::Unauthorized("Invalid credentials".to_string()));
    }

    let user_id = Uuid::parse_str(&user.id).unwrap_or_else(|_| Uuid::new_v4());
    let token = auth_service.generate_token(user_id, user.email.clone(), user.role())?;
    let expires_at = Utc::now().timestamp() + config.jwt_expiration;

    let response = LoginResponse {
        token,
        user: UserResponse {
            id: user_id,
            email: user.email,
            name: user.name,
            company: user.company,
            role: user.role,
        },
        expires_at,
    };

    Ok(HttpResponse::Ok().json(ApiResponse::success(response)))
}

pub async fn register(
    pool: web::Data<SqlitePool>,
    config: web::Data<Config>,
    body: web::Json<RegisterRequest>,
) -> Result<HttpResponse, ApiError> {
    if body.email.is_empty() || body.password.is_empty() || body.name.is_empty() {
        return Err(ApiError::ValidationError("All fields required".to_string()));
    }

    let existing_user = sqlx::query_as::<_, User>(
        "SELECT * FROM users WHERE email = ?"
    )
    .bind(&body.email)
    .fetch_optional(pool.get_ref())
    .await?;

    if existing_user.is_some() {
        return Err(ApiError::BadRequest("Email already exists".to_string()));
    }

    let auth_service = AuthService::new(config.jwt_secret.clone(), config.jwt_expiration);
    let password_hash = auth_service.hash_password(&body.password)?;

    let user_id = Uuid::new_v4().to_string();
    let now = Utc::now().to_rfc3339();

    let user = sqlx::query_as::<_, User>(
        "INSERT INTO users (id, email, password_hash, name, company, role, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?)
         RETURNING *"
    )
    .bind(&user_id)
    .bind(&body.email)
    .bind(&password_hash)
    .bind(&body.name)
    .bind(&body.company)
    .bind("user")
    .bind(&now)
    .bind(&now)
    .fetch_one(pool.get_ref())
    .await?;

    let user_uuid = Uuid::parse_str(&user.id).unwrap_or_else(|_| Uuid::new_v4());
    let token = auth_service.generate_token(user_uuid, user.email.clone(), user.role())?;
    let expires_at = Utc::now().timestamp() + config.jwt_expiration;

    let response = LoginResponse {
        token,
        user: UserResponse {
            id: user_uuid,
            email: user.email,
            name: user.name,
            company: user.company,
            role: user.role,
        },
        expires_at,
    };

    Ok(HttpResponse::Created().json(ApiResponse::success(response)))
}

pub async fn me(
    pool: web::Data<SqlitePool>,
    user_id: web::ReqData<Uuid>,
) -> Result<HttpResponse, ApiError> {
    let user_id_str = user_id.to_string();
    
    let user = sqlx::query_as::<_, User>(
        "SELECT * FROM users WHERE id = ?"
    )
    .bind(&user_id_str)
    .fetch_optional(pool.get_ref())
    .await?
    .ok_or_else(|| ApiError::NotFound("User not found".to_string()))?;

    let user_uuid = Uuid::parse_str(&user.id).unwrap_or_else(|_| Uuid::new_v4());
    
    let user_data = UserResponse {
        id: user_uuid,
        email: user.email,
        name: user.name,
        company: user.company,
        role: user.role,
    };

    Ok(HttpResponse::Ok().json(ApiResponse::success(user_data)))
}
