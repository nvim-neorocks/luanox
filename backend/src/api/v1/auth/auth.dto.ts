import { ApiProperty } from '@nestjs/swagger';

export class JwtAuthDto {
  @ApiProperty({ description: 'JWT token' })
  accessToken: string;
}
