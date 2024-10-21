import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class UserInfoDto {
  @ApiProperty({ description: 'User ID', example: 27 })
  userId: number;

  @ApiProperty({ description: 'User name', example: 'vhyrro' })
  username: string;

  @ApiProperty({ description: 'User alt name', example: 'neorg' })
  aka: string;

  @ApiProperty({ description: 'User role', example: 'user' })
  role: string;
}

export class UserUpdateDto {
  @ApiPropertyOptional({ description: 'User name', example: 'vhyrro' })
  username?: string;

  @ApiPropertyOptional({ description: 'User alt name', example: 'neorg' })
  aka?: string;

  @ApiPropertyOptional({ description: 'User role', example: 'user' })
  role?: string;
}

export class UserDeleteDto {
  @ApiProperty({ description: 'User ID', example: 27 })
  id: number;
}
