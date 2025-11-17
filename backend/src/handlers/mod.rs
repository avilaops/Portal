pub mod auth_handlers;
pub mod product_handlers;
pub mod dashboard_handlers;
pub mod health_handlers;

use actix_web::web;

pub fn configure_routes(cfg: &mut web::ServiceConfig) {
    cfg.service(
        web::scope("/api")
            .route("/health", web::get().to(health_handlers::health_check))
            .service(
                web::scope("/auth")
                    .route("/login", web::post().to(auth_handlers::login))
                    .route("/register", web::post().to(auth_handlers::register))
                    .route("/me", web::get().to(auth_handlers::me))
            )
            .service(
                web::scope("/products")
                    .route("", web::get().to(product_handlers::list_products))
                    .route("/{id}", web::get().to(product_handlers::get_product))
            )
            .service(
                web::scope("/dashboard")
                    .route("/metrics", web::get().to(dashboard_handlers::get_dashboard))
            )
    );
}
