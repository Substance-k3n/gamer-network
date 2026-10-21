import type { CreatePostBody, PollDuration } from './feed.body.js';

// docs/FEED_AND_GROUPS_API.md "CreatePostBody": the 422s that follow from the
// type alone. Keys, games and groups are checked against the database after.

const DAY_MS = 24 * 3600_000;
const POLL_DAYS: Record<PollDuration, number> = { '1d': 1, '3d': 3, '1w': 7 };

/** The fields that don't fit the post's type, or null when it's fine. */
export function postShapeErrors(
  body: Pick<CreatePostBody, 'type' | 'media' | 'poll' | 'recruit' | 'groupId' | 'audience'>,
): Record<string, string> | null {
  const fields: Record<string, string> = {};
  if (body.type === 'gameplay' && !body.media?.length) {
    fields.media = 'Add at least one photo';
  }
  if (body.type === 'poll' && !body.poll) fields.poll = 'Add 2 to 4 options';
  if (body.type !== 'poll' && body.poll) fields.poll = 'Only poll posts have a poll';
  if (body.type === 'recruitment' && !body.recruit) {
    fields.recruit = 'Say how many players you need';
  }
  if (body.type !== 'recruitment' && body.recruit) {
    fields.recruit = 'Only recruitment posts have slots';
  }
  if (body.groupId && body.audience === 'connections') {
    fields.audience = 'Group posts are for everyone in the group';
  }
  return Object.keys(fields).length ? fields : null;
}

/** When a poll made at `now` closes. */
export const pollEndsAt = (duration: PollDuration, now: Date) =>
  new Date(now.getTime() + POLL_DAYS[duration] * DAY_MS);
