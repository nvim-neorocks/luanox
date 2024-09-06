import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';
import { ExtractJwt } from 'passport-jwt';
import { Roles } from '../roles/roles.decorator';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector, private jwtService: JwtService) { }

  matchRole(roles: string[], userRole: string) {
    // NOTE: second conditional makes admin privileges higher than mod privileges
    if (roles.includes(userRole) || (roles.includes('mod') && userRole == 'admin')) {
      return true;
    }
    return false;
  }

  canActivate(context: ExecutionContext): boolean {
    const roles = this.reflector.get(Roles, context.getHandler());
    if (!roles) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const extractToken = ExtractJwt.fromAuthHeaderAsBearerToken()
    const user = this.jwtService.decode(extractToken(request));
    return this.matchRole(roles, user.role);
  }
}
