import { Injectable } from '@nestjs/common';
import { Knex } from 'knex';
import { InjectConnection } from 'nest-knexjs';
import { User } from './users.interface';

@Injectable()
export class UsersService {
  constructor(@InjectConnection() private readonly knex: Knex) { }

  async create(userName: string, userAka: string, userRole: string): Promise<number> {
    return await this.knex<User>('users').insert({
      username: userName,
      aka: userAka,
      role: userRole,
    }).first();
  }

  async findOneById(id: number): Promise<User> {
    return await this.knex<User>('users').where('userId', id).first();
  }

  async findOneByUsername(username: string): Promise<User> {
    return await this.knex<User>('users').where('username', username).first();
  }

  async findAll(): Promise<User[]> {
    const users = await this.knex<User>('users');
    return users;
  }
}
