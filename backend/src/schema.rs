// @generated automatically by Diesel CLI.

diesel::table! {
    keys (id) {
        id -> Integer,
        value -> Varchar,
        owner -> Integer,
        permissions -> Array<Nullable<Text>>,
        created -> Timestamp,
    }
}

diesel::table! {
    rocks (id) {
        id -> Integer,
        name -> Varchar,
        owner -> Integer,
        versions -> Array<Nullable<Text>>,
        created -> Timestamp,
        updated -> Timestamp,
    }
}

diesel::table! {
    users (userid) {
        userid -> Integer,
        username -> Varchar,
        aka -> Varchar,
        role -> Varchar,
    }
}

diesel::joinable!(keys -> users (owner));
diesel::joinable!(rocks -> users (owner));

diesel::allow_tables_to_appear_in_same_query!(
    keys,
    rocks,
    users,
);
