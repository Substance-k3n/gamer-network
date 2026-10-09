import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiCreatedResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import {
  BeforeOnboarding,
  CurrentUser,
  Public,
  RequireVerifiedEmail,
} from '../auth/auth.decorators.js';
import type { User } from '../auth/sessions.service.js';
import { notFound } from '../common/app-error.js';
import { CreateListingBody, ListingFeedQuery } from './listings.body.js';
import {
  ListingDto,
  ListingPageDto,
  ListingStatsDto,
  MyListingDto,
  PublicListingDto,
} from './listings.dto.js';
import { ListingsService } from './listings.service.js';

/** A malformed id is just a listing that doesn't exist. */
const listingId = new ParseUUIDPipe({ exceptionFactory: () => notFound('That listing') });

// Operation ids: listingsFeed, listingsCreate, listingsStats, listingsGet,
// listingsClose, myListingGet, publicListingsGet.

@ApiTags('listings')
@ApiBearerAuth()
@Controller('listings')
export class ListingsController {
  constructor(private readonly listings: ListingsService) {}

  /** Find Players. Open listings in your city, newest first; yours and blocked people's left out. */
  @Get()
  @ApiOkResponse({ type: ListingPageDto })
  feed(@CurrentUser() user: User, @Query() query: ListingFeedQuery): Promise<ListingPageDto> {
    return this.listings.feed(user, query);
  }

  /** Post a listing. One live listing each: 409 listing_already_open. */
  @Post()
  @RequireVerifiedEmail()
  @ApiCreatedResponse({ type: ListingDto })
  create(@CurrentUser() user: User, @Body() body: CreateListingBody): Promise<ListingDto> {
    return this.listings.create(user, body);
  }

  /** The Home counter. */
  @Get('stats')
  @ApiOkResponse({ type: ListingStatsDto })
  async stats(@CurrentUser() user: User): Promise<ListingStatsDto> {
    return { lookingNow: await this.listings.lookingNow(user) };
  }

  @Get(':id')
  @ApiOkResponse({ type: ListingDto })
  get(@CurrentUser() user: User, @Param('id', listingId) id: string): Promise<ListingDto> {
    return this.listings.get(user, id);
  }

  /** Owner only. 409 listing_not_live once it has ended. */
  @Post(':id/close')
  @HttpCode(200)
  @ApiOkResponse({ type: ListingDto })
  close(@CurrentUser() user: User, @Param('id', listingId) id: string): Promise<ListingDto> {
    return this.listings.close(user, id);
  }
}

@ApiTags('listings')
@ApiBearerAuth()
@BeforeOnboarding()
@Controller('me/listing')
export class MyListingController {
  constructor(private readonly listings: ListingsService) {}

  /** Your live listing for Home, or null. */
  @Get()
  @ApiOkResponse({ type: MyListingDto })
  async get(@CurrentUser() user: User): Promise<MyListingDto> {
    return { listing: await this.listings.mine(user) };
  }
}

@ApiTags('listings')
@Public()
@Controller('public/listings')
export class PublicListingsController {
  constructor(private readonly listings: ListingsService) {}

  /** For the share page: no sign-in, no ids or gaming IDs. */
  @Get(':id')
  @ApiOkResponse({ type: PublicListingDto })
  get(@Param('id', listingId) id: string): Promise<PublicListingDto> {
    return this.listings.publicListing(id);
  }
}
