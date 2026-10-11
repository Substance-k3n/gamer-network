import { Global, Module } from '@nestjs/common';
import { createMailer, MAILER } from './mailer.js';

@Global()
@Module({
  providers: [{ provide: MAILER, useFactory: createMailer }],
  exports: [MAILER],
})
export class MailModule {}
