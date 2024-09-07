import { Controller, Get, Req, UseGuards } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiOkResponse,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { JwtService } from '@nestjs/jwt';
import { AuthGuard } from '@nestjs/passport';
import { ThrottlerGuard } from '@nestjs/throttler';
import { JwtAuthDto } from './auth.dto';
import { UserInfoDto } from '../users/users.dto';
import { UsersService } from '../users/users.service';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(
    private jwtService: JwtService,
    private usersService: UsersService,
  ) {}

  @Get()
  @UseGuards(AuthGuard('github'), ThrottlerGuard)
  @ApiOperation({ summary: 'Redirects to GitHub for OAuth2 authorization' })
  @ApiOkResponse({ description: 'Successfully redirected to GitHub' })
  async login() {}

  @Get('callback')
  @UseGuards(AuthGuard('github'), ThrottlerGuard)
  @ApiOperation({ summary: 'OAuth callback for GitHub' })
  @ApiOkResponse({
    description: 'Successfully logged in with GitHub',
    type: JwtAuthDto,
  })
  async authCallback(@Req() req: any): Promise<JwtAuthDto> {
    const user = req.user;

    // Create a new user if it does not exist yet in the database
    let existingUser = await this.usersService.findOneByUsername(
      user.username,
    )[0];
    if (existingUser === undefined) {
      let userId = await this.usersService.create(user.username, null, 'user');
      existingUser = await this.usersService.findOneById(userId)[0];
    }

    // Jwt
    const payload = {
      sub: existingUser.id,
      username: existingUser.username,
      aka: existingUser.aka,
      role: existingUser.role,
    };
    return { accessToken: await this.jwtService.signAsync(payload) };
  }

  @Get('profile')
  @UseGuards(AuthGuard('jwt'), ThrottlerGuard)
  @ApiOperation({ summary: "Get the current user's profile" })
  @ApiOkResponse({
    description: 'The user profile has been successfully obtained',
    type: UserInfoDto,
  })
  @ApiUnauthorizedResponse({ description: 'Unauthorized' })
  getProfile(@Req() req: any): UserInfoDto {
    return req.user;
  }
}
