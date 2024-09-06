import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // TODO: add auth to access Swagger
  const swaggerConfig = new DocumentBuilder()
    .setTitle('Luna')
    .setDescription('The Luna lua module host API description')
    .setVersion('0.1')
    .addTag('luna')
    .build();
  const swaggerDocument = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('docs', app, swaggerDocument, {
    customSiteTitle: 'Luna API documentation',
  });

  await app.listen(3000);
}
bootstrap();
