# Feed, groups and moments: what the API needs

The rally prototype's Home feed, Groups and profile Moments, written as
an API to build. It is for the backend developer: every screen, the
tables, the endpoints with their rules and errors, notifications,
moderation, and the tests that prove it works. The mobile app, the web
PWA and the admin integrate once it exists.

**Status:** accepted with [ADR-0012](decisions/0012-feed-and-groups-in-the-mvp.md).
Phase 1 (section 10) is built and hidden behind `feedEnabled`; the rest
is not.

**Source of truth for the screens:** the prototype at
`Natnsis/rally` (`lib/screens/home.dart`, `compose.dart`, `groups.dart`,
`profile.dart`, `lib/state.dart`, `lib/data.dart`). Where this file and
the prototype differ, this file is the plan and the prototype is the
look.

Everything follows [API.md](API.md) "Conventions": `/v1`, bearer token,
`camelCase`, ISO 8601 UTC times, UUID v7 ids, one error shape, cursor
pages (`{ items, nextCursor }`), `Idempotency-Key` on creates, signed
upload URLs. New tables follow [DATA_MODEL.md](DATA_MODEL.md) and go in
`apps/api/src/db/schema` with a Drizzle migration. The OpenAPI spec is
regenerated as usual; never hand-edit it.

---

## 1. What the screens do

### Home feed

- **Filter pill** ("For you"): `For you`, `Connections`,
  `LFG & recruiting`, then one entry per game on the viewer's profile.
- **Post card:**
  - Header: avatar, display name, `@username`, age ("2h"), the poster's
    rank and game ("Diamond Valorant"), and a type tag ("MILESTONE").
  - Body: the text, then whatever the type carries (see the table below).
  - Action row:
    - **comments**, with a count ("answers" on discussions);
    - **GG**, a like with a count, toggled;
    - **Play**, which starts playing with the poster;
    - **save**, as a bookmark;
    - **share**;
    - **⋯**: report or delete.
- **Comments** open under the post: the list, GG on a comment, Reply,
  and a "Write a comment…" field.
- **+ button** opens the composer.

**What each type shows:**

| Type                  | Kind on the card | Extra content                                                                   |
| --------------------- | ---------------- | ------------------------------------------------------------------------------- |
| `discussion`          | discussion       | Big title, the top answer in a dashed box, "Add your answer…"                   |
| `gameplay`            | moment           | Up to 4 photos or videos; a video shows a play button and its length ("00:24")  |
| `recruitment`         | recruit          | SLOTS and ROLES NEEDED, and **Apply** (it changes to "Applied ✓")               |
| `poll`                | poll             | 2–4 options with bars and percentages, "YOU VOTED", and the time left ("1 day") |
| `milestone`           | text             |                                                                                 |
| `question`            | text             |                                                                                 |
| `looking_for_players` | text             | Counts as LFG in the filter                                                     |
| `tip_guide`           | text             |                                                                                 |
| `review`              | text             |                                                                                 |
| `event`               | text             |                                                                                 |
| `meme`                | text             | Usually with an image                                                           |

Any text-kind type may carry media too; `gameplay` requires at least one
file.

### Composer (the + button)

