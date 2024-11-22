use actix_web::{web, App, HttpServer};
use std::io;

mod v1;
mod db;
mod schema;

#[actix_web::main]
pub async fn main() -> io::Result<()> {
    let url =
        std::env::var("BACKEND_URL").expect("no BACKEND_URL specified. Is your `.env` loaded?");
    let port =
        std::env::var("BACKEND_PORT").expect("no BACKEND_PORT specified. Is your `.env` loaded?");
    let db_url =
        std::env::var("DATABASE_URL").expect("no DATABASE_URL specified. Is your `.env` loaded?");

    let db = db::initialize_db_pool(db_url);

    // XXX: just for dev purposes, my brain cannot handle a successful restart w/o messages to stdout
    println!("Starting server on port {}", port);

    // TODO: Hook up the backend properly, currently we just bind `index()` to `/api/`
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(db.clone()))
            .service(actix_web::web::scope("/api").service(v1::index))
    })
    .bind((url, port.parse().unwrap()))?
    .run()
    .await?;

    Ok(())
}
