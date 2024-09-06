import { Injectable } from '@nestjs/common';
import { Knex } from 'knex';
import { InjectConnection } from 'nest-knexjs';
import { User } from './users.interface';

@Injectable()
export class UsersService {
  constructor(@InjectConnection() private readonly knex: Knex) { }

  //async create(userName: string): Promise<User> {
  //
  //}

  async findOne(id: number): Promise<User> {
    const user = await this.knex<User>('users').where('id', id).first();
    return user;
  }

  async findAll(): Promise<{ users: User[] }> {
    const users = await this.knex<User>('users');
    return { users };
  }
}
