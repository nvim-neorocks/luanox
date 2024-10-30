use rocket::routes;
use rocket::{get, Route};

mod users;

#[get("/")]
pub fn index() -> &'static str {
    "Hello, world!"
}

pub fn routes() -> Vec<Route> {
    routes![index, users::users]
}
