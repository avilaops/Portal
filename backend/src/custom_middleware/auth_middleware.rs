use actix_web::{
    dev::{forward_ready, Service, ServiceRequest, ServiceResponse, Transform},
    Error, HttpMessage,
};
use futures::future::LocalBoxFuture;
use std::future::{ready, Ready};
use uuid::Uuid;

use crate::{auth::AuthService, config::Config};

#[allow(dead_code)]
pub struct AuthMiddleware;

impl<S, B> Transform<S, ServiceRequest> for AuthMiddleware
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type InitError = ();
    type Transform = AuthMiddlewareService<S>;
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        ready(Ok(AuthMiddlewareService { service }))
    }
}

#[allow(dead_code)]
pub struct AuthMiddlewareService<S> {
    service: S,
}

impl<S, B> Service<ServiceRequest> for AuthMiddlewareService<S>
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type Future = LocalBoxFuture<'static, Result<Self::Response, Self::Error>>;

    forward_ready!(service);

    fn call(&self, req: ServiceRequest) -> Self::Future {
        let auth_header = req.headers().get("Authorization");

        if let Some(auth_value) = auth_header {
            if let Ok(auth_str) = auth_value.to_str() {
                if let Some(token) = auth_str.strip_prefix("Bearer ") {
                    if let Some(config) = req.app_data::<actix_web::web::Data<Config>>() {
                        let auth_service =
                            AuthService::new(config.jwt_secret.clone(), config.jwt_expiration);

                        if let Ok(claims) = auth_service.validate_token(token) {
                            if let Ok(user_id) = Uuid::parse_str(&claims.sub) {
                                req.extensions_mut().insert(user_id);
                            }
                        }
                    }
                }
            }
        }

        let fut = self.service.call(req);
        Box::pin(fut)
    }
}
