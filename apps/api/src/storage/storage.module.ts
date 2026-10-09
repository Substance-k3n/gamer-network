import { Global, Module } from '@nestjs/common';
import { MEDIA_STORAGE, S3MediaStorage } from './storage.js';

@Global()
@Module({
  providers: [{ provide: MEDIA_STORAGE, useFactory: () => new S3MediaStorage() }],
  exports: [MEDIA_STORAGE],
})
export class StorageModule {}
