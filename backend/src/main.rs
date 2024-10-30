use diesel::Connection as _;
use rocket::{launch, Config};

mod v1;
mod schema;

#[launch]
fn rocket() -> _ {
    let url = std::env::var("BACKEND_URL").expect("no BACKEND_URL specified. Is your `.env` loaded?");
    let port = std::env::var("BACKEND_PORT").expect("no BACKEND_PORT specified. Is your `.env` loaded?");
    let db_url = std::env::var("DATABASE_URL").expect("no DATABASE_URL specified. Is your `.env` loaded?");

    let _db = diesel::PgConnection::establish(&db_url).expect("unable to connect to database");

    let config = Config {
        address: url.parse().expect("invalid BACKEND_URL: is not an IP address"),
        port: port.parse().expect("invalid BACKEND_PORT: is not a number"),
        ..Default::default()
    };

    rocket::custom(config).mount("/api/v1", v1::routes())
}
