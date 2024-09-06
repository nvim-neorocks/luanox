import type { Knex } from 'knex';

export async function up(knex: Knex) {
  return knex.schema
    .createTable('users', function(table) {
      table.increments('userId').unsigned();
      table.string('username').notNullable().unique();
      table.string('aka').unique();
      table.string('role').notNullable().defaultTo('user');
    })
    .createTable('keys', function(table) {
      table.increments('id').unsigned();
      table.string('value').notNullable().unique();
      table.integer('owner').unsigned().notNullable();
      table.specificType('permissions', 'text ARRAY').notNullable();
      table.timestamp('createdAt').defaultTo(knex.fn.now());

      table.foreign('owner').references('userId').inTable('users');
    })
    .createTable('rocks', function(table) {
      table.increments('id').unsigned();
      table.string('name').notNullable().unique();
      table.integer('owner').unsigned().notNullable();
      table.specificType('versions', 'text ARRAY').notNullable();
      table.timestamp('createdAt').defaultTo(knex.fn.now());
      table.timestamp('updatedAt').defaultTo(knex.fn.now());

      table.foreign('owner').references('userId').inTable('users');
    });
}

export async function down(knex: Knex) {
  return knex.schema
    .dropTable('keys')
    .dropTable('rocks')
    .dropTable('users');
}
