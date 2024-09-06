import { INestApplication } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';

export const SWAGGER_ENV = 'dev';

export const setupSwagger = (app: INestApplication) => {
  // Show swagger documentation only on development environments
  if (SWAGGER_ENV == process.env.NODE_ENV) {
    const swaggerConfig = new DocumentBuilder()
      .setTitle('Luna')
      .setDescription('The Luna lua module host API description')
      .setLicense("GPL-3.0", "https://github.com/NTBBloodbath/luna/blob/master/LICENSE")
      .setVersion('0.1')
      .addTag('auth', 'GitHub authorization')
      .build();
    const swaggerDocument = SwaggerModule.createDocument(app, swaggerConfig);
    SwaggerModule.setup('docs', app, swaggerDocument, {
      customSiteTitle: 'Luna API documentation',
    });
  }
}
