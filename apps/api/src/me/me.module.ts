import { Module } from '@nestjs/common';
import { MeController, UsernamesController } from './me.controller.js';

@Module({ controllers: [MeController, UsernamesController] })
export class MeModule {}