- **Type:** the 11 types above.
- **Game:** one of the poster's games, or "Any game".
- **Audience:** `Everyone` or `Connections`.
- **Text:** with a placeholder per type.
- **Media:** up to 4 photos or videos from the gallery.
- **Poll:** 2–4 options and a duration (`1 day`, `3 days`, `1 week`).
- **Recruitment:** slots (1–10) and roles (free text, e.g. "Sniper,
  Support").
- **Post button:** enabled when the text is set and, for a poll, at least
  2 options are filled in.

### Groups tab

- **Header card:** "Your squad, your game, your city or campus" with
  **Create group**.
- **Tabs:** `Discover` and `Yours (n)`.
- **Search:** "Search groups, games, cities".
- **Kind chips:** `All`, `Game`, `City`, `Campus`, `Squad`.
- **Group card:**
  - a short-code badge ("VAL") in the group's colour;
  - name and line ("Valorant · Ethiopia");
  - about (2 lines);
  - 3 member avatars and the member count ("1,201 members");
  - the next event ("Next: Tonight 21:00");
  - **Join**, **Requested** or **Joined ✓**.

### Group page

- **Header:** badge, name, line, member count and "since" (month and
  year).
- **Actions:** **Join** (or **Requested** when approval is on) and
  **Leave**. The last admin can't leave.
- **About and rules:** up to 10 rules.
- **Events:** title, time, game, a count of who's going with their
  avatars, and **Going** toggled. Members add events.
- **Posts:** the group's own feed, where members post (text). These
  don't appear on Home.
- **Members:** the list, with an admin badge. Admins approve or decline
  join requests and can make someone admin.

### Create group

Name (3–40), kind, game (required when the kind is Game), place (city,
campus or country), about (up to 500), colour, and "Approve new members".
The creator becomes admin.

### Profile

- **Moments:** that person's posts, newest first. Empty state: "No posts
  yet. Share a milestone from Home."
- **Groups:** the groups they're in. Empty state: "You haven't joined any
  groups yet. Find groups".

### Alerts (new rows)

The prototype's activity list shows these alongside today's alerts:

- "reacted GG to your post";
- "commented on your post";
- "replied to your comment";
- "mentioned you in a discussion";
- "applied to your recruitment post";
- "accepted your application";
- "wants to join your group";
- "approved your request to join";
- "added an event in" a group.

---

## 2. What already exists and is reused

| Need                            | Already there                                                                                             |
| ------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Who someone is on a card        | `UserCard` (avatar, name, username, city, status, top game)                                               |
| Rank and game in the header     | `UserCard.topGame` (game, rank)                                                                           |
| Games and the "per game" filter | `GET /v1/games`, `Me.games`                                                                               |
| Connections filter, audience    | `connections` table                                                                                       |
| **Play** on a post              | `POST /v1/play-invites` if connected (`403 not_connected` otherwise), else `POST /v1/connection-requests` |
| Hiding blocked people           | `blocks` both ways, the same `visibleTo` rule listings use                                                |
| Uploads                         | The signed-URL flow and private bucket of ADR-0009 (avatars)                                              |
| Idempotent creates, cursors     | `Idempotency-Key`, `encodeCursor`/`decodeCursor`                                                          |
| Reports, bans, audit            | `reports`, `admin_actions`, the admin report queue                                                        |
| Push and the Alerts list        | `notifications` with its outbox (`pushed_at`)                                                             |
| Share links                     | `apps/web` share pages (`/l/<id>` today; `/p/<id>` for posts)                                             |

---

## 3. Data model

New enums:

| Enum                 | Values                                                                                                                                  |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `post_type`          | `discussion`, `gameplay`, `recruitment`, `poll`, `milestone`, `question`, `looking_for_players`, `tip_guide`, `review`, `event`, `meme` |
| `post_audience`      | `everyone`, `connections`                                                                                                               |
| `content_status`     | `live`, `deleted` (by its author), `removed` (by an admin or group admin)                                                               |
| `media_kind`         | `image`, `video`                                                                                                                        |
| `application_status` | `pending`, `accepted`, `declined`                                                                                                       |
| `group_kind`         | `game`, `city`, `campus`, `squad`                                                                                                       |
| `group_tone`         | `accent`, `lav`, `soft`, `grey` (the prototype's colours)                                                                               |
| `group_role`         | `admin`, `member`                                                                                                                       |
| `membership_status`  | `member`, `pending`                                                                                                                     |

Added to existing enums:

- **`notification_type`:** `post_gg`, `post_comment`, `comment_reply`,
  `mention`, `recruit_application`, `recruit_accepted`,
  `group_join_request`, `group_join_approved`, `group_event`.
- **`admin_action_kind`:** `remove_post`, `remove_comment`,
  `remove_group`.

Tables (all ids UUID v7, all with `created_at`):

**`posts`**

- **Columns:**
  - `id`;
  - `author_id`;
  - `group_id` (null on Home);
  - `type` post_type;
  - `game_id` (null for "Any game");
  - `text`: 1–2000, trimmed;
  - `audience` post_audience, default `everyone`;
  - `status` content_status, default `live`;
  - no stored counts: GG and comment counts are counted from `post_gg`
    and `comments` when read, leaving out banned and deleted people, so
    bans, unbans, blocks and deletions never leave them wrong (phase 1);
  - `removed_at`, `removed_by` (both null until removed).
- **Indexes:**
  - `(status, id DESC)` for the feed;
  - `(author_id, id DESC)` for Moments;
  - `(group_id, id DESC)` for a group's posts.

**`post_media`**

- **Columns:**
  - `id`, `post_id`;
  - `position` 0–3;
  - `kind` media_kind;
  - `key` (in the bucket), `content_type`, `size`, `width`, `height`;
  - `duration_ms` (null for images);
  - `poster_key` (null for images; the video's still frame).
- **Unique:** `(post_id, position)`.

**`poll_options`**: `post_id`, `position` 0–3, `label` 1–60,
`vote_count`. PK `(post_id, position)`. Polls also need `polls`:
`post_id` PK, `ends_at`.

**`poll_votes`**: PK `(post_id, user_id)`, `position`. One vote, final.

**`recruitments`**: `post_id` PK, `slots` 1–10, `roles` 0–80.

**`recruit_applications`**: `id`, `post_id`, `user_id`, `status`
application_status, `decided_at` null. Unique `(post_id, user_id)`.

**`post_gg`**: PK `(post_id, user_id)`.

**`saved_posts`**: PK `(user_id, post_id)`, index `(user_id, created_at DESC)`.

**`comments`**

- **Columns:**
  - `id`, `post_id`, `author_id`;
  - `parent_id` (null for a top-level comment; one level of replies, so a
    reply to a reply attaches to the same parent);
  - `text`: 1–500;
  - `status` content_status;
  - `removed_at`, `removed_by`.
- **Index:** `(post_id, id)`, and `(parent_id, id)` for replies.

**`comment_gg`**: PK `(comment_id, user_id)`.

**`groups`**

- **Columns:**
  - `id`;
  - `name` 3–40, unique case-insensitively;
  - `short` 2–5 uppercase, made from the name when not given;
  - `kind` group_kind;
  - `game_id` (required when the kind is `game`);
  - `place` 1–60;
  - `about` 0–500;
  - `rules` text[] (at most 10, each up to 140);
  - `tone` group_tone;
  - `approval` bool, default false;
  - `created_by`;
  - `member_count`, kept in step;
  - `status` content_status.

**`group_members`**: PK `(group_id, user_id)`, `role` group_role,
`status` membership_status, `joined_at` null until a member. Index
`(user_id, status)`.

**`group_events`**: `id`, `group_id`, `created_by`, `title` 1–80,
`starts_at`, `game_id` null, `going_count`. Index `(group_id, starts_at)`.

**`group_event_going`**: PK `(event_id, user_id)`.

**`media_uploads`**: `key` PK, `user_id`, `kind`, `content_type`,
`size`, `expires_at`, `used_at` null. A post can only use keys its author
uploaded, once. A daily job deletes unused objects older than a day.

Extra columns on existing tables:

- **`reports`:** `post_id`, `comment_id`, `group_id` (all null).
- **`notifications`:** `post_id`, `comment_id`, `group_id`,
  `recruit_application_id`, `group_event_id` (all null).
- **`admin_actions`:** `post_id`, `comment_id`, `group_id` (all null).

---

## 4. Shapes

```ts
Post {
  id, type: PostType, kind: "text" | "moment" | "discussion" | "poll" | "recruit",
  author: UserCard,                 // topGame gives "Diamond Valorant"
  group: { id, name, short, tone } | null,
  game: GameRef | null,             // null = "Any game"
  text, audience: "everyone" | "connections",
  media: Media[],                   // in position order, 0–4
  poll: Poll | null,
  recruit: Recruit | null,
  topComment: Comment | null,       // discussions: the most-GG'd answer
  ggCount, commentCount,
  myGG: boolean, saved: boolean, mine: boolean,
  shareUrl,                         // https://<web>/p/<id>
  createdAt
}

Media {
  id, kind: "image" | "video",
  url, posterUrl | null,            // signed, use as given (ADR-0009)
  width, height, durationMs | null
}

Poll {
  options: [{ position, label, votes }],
  totalVotes, myVote: number | null, // position
  endsAt, closed: boolean
}

Recruit {
  slots, roles,
  applications: number,             // the author sees the list
  myApplication: "pending" | "accepted" | "declined" | null
}

Comment {
  id, postId, parentId | null,
  author: UserCard, text,
  ggCount, myGG: boolean, mine: boolean,
  replies: number,                  // top-level comments only
  createdAt
}

Group {
  id, name, short, kind: GroupKind, game: GameRef | null,
  place, about, rules: string[], tone: GroupTone, approval: boolean,
  memberCount, membersPreview: UserCard[],   // up to 3, connections first
  nextEvent: GroupEvent | null,
  myRole: "admin" | "member" | null,
  myStatus: "member" | "pending" | null,
  createdAt                          // "since Mar 2025"
}

GroupEvent {
  id, groupId, title, startsAt, game: GameRef | null,
  goingCount, goingPreview: UserCard[],      // up to 3
  imGoing: boolean, createdBy: UserCard
}
```

`kind` follows from `type`:

- `discussion` → discussion;
- `poll` → poll;
- `recruitment` → recruit;
- `gameplay` → moment;
- anything else → text.

Clients draw by `kind` and label by `type`.

---

## 5. Endpoints

All need a signed-in, onboarded player unless marked otherwise. "Hidden"
means `404`, as everywhere else: deleted, removed, blocked either way,
from a banned author, or connections-only and the viewer isn't
connected.

### Feed and posts

| Method | Path                                    | What it does                                                                                                                                                                                                                                                                |
| ------ | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET    | `/v1/feed?filter=&game=&cursor=&limit=` | `Page<Post>`, newest first. `filter`: `for_you` (default: every visible Home post), `connections` (yours and your connections'), `lfg` (types `recruitment` and `looking_for_players`), `game` (needs `game=<id>`). Group posts never appear here. `limit` 1–30, default 20 |
| GET    | `/v1/posts/{id}`                        | `Post`. Group posts: members only, others `404`                                                                                                                                                                                                                             |
| POST   | `/v1/posts`                             | **Idempotent.** `CreatePostBody` → `201 Post`. Needs a verified email (`403 email_not_verified`)                                                                                                                                                                            |
| DELETE | `/v1/posts/{id}`                        | Author, or a group admin for group posts → `204`. Sets `status=deleted` (or `removed` by a group admin)                                                                                                                                                                     |
| PUT    | `/v1/posts/{id}/gg`                     | GG it → `{ ggCount, myGG: true }`. Repeating it is fine                                                                                                                                                                                                                     |
| DELETE | `/v1/posts/{id}/gg`                     | Un-GG → `{ ggCount, myGG: false }`                                                                                                                                                                                                                                          |
| PUT    | `/v1/posts/{id}/save`                   | `204`                                                                                                                                                                                                                                                                       |
| DELETE | `/v1/posts/{id}/save`                   | `204`                                                                                                                                                                                                                                                                       |
| GET    | `/v1/me/saved?cursor=`                  | `Page<Post>`, most recently saved first; hidden ones left out                                                                                                                                                                                                               |
| POST   | `/v1/posts/{id}/vote`                   | `{ position }` → `Poll`. `409 already_voted`, `409 poll_closed`, `422` for a bad position. Voting on your own poll is allowed                                                                                                                                               |
| POST   | `/v1/posts/{id}/apply`                  | **Idempotent.** → `Recruit`. `409 already_applied`, `403 own_post`, `409 recruitment_full` when accepted = slots. Notifies the author                                                                                                                                       |
| GET    | `/v1/posts/{id}/applications?cursor=`   | Author only (`403 not_owner`) → `Page<{ id, user: UserCard, status, createdAt }>`                                                                                                                                                                                           |
| POST   | `/v1/recruit-applications/{id}/accept`  | Author only → `{ id, status: "accepted" }`. Notifies the applicant. Also sends a connection request from the author if they aren't connected, so they can play together                                                                                                     |
| POST   | `/v1/recruit-applications/{id}/decline` | Author only → `{ id, status: "declined" }`. No notification                                                                                                                                                                                                                 |
| GET    | `/v1/users/{username}/posts?cursor=`    | Moments: `Page<Post>` of their Home posts you may see                                                                                                                                                                                                                       |
| GET    | `/v1/me/posts?cursor=`                  | Your own, including connections-only                                                                                                                                                                                                                                        |
| GET    | `/v1/public/posts/{id}`                 | **No sign-in.** For the `apps/web` share page: `{ id, type, text (first 300 chars), author: { displayName, username, avatarUrl }, game, media: first image only, createdAt }`. Only `everyone` posts that aren't in a group; others `404`                                   |

`CreatePostBody`:

```ts
{
  type: PostType,
  text: string,                       // 1–2000, trimmed
  gameId?: string | null,             // one of GET /v1/games; null = "Any game"
  audience?: "everyone" | "connections",   // default everyone
  groupId?: string,                   // a group you're a member of; posts there only
  media?: [{ key, kind, width, height, durationMs?, posterKey? }],  // 0–4, from /v1/media/upload-url
  poll?: { options: string[], duration: "1d" | "3d" | "7d" },       // required when type = poll; 2–4 options, 1–60 each, unique
  recruit?: { slots: number, roles?: string }                      // required when type = recruitment; slots 1–10, roles ≤ 80
}
```

`422` with `fields` when:

- `media` is empty on `gameplay`;
- `poll` is missing on `poll`, or sent on any other type;
- the same for `recruit` and `recruitment`;
- a media key isn't yours, is already used or has expired;
- more than one video is attached (the limit is 1 per post; images can
  go with it);
- a group post sets `audience=connections` (group posts are for the
  group).

`403 not_member` for a group you aren't in.

### Media uploads

| Method | Path                   | What it does                                                                                                                                                                                          |
| ------ | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| POST   | `/v1/media/upload-url` | `{ contentType, size }` → `{ uploadUrl, headers, key, expiresAt }`, the same flow as the avatar upload. Images: `image/jpeg`, `image/png`, `image/webp`, up to 10 MB. Video: `video/mp4`, up to 50 MB |

The flow:

1. **Images:** the phone resizes them first (longest side 1600 px).
2. **Videos:** the phone keeps clips to 60 seconds or less, picks a frame
   for the poster, and uploads the poster as an image too.
3. **Upload:** each file goes to its `uploadUrl`.
4. **Create the post:** `POST /v1/posts` with the keys.

The API checks each object exists, by HEAD, with the type and size
promised. Responses give signed URLs, as for avatars.

`429 rate_limited`: 30 upload URLs per user per hour.

### Comments

| Method | Path                                     | What it does                                                                                                                                   |
| ------ | ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| GET    | `/v1/posts/{id}/comments?cursor=&limit=` | Top-level comments, oldest first (`Page<Comment>`). Discussions: `?sort=top` orders by GG                                                      |
| GET    | `/v1/comments/{id}/replies?cursor=`      | Replies, oldest first                                                                                                                          |
| POST   | `/v1/posts/{id}/comments`                | **Idempotent.** `{ text, parentId? }` → `201 Comment`. Needs a verified email. Notifies the post's author, and the parent's author for a reply |
| DELETE | `/v1/comments/{id}`                      | Author, the post's author, or a group admin → `204`                                                                                            |
| PUT    | `/v1/comments/{id}/gg`                   | → `{ ggCount, myGG: true }`                                                                                                                    |
| DELETE | `/v1/comments/{id}/gg`                   | → `{ ggCount, myGG: false }`                                                                                                                   |

**Mentions:** `@username` in a post or comment notifies that user once
per post or comment, if they can see it. At most 5 mentions get
notified.

### Groups

| Method | Path                                       | What it does                                                                                                                                                                                                                 |
| ------ | ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET    | `/v1/groups?tab=&kind=&query=&cursor=`     | `Page<Group>`. `tab`: `discover` (default; groups that are live, most members first, then newest) or `mine` (yours and pending, most recent activity first). `kind` filters; `query` (2+ chars) matches name, game and place |
| GET    | `/v1/groups/{id}`                          | `Group`                                                                                                                                                                                                                      |
| POST   | `/v1/groups`                               | **Idempotent.** `{ name, kind, gameId?, place, about?, rules?, tone?, approval? }` → `201 Group`, with you as admin. `409 group_name_taken`. Verified email. 3 per user per day                                              |
| PATCH  | `/v1/groups/{id}`                          | Admins: any of the create fields except `kind` → `Group`                                                                                                                                                                     |
| POST   | `/v1/groups/{id}/join`                     | → `Group` with `myStatus` `member`, or `pending` when approval is on (admins get `group_join_request`). `409 already_member`                                                                                                 |
| DELETE | `/v1/groups/{id}/membership`               | Leave, or cancel a pending request → `204`. `409 last_admin` when you're the only admin and others remain. The last member leaving archives the group                                                                        |
| GET    | `/v1/groups/{id}/members?status=&cursor=`  | `Page<{ user: UserCard, role, status, joinedAt }>`. `status=pending` is for admins only                                                                                                                                      |
| POST   | `/v1/groups/{id}/members/{userId}/approve` | Admins → `204`; notifies them (`group_join_approved`)                                                                                                                                                                        |
| POST   | `/v1/groups/{id}/members/{userId}/decline` | Admins → `204`, without telling them                                                                                                                                                                                         |
| PUT    | `/v1/groups/{id}/members/{userId}/role`    | Admins: `{ role }` → `204`                                                                                                                                                                                                   |
| DELETE | `/v1/groups/{id}/members/{userId}`         | Admins remove a member → `204`                                                                                                                                                                                               |
| GET    | `/v1/groups/{id}/posts?cursor=`            | `Page<Post>` of the group, newest first. Members only                                                                                                                                                                        |
| GET    | `/v1/groups/{id}/events?cursor=`           | Upcoming events (from `startsAt` an hour ago), soonest first. Visible to everyone, so Discover can show "Next: …"                                                                                                            |
| POST   | `/v1/groups/{id}/events`                   | Members: `{ title, startsAt, gameId? }` → `201 GroupEvent`. `startsAt` within the next 60 days. Notifies members (`group_event`), batched                                                                                    |
| DELETE | `/v1/group-events/{id}`                    | Its creator or an admin → `204`                                                                                                                                                                                              |
| PUT    | `/v1/group-events/{id}/going`              | Members → `GroupEvent`                                                                                                                                                                                                       |
| DELETE | `/v1/group-events/{id}/going`              | → `GroupEvent`                                                                                                                                                                                                               |
| GET    | `/v1/users/{username}/groups`              | The groups they're a member of (profile)                                                                                                                                                                                     |

### App config

`GET /v1/app/config` gains `feedEnabled` and `groupsEnabled` booleans.
The apps show the prototype's Home and Groups only when they're true;
`groupsComingSoon` goes away once groups ship. With this, the API can be
deployed and switched on without waiting for an app release, and an app
released early still works against an older API.

---

## 6. Notifications

Written in the same transaction as the event, like today's, so they go
through the push outbox. Each row links what the tap opens.

| Type                  | To                        | Text in Alerts                                                   | Push | Opens                   |
| --------------------- | ------------------------- | ---------------------------------------------------------------- | ---- | ----------------------- |
| `post_gg`             | Post author               | "Meron reacted GG to your post"                                  | No   | The post                |
| `post_comment`        | Post author               | "Dave commented on your post"                                    | Yes  | The post, comments open |
| `comment_reply`       | Parent comment's author   | "Hana replied to your comment"                                   | Yes  | The post, comments open |
| `mention`             | Mentioned user            | "Liya mentioned you in a discussion"                             | Yes  | The post                |
| `recruit_application` | Recruitment post's author | "Abel applied to your recruitment post"                          | Yes  | Applications list       |
| `recruit_accepted`    | Applicant                 | "Meron accepted your application"                                | Yes  | Their profile           |
| `group_join_request`  | Group admins              | "Yonas wants to join Valorant Ethiopia"                          | Yes  | Members, pending        |
| `group_join_approved` | New member                | "You're in Valorant Ethiopia"                                    | Yes  | The group               |
| `group_event`         | Group members             | "New event in Valorant Ethiopia: 5-stack customs, tonight 21:00" | Yes  | The group               |

**Rules:**

- **No self-notifications:** you never get one about your own action.
- **GG doesn't stack:** one `post_gg` row per post stays unread and
  counts up ("Meron and 4 others reacted GG").
- **Events don't flood:** at most 1 `group_event` push per group per
  hour.
- **Blocks and visibility:** blocked people never notify each other, and
  nobody is notified about content they can't see.

---

## 7. Safety and moderation (ADR-0005; needed for the Play Store)

Moderation ships in the same release as posting:

- **Report anything:** `POST /v1/reports` accepts `postId`, `commentId`
  or `groupId` beside `userId` (the author, or the group's creator). The
  same reasons, and `Idempotency-Key`.
- **Blocks cover the new content:** a block hides the other person's
  posts, comments, GGs, applications and group content both ways, as for
  listings. Group membership stays, but their posts are hidden from you.
- **Banning hides everything:** a ban hides all the user's posts,
  comments and groups they created alone (it sets the status, so an
  unban restores them).
- **Deleting an account:** deletes their posts, comments and media
  (`status=deleted`, with media objects removed in the 30-day scrub), and
  groups where they were the only member.
- **Admin queue:** reports show what was reported (the first 300
  characters, the first image, and the group's name) and get three new
  resolve actions: `remove_post`, `remove_comment`, `remove_group`.
- **Admin endpoints** (each writes `admin_actions`):
  - `POST /v1/admin/posts/{id}/remove`;
  - `POST /v1/admin/comments/{id}/remove`;
  - `POST /v1/admin/groups/{id}/remove`.

  Each takes `{ note? }` and returns `204`.

- **Group admins** can remove posts and comments in their group. That's
  logged too, but it isn't an `admin_actions` row; it's `removed_by` on
  the content.

**Rate limits:** each returns `429 rate_limited` with `Retry-After`.

| Action        | Limit per user |
| ------------- | -------------- |
| Posts         | 10 per hour    |
| Comments      | 60 per hour    |
| Upload URLs   | 30 per hour    |
| Groups        | 3 per day      |
| Applications  | 20 per day     |
| Join requests | 30 per day     |

Links in text are allowed but not turned into previews in the MVP.

---

## 8. What each app does once it's built (integration checklist)

### Mobile (`apps/mobile`)

1. Run `tool/generate_api_client.sh`.
2. Gate on `AppConfig.feedEnabled` and `groupsEnabled`, keeping today's
   screens as the fallback.
3. Port the prototype's screens:
   - `home.dart` (feed, post card, comments);
   - `compose.dart`;
   - `groups.dart` (list, group page, create);
   - the Moments and Groups parts of `profile.dart`.

   Swap the seed data for the endpoints above and keep the look.

4. Media:
   - photos and videos from `image_picker` (already a dependency);
   - images resized before upload;
   - videos limited to 60 seconds, with a poster frame
     (`video_thumbnail` or similar).
5. Wire the new notification types into Alerts and their tap targets.
6. Use the share link on posts (`shareUrl`).
7. Widget tests against `FakeApi`. Extend the e2e test to post, comment,
   GG, vote, apply, create a group, join it, add an event and report a
   post.

### Web PWA (`apps/web`)

The same screens under `/app`; uploads go to the signed URL straight
from the browser. Add a share page `/p/<id>` that uses
`GET /v1/public/posts/{id}`, with Open Graph tags like `/l/<id>`.

### Admin (`apps/admin`)

- **Reports:** show the reported post, comment or group, with the three
  new actions.
- **Users drawer:** add posts and groups counts.
- **Overview (optional):** posts per day and active groups.

---

## 9. Tests the API work should include

e2e specs, in `apps/api/test`, one per area, against the test database
like today's:

1. **Posts:**
   - every type creates, with the right `kind`;
   - the type-specific `422`s;
   - the `Idempotency-Key` replay;
   - only your own unused upload keys are accepted.
2. **Feed:**
   - each filter returns the right posts;
   - newest first, and the cursor pages without gaps or duplicates;
   - connections-only posts reach connections and not strangers;
   - group posts never appear on Home;
   - blocked authors and banned authors are hidden both ways.
3. **GG and saves:**
   - toggling twice is safe;
   - the counts match the rows.
4. **Polls:**
   - one vote per person;
   - closed polls refuse votes;
   - the totals add up.
5. **Recruitment:**
   - apply once, not to your own post;
   - accepting notifies, sends a connection request, and fills the
     slots;
   - when full, more applications get `409 recruitment_full`.
6. **Comments:**
   - replies attach to the top-level comment;
   - deleting by the author, the post's author or a group admin;
   - the counts stay right;
   - mentions notify once.
7. **Groups:**
   - create (and a duplicate name gets `409`);
   - join with and without approval;
   - approve and decline;
   - the last admin can't leave;
   - members-only posts;
   - events and going;
   - Discover and Yours, and search.
8. **Notifications:**
   - each new type is written once, never to yourself, never across a
     block;
   - GG notifications add up instead of stacking.
9. **Moderation:**
   - reporting a post, comment or group;
   - the admin removals hide content and write `admin_actions`;
   - a ban hides it and an unban brings it back;
   - account deletion.
10. **Media:** the upload URL refuses a wrong type or size.
11. **Conventions:** every new operation has a summary and a default
    `ErrorResponse` (`test/conventions.e2e-spec.ts` does this already).

---

## 10. Suggested build order

Each phase is one API PR (with its `openapi.json` diff), then the screens
in a separate PR, following the git workflow.

1. **Posts, feed, GG, comments, saves, reports, admin removal, the app
   config flags.** Text posts only. This is enough to switch the feed on.
2. **Media:** upload URLs, images, then video.
3. **Polls and recruitment.**
4. **Groups:** list, page, join and approval, group posts.
5. **Events, Moments and the profile's groups.**

---

## 11. Decisions to make before building

| Question                                     | Suggested answer                                                                |
| -------------------------------------------- | ------------------------------------------------------------------------------- |
| Is "For you" ranked?                         | No. Newest first in the MVP; ranking later, from real data                      |
| Feed scope: everyone, or the viewer's city?  | Everyone in the MVP (one launch city anyway); filter by city later              |
| Video: who pays the bandwidth?               | Check B2 egress and Render's limits before phase 2; cap clips at 60 s and 50 MB |
| Edit a post?                                 | Not in the MVP (the prototype has no edit); delete and post again               |
| Can anyone create a group?                   | Yes, with a verified email and 3 per day; admins can remove groups              |
| Who can add events?                          | Any member (as in the prototype); group admins can delete them                  |
| Does a listing appear in the feed as a card? | Not in this spec. It would help an empty feed at launch; decide with ADR-0012   |
| Profanity filter?                            | Not in the MVP; rely on reports, as for profiles and listings                   |
