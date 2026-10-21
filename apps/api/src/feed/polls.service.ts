import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import type { User } from '../auth/sessions.service.js';
import { AppError, notFound } from '../common/app-error.js';
import type { Db } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { pollOptions, polls, pollVotes } from '../db/schema/index.js';
import type { PollDto } from './feed.dto.js';
import { FeedReader } from './feed-reader.js';

@Injectable()
export class PollsService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly reader: FeedReader,
  ) {}

  /** One vote per person, final; closed polls refuse it. Your own poll is fine. */
  async vote(viewer: User, postId: string, position: number): Promise<PollDto> {
    await this.reader.postRow(viewer.id, postId);
    const poll = await this.db.query.polls.findFirst({ where: eq(polls.postId, postId) });
    if (!poll) throw notFound('That poll');
    if (poll.endsAt <= new Date()) {
      throw new AppError(HttpStatus.CONFLICT, 'poll_closed', 'This poll has closed.');
    }
    const option = await this.db.query.pollOptions.findFirst({
      where: and(eq(pollOptions.postId, postId), eq(pollOptions.position, position)),
    });
    if (!option) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'validation_failed',
        'Some fields need fixing.',
        { position: 'Pick one of the options' },
      );
    }
    const added = await this.db
      .insert(pollVotes)
      .values({ postId, userId: viewer.id, position })
      .onConflictDoNothing()
      .returning({ postId: pollVotes.postId });
    if (added.length === 0) {
      throw new AppError(HttpStatus.CONFLICT, 'already_voted', 'You already voted on this poll.');
    }
    return (await this.reader.polls([postId], viewer.id)).get(postId)!;
  }
}
