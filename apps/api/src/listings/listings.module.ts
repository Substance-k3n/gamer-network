import { Module } from '@nestjs/common';
import {
  ListingsController,
  MyListingController,
  PublicListingsController,
} from './listings.controller.js';
import { ListingsService } from './listings.service.js';

@Module({
  controllers: [ListingsController, MyListingController, PublicListingsController],
  providers: [ListingsService],
})
export class ListingsModule {}
