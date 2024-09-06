import { Knex } from "knex";

export async function seed(knex: Knex): Promise<void> {
    // Deletes ALL existing entries
    await knex("users").del();

    // Inserts seed entries
    await knex("users").insert([
        { username: "rowValue1", aka: null, role: "admin" },
        { username: "rowValue2", aka: null, role: "mod" },
        { username: "rowValue3", aka: "bozo", role: "user" }
    ]);
};
