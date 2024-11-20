use actix_web::{App, HttpServer};
use diesel::Connection as _;
use std::io;

mod v1;
mod schema;

#[actix_web::main]
pub async fn main() -> io::Result<()> {
    let url =
        std::env::var("BACKEND_URL").expect("no BACKEND_URL specified. Is your `.env` loaded?");
    let port =
        std::env::var("BACKEND_PORT").expect("no BACKEND_PORT specified. Is your `.env` loaded?");
    let db_url =
        std::env::var("DATABASE_URL").expect("no DATABASE_URL specified. Is your `.env` loaded?");

    let _db = diesel::PgConnection::establish(&db_url).expect("unable to connect to database");

    // TODO: Hook up the backend properly, currently we just bind `index()` to `/api/`
    HttpServer::new(|| App::new().service(actix_web::web::scope("/api").service(v1::index)))
        .bind((url, port.parse().unwrap()))
        .unwrap()
        .run()
        .await
        .unwrap();

    Ok(())
}
