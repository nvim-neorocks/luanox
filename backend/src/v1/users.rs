// TODO(ntbbloodbath): implement security and auth for the sensible endpoints
//
// TODO: improve error handling so we return an actual error instead of `Err(_)` with an Internal Server Error
use actix_web::{get, post, patch, delete, web, Error, Responder, HttpResponse};
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

        // FIXME: proper error handling for existing users
        diesel::insert_into(users)
            .values(&new_user)
            .get_result::<models::User>(&mut conn)
            .unwrap()
    }).await;

    Ok(match user {
        Ok(usr) => HttpResponse::Created().json(usr),
        Err(_) => HttpResponse::InternalServerError().finish(),
    })
}

#[delete("/users/{user_id}")]
pub async fn delete_user(db: web::Data<DbPool>, user_id: web::Path<i32>) -> Result<HttpResponse, Error> {
    use crate::schema::users::dsl::*;

    let user_id = user_id.into_inner();

    let user = web::block(move || {
        let mut conn = db.get().map_err(|_| {
            HttpResponse::InternalServerError().finish()
        }).unwrap();

        diesel::delete(users.filter(userid.eq(user_id))).execute(&mut conn)
    }).await?;

    Ok(match user {
        Ok(rows_deleted) => {
            if rows_deleted > 0 {
                HttpResponse::Ok().json(format!("User with ID {user_id} has been deleted successfully"))
            } else {
                HttpResponse::NotFound().json("User not found")
            }
        },
        Err(_) => HttpResponse::InternalServerError().finish(),
    })
}

#[patch("/users/{user_id}")]
pub async fn update_user(db: web::Data<DbPool>, user_id: web::Path<i32>, user_data: web::Json<models::UpdateUser>) -> Result<HttpResponse, Error> {
    use crate::schema::users::dsl::*;

    let user_id = user_id.into_inner();
    let user_data = user_data.into_inner();

    let updated_user = web::block(move || {
        let mut conn = db.get().map_err(|_| {
            HttpResponse::InternalServerError().finish()
        }).unwrap();

        diesel::update(users.find(user_id)).set(user_data).execute(&mut conn)
    }).await?;

    Ok(match updated_user {
        Ok(rows_updated) => {
            if rows_updated > 0 {
                HttpResponse::Ok().json(format!("User with ID {user_id} has been updated successfully"))
            } else {
                HttpResponse::NotFound().json("User not found")
            }
        },
        Err(_) => HttpResponse::InternalServerError().finish(),
    })
}
