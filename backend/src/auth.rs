use jsonwebtoken::{encode, decode, Header, Validation, EncodingKey, DecodingKey};
use chrono::Utc;
use uuid::Uuid;
use avila_portal_shared::{TokenClaims, UserRole};
use crate::error::ApiError;

pub struct AuthService {
    secret: String,
    expiration: i64,
}

impl AuthService {
    pub fn new(secret: String, expiration: i64) -> Self {
        Self { secret, expiration }
    }

    pub fn generate_token(&self, user_id: Uuid, email: String, role: UserRole) -> Result<String, ApiError> {
        let now = Utc::now().timestamp() as usize;
        let exp = (Utc::now().timestamp() + self.expiration) as usize;

        let claims = TokenClaims {
            sub: user_id.to_string(),
            exp,
            iat: now,
            email,
            role,
        };

        encode(
            &Header::default(),
            &claims,
            &EncodingKey::from_secret(self.secret.as_bytes()),
        )
        .map_err(|e| ApiError::InternalError(e.to_string()))
    }

    #[allow(dead_code)]
    pub fn validate_token(&self, token: &str) -> Result<TokenClaims, ApiError> {
        decode::<TokenClaims>(
            token,
            &DecodingKey::from_secret(self.secret.as_bytes()),
            &Validation::default(),
        )
        .map(|data| data.claims)
        .map_err(|e| ApiError::Unauthorized(e.to_string()))
    }

    pub fn hash_password(&self, password: &str) -> Result<String, ApiError> {
        bcrypt::hash(password, bcrypt::DEFAULT_COST)
            .map_err(|e| ApiError::InternalError(e.to_string()))
    }

    pub fn verify_password(&self, password: &str, hash: &str) -> Result<bool, ApiError> {
        bcrypt::verify(password, hash)
            .map_err(|e| ApiError::InternalError(e.to_string()))
    }
}
