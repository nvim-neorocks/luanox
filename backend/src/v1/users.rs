use rocket::get;

#[get("/users")]
pub fn users() -> &'static str {
    "Users go here"
}
