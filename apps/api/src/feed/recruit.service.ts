import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, asc, eq, gt, ne, sql } from 'drizzle-orm';
import type { User } from '../auth/sessions.service.js';
import { AppError, notFound } from '../common/app-error.js';
import { decodeCursor, page, type PageQuery } from '../common/cursor.js';
import { uniqueViolation } from '../common/db-errors.js';
import { checkRate } from '../common/rate-limit.js';
import { ConnectionsService } from '../connections/connections.service.js';
import type { Db, Tx } from '../db/db.js';
import { DB } from '../db/db.module.js';
import { posts, recruitApplications, recruitments, users } from '../db/schema/index.js';
import { ProfileService } from '../me/profile.service.js';
import { isLive, visibleTo } from '../users/visibility.js';
import type {
  ApplicationStatus,
  RecruitApplicationPageDto,
  RecruitDecisionDto,
  RecruitDto,
} from './feed.dto.js';
import { FeedNotifier } from './feed-notifier.js';
import { FeedReader } from './feed-reader.js';

const DAY_MS = 24 * 3600_000;
export const APPLICATIONS_PER_DAY = 20;

type Decision = Exclude<ApplicationStatus, 'pending'>;

const conflict = (code: string, message: string) =>
  new AppError(HttpStatus.CONFLICT, code, message);
const full = () => conflict('recruitment_full', 'Every slot on this post is filled.');
const notOwner = () =>
  new AppError(
    HttpStatus.FORBIDDEN,
    'not_owner',
    'Only the person who posted it can see and answer applications.',
  );

/** docs/FEED_AND_GROUPS_API.md "Feed and posts": apply, and the author's answer. */
@Injectable()
export class RecruitService {
  constructor(
    @Inject(DB) private readonly db: Db,
    private readonly reader: FeedReader,
    private readonly notifier: FeedNotifier,
    private readonly profiles: ProfileService,
    private readonly connections: ConnectionsService,
  ) {}

  /** The recruitment post `viewerId` may see, or 404. */
  private async recruitPost(viewerId: string, postId: string) {
    const post = await this.reader.postRow(viewerId, postId);
    const recruit = await this.db.query.recruitments.findFirst({
      where: eq(recruitments.postId, postId),
    });
    if (!recruit) throw notFound('That recruitment post');
    return { post, recruit };
  }

  /** Accepted applications from people still live: they fill the slots. */
  private async accepted(tx: Tx, postId: string): Promise<number> {
    const [row] = await tx
      .select({ n: sql<number>`count(*)::int` })
      .from(recruitApplications)
      .innerJoin(users, eq(users.id, recruitApplications.userId))
      .where(
        and(
          eq(recruitApplications.postId, postId),
          eq(recruitApplications.status, 'accepted'),
          isLive(),
        ),
      );
    return row!.n;
  }

  /** Once per post, never your own, not when full. Tells the author. 20 a day. */
  async apply(viewer: User, postId: string): Promise<RecruitDto> {
    const { post, recruit } = await this.recruitPost(viewer.id, postId);
    if (post.authorId === viewer.id) {
      throw new AppError(HttpStatus.FORBIDDEN, 'own_post', "You can't apply to your own post.");
    }
    const already = () => conflict('already_applied', 'You already applied to this post.');
    const mine = await this.db.query.recruitApplications.findFirst({
      where: and(eq(recruitApplications.postId, postId), eq(recruitApplications.userId, viewer.id)),
    });
    if (mine) throw already();
    await checkRate(
      this.db,
      recruitApplications,
      { user: recruitApplications.userId, createdAt: recruitApplications.createdAt },
      viewer.id,
      APPLICATIONS_PER_DAY,
      DAY_MS,
      'applications',
      { verb: 'send', per: 'a day' },
    );
    await this.db
      .transaction(async (tx) => {
        // Locks the post, so applying and accepting on it go one at a time.
        await tx.select({ id: posts.id }).from(posts).where(eq(posts.id, postId)).for('update');
        if ((await this.accepted(tx, postId)) >= recruit.slots) throw full();
        const [application] = await tx
          .insert(recruitApplications)
          .values({ postId, userId: viewer.id })
          .returning();
        await this.notifier.applied(tx, post, application!);
      })
      .catch((e: unknown) => {
        if (uniqueViolation(e) === 'recruit_applications_once') throw already();
        throw e;
      });
    return (await this.reader.recruits([postId], viewer.id)).get(postId)!;
  }

  /** Author only: who applied, first come first, leaving out people hidden from you. */
  async applications(
    viewer: User,
    postId: string,
    q: PageQuery,
  ): Promise<RecruitApplicationPageDto> {
    const { post } = await this.recruitPost(viewer.id, postId);
    if (post.authorId !== viewer.id) throw notOwner();
    const limit = q.limit ?? 20;
    const after = decodeCursor(q.cursor);
    const rows = await this.db
      .select({ application: recruitApplications, user: users })
      .from(recruitApplications)
      .innerJoin(users, eq(users.id, recruitApplications.userId))
      .where(
        and(
          eq(recruitApplications.postId, postId),
          visibleTo(this.db, viewer.id),
          after ? gt(recruitApplications.id, after) : undefined,
        ),
      )
      .orderBy(asc(recruitApplications.id))
      .limit(limit + 1);
    const { items, nextCursor } = page(
      rows.map((r) => ({ ...r, id: r.application.id })),
      limit,
    );
    const cards = await this.profiles.cards(items.map((r) => r.user));
    return {
      items: items.map((r, i) => ({
        id: r.application.id,
        user: cards[i]!,
        status: r.application.status,
        createdAt: r.application.createdAt,
      })),
      nextCursor,
    };
  }

  /**
   * Author only. Accepting tells the applicant and, when you aren't
   * connected yet, sends them a connection request so you can play.
   * Declining tells no one. Answering the same way again changes nothing.
   */
  async decide(viewer: User, applicationId: string, status: Decision): Promise<RecruitDecisionDto> {
    const application = await this.db.query.recruitApplications.findFirst({
      where: eq(recruitApplications.id, applicationId),
    });
    if (!application) throw notFound('That application');
    const { post, recruit } = await this.recruitPost(viewer.id, application.postId);
    if (post.authorId !== viewer.id) throw notOwner();
    const [applicant] = await this.db
      .select({ id: users.id })
      .from(users)
      .where(and(eq(users.id, application.userId), visibleTo(this.db, viewer.id)));
    if (!applicant) throw notFound('That application');
    if (application.status === status) return { id: application.id, status };

    const newlyAccepted = await this.db.transaction(async (tx) => {
      await tx.select({ id: posts.id }).from(posts).where(eq(posts.id, post.id)).for('update');
      if (status === 'accepted' && (await this.accepted(tx, post.id)) >= recruit.slots) {
        throw full();
      }
      const [changed] = await tx
        .update(recruitApplications)
        .set({ status, decidedAt: new Date() })
        .where(
          and(eq(recruitApplications.id, application.id), ne(recruitApplications.status, status)),
        )
        .returning();
      if (!changed || status !== 'accepted') return false;
      await this.notifier.accepted(tx, post, changed);
      return true;
    });
    if (newlyAccepted) {
      // The existing request flow, with its rules. Already connected, a
      // request either way, or its limits: nothing more to send.
      await this.connections.send(viewer, { toUserId: application.userId }).catch((e: unknown) => {
        if (!(e instanceof AppError)) throw e;
      });
    }
    return { id: application.id, status };
  }
}
