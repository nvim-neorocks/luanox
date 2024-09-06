import type { Knex } from "knex";

// XXX: the configuration environments are used if we need to do
// some action in Knex CLI.
const config: { [key: string]: Knex.Config } = {
  development: {
    client: "postgresql",
    connection: {
      database: "luna_test",
      user: "postgres",
      password: "postgres"
    },
    pool: {
      min: 0,
      max: 10
    },
    migrations: {
      tableName: "knex_migrations"
    }
  },
  // XXX: staging, production
};

module.exports = config;
