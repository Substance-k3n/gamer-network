import { pollEndsAt, postShapeErrors } from './post-rules.js';

const poll = { options: ['Yes', 'No'], duration: '1d' as const };
const recruit = { slots: 2 };

describe('postShapeErrors', () => {
  it('needs a photo on gameplay, and allows photos on any type', () => {
    expect(postShapeErrors({ type: 'gameplay' })).toEqual({ media: 'Add at least one photo' });
    expect(postShapeErrors({ type: 'gameplay', media: [] })).toEqual({
      media: 'Add at least one photo',
    });
    expect(postShapeErrors({ type: 'gameplay', media: ['k'] })).toBeNull();
    expect(postShapeErrors({ type: 'meme', media: ['k'] })).toBeNull();
    expect(postShapeErrors({ type: 'milestone' })).toBeNull();
  });

  it('needs a poll on poll posts only', () => {
    expect(postShapeErrors({ type: 'poll' })).toEqual({ poll: 'Add 2 to 4 options' });
    expect(postShapeErrors({ type: 'poll', poll })).toBeNull();
    expect(
      postShapeErrors({ type: 'poll', poll: { ...poll, options: ['Jett', ' jett '] } }),
    ).toEqual({ 'poll.options': 'Each option must be different' });
    expect(postShapeErrors({ type: 'question', poll })).toEqual({
      poll: 'Only poll posts have a poll',
    });
  });

  it('needs slots on recruitment posts only', () => {
    expect(postShapeErrors({ type: 'recruitment' })).toEqual({
      recruit: 'Say how many players you need',
    });
    expect(postShapeErrors({ type: 'recruitment', recruit })).toBeNull();
    expect(postShapeErrors({ type: 'poll', poll, recruit })).toEqual({
      recruit: 'Only recruitment posts have slots',
    });
  });
});

describe('postShapeErrors in a group', () => {
  const groupId = '0192f0a0-0000-7000-8000-000000000000';
  it('refuses audience=connections on group posts only', () => {
    expect(postShapeErrors({ type: 'question', groupId, audience: 'connections' })).toEqual({
      audience: 'Group posts are for everyone in the group',
    });
    expect(postShapeErrors({ type: 'question', groupId, audience: 'everyone' })).toBeNull();
    expect(postShapeErrors({ type: 'question', groupId })).toBeNull();
    expect(postShapeErrors({ type: 'question', audience: 'connections' })).toBeNull();
  });
});

describe('pollEndsAt', () => {
  it('is 1 day, 3 days or a week from now', () => {
    const now = new Date('2026-10-20T10:00:00Z');
    expect(pollEndsAt('1d', now).toISOString()).toBe('2026-10-21T10:00:00.000Z');
    expect(pollEndsAt('3d', now).toISOString()).toBe('2026-10-23T10:00:00.000Z');
    expect(pollEndsAt('1w', now).toISOString()).toBe('2026-10-27T10:00:00.000Z');
  });
});
