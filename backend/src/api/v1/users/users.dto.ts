import { ApiProperty } from '@nestjs/swagger';

export class UserInfoDto {
  @ApiProperty({ description: 'User ID', example: 27 })
  id: number;

  @ApiProperty({ description: 'User name', example: 'NTBBloodbath' })
  name: string;

  @ApiProperty({ description: 'User role', example: 'user' })
  role: string;
}
