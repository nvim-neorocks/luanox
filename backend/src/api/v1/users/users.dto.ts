import { ApiProperty } from '@nestjs/swagger';

export class UserInfoDto {
  @ApiProperty({ description: 'User ID', example: 27 })
  id: number;

  @ApiProperty({ description: 'User name', example: 'vhyrro' })
  username: string;

  @ApiProperty({ description: 'User alt name', example: 'neorg' })
  aka: string;

  @ApiProperty({ description: 'User role', example: 'user' })
  role: string;
}
