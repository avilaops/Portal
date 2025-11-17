use actix_web::{web, App, HttpServer, middleware};
use actix_cors::Cors;
use actix_files::Files;
use sqlx::sqlite::SqlitePoolOptions;
use std::env;

mod auth;
mod handlers;
mod models;
mod custom_middleware;
mod services;
mod config;
mod error;

use config::Config;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv::dotenv().ok();
    env_logger::init();

    let config = Config::from_env();
    
    log::info!("Conectando ao SQLite...");
    let pool = SqlitePoolOptions::new()
        .max_connections(5)
        .connect(&config.database_url)
        .await
        .expect("Falha ao conectar no SQLite");

    log::info!("Executando migracoes...");
    sqlx::migrate!("./migrations")
        .run(&pool)
        .await
        .expect("Falha ao executar migracoes");

    let server_addr = format!("{}:{}", config.host, config.port);
    log::info!("Servidor rodando em http://{}", server_addr);

    HttpServer::new(move || {
        let cors = Cors::default()
            .allowed_origin(&config.frontend_url)
            .allowed_methods(vec!["GET", "POST", "PUT", "DELETE", "OPTIONS"])
            .allowed_headers(vec![
                actix_web::http::header::AUTHORIZATION,
                actix_web::http::header::ACCEPT,
                actix_web::http::header::CONTENT_TYPE,
            ])
            .max_age(3600);

        App::new()
            .app_data(web::Data::new(pool.clone()))
            .app_data(web::Data::new(config.clone()))
            .wrap(middleware::Logger::default())
            .wrap(cors)
            .configure(handlers::configure_routes)
            .service(Files::new("/", "./static").index_file("index.html"))
    })
    .bind(server_addr)?
    .run()
    .await
}
