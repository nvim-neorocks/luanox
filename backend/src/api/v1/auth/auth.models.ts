import { ApiProperty } from '@nestjs/swagger';

export class JwtAuth {
  @ApiProperty({ description: 'JWT token' })
  accessToken: string;
}

export class UserDetails {
  @ApiProperty({ description: "User's GitHub ID", example: 36456999 })
  id: number;

  @ApiProperty({ description: 'User name', example: 'NTBBloodbath' })
  name: string;

  @ApiProperty({ description: 'User email', example: 'bloodbathalchemist@protonmail.com' })
  email: string;
}
