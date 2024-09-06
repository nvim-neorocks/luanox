import { Controller, Get, Req, UseGuards } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { AuthGuard } from '@nestjs/passport';
import { ApiTags, ApiOperation, ApiOkResponse, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { JwtAuth, UserDetails } from './auth.models';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private jwtService: JwtService) { }

  @Get()
  @UseGuards(AuthGuard('github'))
  @ApiOperation({ summary: 'Redirects to GitHub for OAuth2 authorization' })
  @ApiOkResponse({ description: 'Successfully redirected to GitHub' })
  async login() {
    //
  }

  @Get('callback')
  @UseGuards(AuthGuard('github'))
  @ApiOperation({ summary: 'OAuth callback for GitHub' })
  @ApiOkResponse({ description: 'Successfully logged in with GitHub', type: JwtAuth })
  async authCallback(@Req() req: any): Promise<JwtAuth> {
    const user = req.user;
    const payload = { sub: user.id, email: user.emails[0].value, username: user.username };
    return { accessToken: await this.jwtService.signAsync(payload) };
  }

  @Get('profile')
  @UseGuards(AuthGuard('jwt'))
  @ApiOperation({ summary: "Get the current user's profile" })
  @ApiOkResponse({ description: 'The user profile has been successfully obtained', type: UserDetails })
  @ApiUnauthorizedResponse({ description: 'Unauthorized' })
  getProfile(@Req() req: any): UserDetails {
    return req.user;
  }
}
