// @generated automatically by Diesel CLI.

diesel::table! {
    keys (id) {
        id -> Int4,
        value -> Varchar,
        owner -> Int4,
        permissions -> Array<Nullable<Text>>,
        created -> Timestamp,
    }
}

diesel::table! {
    rocks (id) {
        id -> Int4,
        name -> Varchar,
        owner -> Int4,
        versions -> Array<Nullable<Text>>,
        created -> Timestamp,
        updated -> Timestamp,
    }
}

diesel::table! {
    users (userid) {
        userid -> Int4,
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
