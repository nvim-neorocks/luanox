pub(crate) mod users;

use actix_web::get;

#[get("/")]
pub async fn index() -> &'static str {
    "Hello World"
}
