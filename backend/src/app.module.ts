import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { KnexModule } from 'nest-knexjs';
import { AuthModule } from './api/v1/auth/auth.module';
import { UsersService } from './api/v1/users/users.service';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    KnexModule.forRootAsync({
      useFactory: () => ({
        config: {
          client: 'pg',
          connection: {
            host: process.env.DB_HOST,
            port: process.env.DB_PORT,
            user: process.env.DB_USER,
            password: process.env.DB_PASS,
            database: process.env.DB_NAME,
          },
          // min: 0 so all idle connections can be terminated
          pool: { min: 0, max: 10 },
        },
      }),
    }),
    AuthModule
  ],
  controllers: [],
  providers: [UsersService],
})
export class AppModule {}
