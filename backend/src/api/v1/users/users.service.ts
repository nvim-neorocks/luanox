import { Injectable } from '@nestjs/common';
import { Knex } from 'knex';
import { InjectConnection } from 'nest-knexjs';
import { User } from './users.interface';
import { UserUpdateDto } from './users.dto';

@Injectable()
export class UsersService {
  constructor(@InjectConnection() private readonly knex: Knex) {}

  async create(
    userName: string,
    userAka: string,
    userRole: string,
  ): Promise<number> {
    return await this.knex<User>('users').insert({
      username: userName,
      aka: userAka,
      role: userRole,
    });
  }

  async delete(id: number): Promise<number> {
    return await this.knex<User>('users').where('userId', id).del();
  }

  async update(id: number, data: UserUpdateDto): Promise<boolean> {
    // Create a copy of the original data to be updated and remove the 'id' field from it
    const updateData = { ...data, ['id']: undefined };
    // Returns a boolean whether the user was affected or not
    const updatedUser = await this.knex<User>('users')
      .where('userId', id)
      .update(updateData, ['userId']);
    return updatedUser.length > 0;
  }

  async findOneById(id: number): Promise<User[]> {
    return await this.knex<User>('users').where('userId', id);
  }

  async findOneByUsername(username: string): Promise<User[]> {
    return await this.knex<User>('users').where('username', username);
  }

  async findAll(): Promise<User[]> {
    return await this.knex<User>('users');
  }
}
