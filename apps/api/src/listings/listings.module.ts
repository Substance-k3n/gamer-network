import { Module } from '@nestjs/common';
import {
  ListingsController,
  MyListingController,
  PublicListingsController,
} from './listings.controller.js';
import { ListingExpiryJob } from './listing-expiry.job.js';
import { ListingsService } from './listings.service.js';

@Module({
  controllers: [ListingsController, MyListingController, PublicListingsController],
  providers: [ListingsService, ListingExpiryJob],
  exports: [ListingExpiryJob],
})
export class ListingsModule {}
