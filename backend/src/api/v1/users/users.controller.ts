import {
  Controller,
  HttpException,
  HttpStatus,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiOkResponse,
  ApiForbiddenResponse,
  ApiBadRequestResponse,
} from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { ThrottlerGuard } from '@nestjs/throttler';
import { UsersService } from './users.service';
import { User } from './users.interface';
import { UserInfoDto, UserDeleteDto } from './users.dto';
import { Roles } from '../roles/roles.decorator';
import { RolesGuard } from '../auth/auth.guard';

@UseGuards(RolesGuard)
@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Post('create')
  @Roles(['admin'])
  @UseGuards(AuthGuard('jwt'), ThrottlerGuard)
  @ApiOperation({ summary: 'Create a new user' })
  @ApiForbiddenResponse({
    description: 'Not enough permissions to execute this request',
  })
  async create(@Body() body: UserInfoDto): Promise<User[]> {
    return await this.usersService.create(body.username, body.aka, 'user');
  }

  @Delete('delete')
  @Roles(['admin'])
  @UseGuards(AuthGuard('jwt'), ThrottlerGuard)
  @ApiOperation({ summary: 'Delete an existing user' })
  @ApiForbiddenResponse({
    description: 'Not enough permissions to execute this request',
  })
  async delete(@Body() body: UserDeleteDto): Promise<boolean> {
    // Returns true if there was at least 1 row affected
    return (await this.usersService.delete(body.id)) > 0;
  }

  @Patch('update')
  @Roles(['admin'])
  @UseGuards(AuthGuard('jwt'), ThrottlerGuard)
  @ApiOperation({ summary: 'Update an existing user' })
  @ApiForbiddenResponse({
    description: 'Not enough permissions to execute this request',
  })
  @ApiBadRequestResponse({
    description: 'Not enough permissions to execute this request',
  })
  async update(@Body() body: any): Promise<boolean> {
    try {
      return await this.usersService.update(body.id, body);
    } catch (err) {
      throw new HttpException(
        {
          status: HttpStatus.BAD_REQUEST,
          error: 'No data was sent to update the user',
        },
        HttpStatus.BAD_REQUEST,
        {
          cause: err,
        },
      );
    }
  }

  @Get('all')
  @Roles(['admin'])
  @UseGuards(AuthGuard('jwt'), ThrottlerGuard)
  @ApiOperation({ summary: 'Get all users' })
  @ApiOkResponse({
    description: 'Successfully got all the data from the users table',
    type: Array<UserInfoDto>,
  })
  @ApiForbiddenResponse({
    description: 'Not enough permissions to execute this request',
  })
  async findAll(): Promise<User[]> {
    return await this.usersService.findAll();
  }

  @Get('ById/:id')
  @Roles(['admin'])
  @UseGuards(AuthGuard('jwt'), ThrottlerGuard)
  @ApiOperation({ summary: 'Get a single user with id' })
  @ApiOkResponse({
    description: 'Successfully got an user data from the users table',
    type: Array<UserInfoDto>,
  })
  @ApiForbiddenResponse({
    description: 'Not enough permissions to execute this request',
  })
  async findOneById(@Param() params: any): Promise<User[]> {
    return await this.usersService.findOneById(params.id);
  }

  @Get('ByUsername/:username')
  @Roles(['admin'])
  @UseGuards(AuthGuard('jwt'), ThrottlerGuard)
  @ApiOperation({ summary: 'Get a single user with username' })
  @ApiOkResponse({
    description: 'Successfully got an user data from the users table',
    type: Array<UserInfoDto>,
  })
  @ApiForbiddenResponse({
    description: 'Not enough permissions to execute this request',
  })
  async findOneByUsername(@Param() params: any): Promise<User[]> {
    return await this.usersService.findOneByUsername(params.username);
  }
}
