use diesel::{prelude::*, r2d2};

mod models;

// Short-hand for the database pool type to use throughout the app
pub(crate) type DbPool = r2d2::Pool<r2d2::ConnectionManager<PgConnection>>;

/// Initialize database connection pool based on `DATABASE_URL` environment variable.
///
/// See more: <https://docs.rs/diesel/latest/diesel/r2d2/index.html>
pub(crate) fn initialize_db_pool(db_url: String) -> crate::db::DbPool {
    let manager = r2d2::ConnectionManager::<PgConnection>::new(db_url);
    r2d2::Pool::builder()
        .build(manager)
        .expect("database URL should be valid path to Postgre DB")
}
