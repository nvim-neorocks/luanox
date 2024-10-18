import { INestApplication } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { SwaggerTheme, SwaggerThemeNameEnum } from 'swagger-themes';

export const SWAGGER_ENV = 'dev';

export const setupSwagger = (app: INestApplication) => {
  // Show swagger documentation only on development environments
  if (SWAGGER_ENV == process.env.NODE_ENV) {
    const swaggerConfig = new DocumentBuilder()
      .setTitle('Luanox')
      .setDescription('The Luanox lua module host API description')
      .setLicense(
        'GPL-3.0',
        'https://github.com/NTBBloodbath/luanox/blob/master/LICENSE',
      )
      .setVersion('0.1')
      .addTag('auth', 'GitHub authorization')
      .addTag('users', 'Users management')
      .build();
    const swaggerDocument = SwaggerModule.createDocument(app, swaggerConfig);
    const theme = new SwaggerTheme();
    SwaggerModule.setup('docs', app, swaggerDocument, {
      customSiteTitle: 'Luanox API documentation',
      customCss: theme.getBuffer(SwaggerThemeNameEnum.NORD_DARK),
    });
  }
};
