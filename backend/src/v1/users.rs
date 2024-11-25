// TODO(ntbbloodbath): implement security and auth for the sensible endpoints
//
// TODO: add Delete and Update endpoints for users
use actix_web::{get, post, web, Error, Responder, HttpResponse};
use diesel::prelude::*;

use crate::db::{models, DbPool};

#[get("/users")]
pub async fn get_users(db: web::Data<DbPool>) -> impl Responder {
    use crate::schema::users::dsl::*;

    let all_users = web::block(move || {
        let mut conn = db.get().map_err(|_| {
            HttpResponse::InternalServerError().finish()
        }).unwrap();
        users.load::<models::User>(&mut conn)
    }).await;

    match all_users {
        Ok(usrs) => HttpResponse::Ok().json(usrs.unwrap()),
        Err(_) => HttpResponse::InternalServerError().finish(),
    }
}

#[get("/users/{user_id}")]
pub async fn get_user(db: web::Data<DbPool>, user_id: web::Path<i32>) -> Result<HttpResponse, Error> {
    use crate::schema::users::dsl::*;

    let user_id = user_id.into_inner();

    let user = web::block(move || {
        let mut conn = db.get().map_err(|_| {
            HttpResponse::InternalServerError().finish()
        }).unwrap();

        users.find(user_id).first::<models::User>(&mut conn).optional()
    }).await?;

    Ok(match user {
        Ok(usr) => HttpResponse::Ok().json(usr.unwrap()),
        Err(_) => HttpResponse::NotFound().body(format!("No user found with ID: {user_id}")),
    })
}

#[post("/users")]
pub async fn new_user(db: web::Data<DbPool>, data: web::Json<models::NewUser>) -> Result<HttpResponse, Error> {
    use crate::schema::users::dsl::*;

    let new_user = models::NewUser {
        username: data.username.clone(),
        aka: data.aka.clone(),
        role: data.role.clone(),
    };

    let user = web::block(move || {
        let mut conn = db.get().map_err(|_| {
            HttpResponse::InternalServerError().finish()
        }).unwrap();

        diesel::insert_into(users)
            .values(&new_user)
            .get_result::<models::User>(&mut conn)
            .unwrap()
    }).await;

    match user {
        Ok(usr) => Ok(HttpResponse::Created().json(usr)),
        Err(_) => Ok(HttpResponse::InternalServerError().finish()),
    }
}
