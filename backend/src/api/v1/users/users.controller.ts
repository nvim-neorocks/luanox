import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiOkResponse, ApiForbiddenResponse } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { UsersService } from './users.service';
import { User } from './users.interface';
import { UserInfoDto } from './users.dto';
import { Roles } from '../roles/roles.decorator';
import { RolesGuard } from '../auth/auth.guard';

@UseGuards(RolesGuard)
@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) { }

  @Post('create')
  @Roles(['admin'])
  @UseGuards(AuthGuard('jwt'))
  @ApiOperation({ summary: 'Create a new user' })
  @ApiForbiddenResponse({ description: 'Not enough permissions to execute this request' })
  async create(@Body() body: UserInfoDto): Promise<number> {
    return await this.usersService.create(body.username, body.aka, 'user');
  }

  @Get('all')
  @Roles(['admin'])
  @UseGuards(AuthGuard('jwt'))
  @ApiOperation({ summary: 'Get all users' })
  @ApiOkResponse({ description: 'Successfully got all the data from the users table' })
  @ApiForbiddenResponse({ description: 'Not enough permissions to execute this request' })
  async findAll(): Promise<User[]> {
    return await this.usersService.findAll();
  }

  @Get('ById/:id')
  @Roles(['admin'])
  @UseGuards(AuthGuard('jwt'))
  @ApiOperation({ summary: 'Get a single user with id' })
  @ApiOkResponse({ description: 'Successfully got an user data from the users table' })
  @ApiForbiddenResponse({ description: 'Not enough permissions to execute this request' })
  async findOneById(@Param() params: any): Promise<User> {
    return await this.usersService.findOneById(params.id);
  }

  @Get('ByUsername/:username')
  @Roles(['admin'])
  @UseGuards(AuthGuard('jwt'))
  @ApiOperation({ summary: 'Get a single user with username' })
  @ApiOkResponse({ description: 'Successfully got an user data from the users table' })
  @ApiForbiddenResponse({ description: 'Not enough permissions to execute this request' })
  async findOneByUsername(@Param() params: any): Promise<User> {
    const user = await this.usersService.findOneByUsername(params.username);
    return user;
  }
}
