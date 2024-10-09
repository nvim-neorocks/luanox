import type { Knex } from "knex";

// XXX: the configuration environments are used if we need to do
// some action in Knex CLI.
const config: { [key: string]: Knex.Config } = {
  development: {
    client: "postgresql",
    connection: {
      database: "luanox_test",
      user: process.env.USER, // XXX: devenv automatically sets the current system user as the databases user
      password: "",
    },
    pool: {
      min: 0,
      max: 10,
    },
    migrations: {
      tableName: "knex_migrations",
    },
  },
};

module.exports = config;
