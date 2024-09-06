import type { Knex } from 'knex';

export async function up(knex: Knex) {
  return knex.schema
    .createTable('users', function(table) {
      table.increments('id').primary().unsigned();
      table.string('username').notNullable().unique();
      table.string('role').notNullable().defaultTo('user');
    })
    .createTable('keys', function(table) {
      table.increments('id').primary().unsigned();
      table.string('value').notNullable().unique();
      table.integer('owner').unsigned().index().references('id').inTable('users').onDelete('SET NULL');
      table.specificType('permissions', 'text ARRAY').notNullable();
      table.timestamp('createdAt').defaultTo(knex.fn.now());
    })
    .createTable('rocks', function(table) {
      table.increments('id').primary().unsigned();
      table.string('name').notNullable().unique();
      table.integer('owner').unsigned().index().references('id').inTable('users').onDelete('SET NULL');
      table.specificType('versions', 'text ARRAY').notNullable();
    });
}

export async function down(knex: Knex) {
  return knex.schema
    .dropTable('users')
    .dropTable('keys')
    .dropTable('rocks');
}
