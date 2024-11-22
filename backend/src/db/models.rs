use diesel::prelude::{Insertable, Queryable};
use serde::{Deserialize, Serialize};

use crate::schema::users;

/// User details
#[derive(Debug, Clone, Serialize, Deserialize, Queryable, Insertable)]
#[diesel(table_name = users)]
pub struct User {
    pub userid: i32,
    pub username: String,
    pub aka: String,
    pub role: String,
}

/// New user details
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NewUser {
    pub username: String,
}
