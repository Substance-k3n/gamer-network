import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:rally/api.dart';

// An in-memory API for widget tests: canned responses in the spec's shapes
// (packages/api-spec/openapi.json), and a log of what the app sent.

final _now = DateTime.now().toUtc();
String _at(Duration d) => _now.add(d).toIso8601String();

Map<String, Object?> gameRef(String id, String name, String short) => {
  'id': id,
  'name': name,
  'shortCode': short,
};

Map<String, Object?> card(
  String id,
  String username,
  String name, {
  String status = 'looking',
}) => {
  'id': id,
  'username': username,
  'displayName': name,
  'avatarUrl': null,
  'city': 'Addis Ababa',
  'status': status,
  'statusGame': gameRef('codm', 'CoD Mobile', 'CODM'),
  'topGame': {
    'id': 'ug-$id',
    'game': gameRef('codm', 'CoD Mobile', 'CODM'),
    'customGameName': null,
    'rank': {'id': 'r-master', 'name': 'Master', 'tier': 5},
    'rankText': null,
    'role': null,
  },
};

Map<String, Object?> profile(
  String id,
  String username,
  String name, {
  String relationship = 'none',
  bool onboarded = true,
  String? outgoingRequestId,
}) => {
  ...card(id, username, name),
  'bio': 'Ranked most nights.',
  'ageRange': '18_24',
  'availableDays': ['fri', 'sat'],
  'statusUntil': null,
  'games': [(card(id, username, name)['topGame'])],
  'platforms': ['mobile'],
  'tags': ['competitive', 'fps'],
  'gamingIds': [
    {
      'id': 'gid-$id',
      'kind': 'discord',
      'game': null,
      'value': '$username#1',
      'visibility': 'public',
    },
  ],
  'stats': {'connections': 3, 'games': 1, 'playedWith': 2},
  'relationship': relationship,
  'incomingRequestId': null,
  'outgoingRequestId': outgoingRequestId,
};

Map<String, Object?> me({
  bool onboarded = true,
  bool verified = true,
  List<String> waitlist = const [],
}) => {
  ...profile('me-1', 'kaleb.gg', 'Kaleb', relationship: 'self'),
  'email': 'kaleb@example.com',
  'emailVerified': verified,
  'hasPassword': true,
  'country': 'ET',
  'onboardedAt': onboarded ? _at(const Duration(days: -3)) : null,
  'createdAt': _at(const Duration(days: -3)),
  'role': 'player',
  'waitlist': waitlist,
};

Map<String, Object?> game(
  String id,
  String name,
  String short, {
  bool launch = false,
  List<String> ranks = const [],
  List<String> platforms = const ['mobile'],
}) => {
  'id': id,
  'name': name,
  'shortCode': short,
  'hasRanks': ranks.isNotEmpty,
  'maxParty': 5,
  'isLaunch': launch,
  'platforms': platforms,
  'ranks': [
    for (var i = 0; i < ranks.length; i++)
      {'id': 'r-${ranks[i].toLowerCase()}', 'name': ranks[i], 'tier': i + 1},
  ],
  'roles': <Object>[],
  'modes': [
    {'id': 'm-ranked-$id', 'name': 'Ranked', 'isRanked': true},
    {'id': 'm-casual-$id', 'name': 'Casual', 'isRanked': false},
  ],
};

Map<String, Object?> listing(
  String id,
  Map<String, Object?> owner, {
  Map<String, Object?>? myRequest,
}) => {
  'id': id,
  'owner': owner,
  'game': gameRef('codm', 'CoD Mobile', 'CODM'),
  'mode': {'id': 'm-ranked-codm', 'name': 'Ranked'},
  'rank': {'id': 'r-master', 'name': 'Master', 'tier': 5},
  'platform': 'mobile',
  'partySize': 4,
  'filled': 0,
  'voice': 'required',
  'style': 'competitive',
  'playWhen': 'tonight',
  'durationHours': 6,
  'startsAt': _at(const Duration(minutes: -5)),
  'expiresAt': _at(const Duration(hours: 2, minutes: 14)),
  'note': 'Ranked grind, mics on.',
  'status': 'open',
  'createdAt': _at(const Duration(minutes: -5)),
  'myRequest': myRequest,
  'shareUrl': 'https://example.com/l/$id',
};

Map<String, Object?> post(
  String id,
  Map<String, Object?> author, {
  String type = 'discussion',
  String kind = 'discussion',
  String text = 'Best co-op game you played this month?',
  Map<String, Object?>? game,
  String audience = 'everyone',
  int gg = 4,
  int comments = 1,
  bool mine = false,
  bool saved = false,
  List<String> photos = const [],
  Map<String, Object?>? poll,
  Map<String, Object?>? recruit,
  Map<String, Object?>? group,
}) => {
  'id': id,
  'type': type,
  'kind': kind,
  'audience': audience,
  'author': author,
  'game': game,
  'text': text,
  'topComment': null,
  'ggCount': gg,
  'commentCount': comments,
  'myGG': false,
  'saved': saved,
  'mine': mine,
  'media': [
    for (var i = 0; i < photos.length; i++)
      {
        'id': 'm-$id-$i',
        'kind': 'image',
        'url': photos[i],
        'posterUrl': null,
        'width': null,
        'height': null,
        'durationMs': null,
      },
  ],
  'poll': poll,
  'recruit': recruit,
  'group': group,
  'shareUrl': 'https://example.com/p/$id',
  'createdAt': _at(const Duration(hours: -2)),
};

Map<String, Object?> comment(
  String id,
  String postId,
  Map<String, Object?> author,
  String text, {
  String? parentId,
  bool mine = false,
}) => {
  'id': id,
  'postId': postId,
  'parentId': parentId,
  'author': author,
  'text': text,
  'ggCount': 0,
  'myGG': false,
  'mine': mine,
  'replies': 0,
  'createdAt': _at(const Duration(minutes: -30)),
};

Map<String, Object?> pollOf(
  List<String> labels, {
  List<int>? votes,
  int? myVote,
  bool closed = false,
}) {
  final v = votes ?? [for (final _ in labels) 0];
  return {
    'options': [
      for (var i = 0; i < labels.length; i++)
        {'position': i, 'label': labels[i], 'votes': v[i]},
    ],
    'totalVotes': v.fold<int>(0, (a, b) => a + b),
    'myVote': myVote,
    'endsAt': _at(closed ? const Duration(hours: -1) : const Duration(days: 2)),
    'closed': closed,
  };
}

Map<String, Object?> recruitOf({
  int slots = 3,
  String roles = 'Sniper, IGL',
  int applications = 1,
  String? myApplication,
}) => {
  'slots': slots,
  'roles': roles,
  'applications': applications,
  'myApplication': myApplication,
};

Map<String, Object?> application(
  String id,
  Map<String, Object?> user, {
  String status = 'pending',
}) => {
  'id': id,
  'user': user,
  'status': status,
  'createdAt': _at(const Duration(minutes: -20)),
};

Map<String, Object?> groupEvent(
  String id,
  String groupId,
  String title, {
  Duration from = const Duration(days: 2),
  bool going = false,
  int count = 1,
  Map<String, Object?>? by,
}) => {
  'id': id,
  'groupId': groupId,
  'title': title,
  'startsAt': _at(from),
  'game': gameRef('codm', 'CoD Mobile', 'CODM'),
  'goingCount': count,
  'goingPreview': [dave],
  'imGoing': going,
  'createdBy': by ?? dave,
};

Map<String, Object?> group(
  String id,
  String name, {
  String kind = 'game',
  String tone = 'accent',
  String short = 'CODM',
  bool approval = false,
  String? role,
  String? status,
  int members = 120,
  String about = 'Ranked pushes every night.',
  List<String> rules = const ['Be decent.'],
  Map<String, Object?>? next,
  Map<String, Object?>? by,
}) => {
  'id': id,
  'name': name,
  'short': short,
  'kind': kind,
  'tone': tone,
  'game': kind == 'game' ? gameRef('codm', 'CoD Mobile', 'CODM') : null,
  'place': kind == 'campus' ? 'Addis Ababa University' : 'Addis Ababa',
  'about': about,
  'rules': rules,
  'approval': approval,
  'memberCount': members,
  'membersPreview': [dave, hana],
  'nextEvent': next,
  'myRole': role,
  'myStatus': status,
  'createdBy': by ?? hana,
  'shareUrl': 'https://example.com/app/groups/$id',
  'createdAt': '2025-03-04T10:00:00.000Z',
};

Map<String, Object?> member(
  Map<String, Object?> user, {
  String role = 'member',
  String status = 'member',
}) => {
  'user': user,
  'role': role,
  'status': status,
  'joinedAt': status == 'member' ? _at(const Duration(days: -30)) : null,
};

final meCard = card('me-1', 'kaleb.gg', 'Kaleb');

/// The groups the fake server knows: I run CODM Addis, the others I'm not in.
final codmGroup = group(
  'g-codm',
  'CODM Addis',
  role: 'admin',
  status: 'member',
  next: groupEvent('ev-1', 'g-codm', 'Scrims vs Hawassa'),
);
final fcGroup = group(
  'g-fc',
  'Ethiopian FC Players',
  short: 'FC',
  tone: 'lav',
  members: 860,
  by: dave,
);
final aauGroup = group(
  'g-aau',
  'AAU Gamers',
  kind: 'campus',
  short: 'AAU',
  tone: 'grey',
  approval: true,
  members: 212,
);

const pollText = 'Best map for ranked?';
const recruitText = 'Recruiting for our CODM squad, scrims weekly.';
const photoText = 'Clutch of the week.';

Object? _bodyOf(RequestOptions o) =>
    o.data is String ? jsonDecode(o.data as String) : o.data;

final dave = card('u-dave', 'dave.exe', 'Dave');
final hana = card('u-hana', 'hanaplays', 'Hana', status: 'available_tonight');

/// The fake server. [routes] maps "METHOD /path" to a body (or a
/// function of the request); [sent] records every request.
class FakeApi implements HttpClientAdapter {
  FakeApi({bool onboarded = true, bool verified = true}) {
    routes.addAll({
      'GET /v1/app/config': {
        'minSupportedVersion': '0.0.0',
        'latestVersion': '1.0.0',
        'launchCity': 'Addis Ababa',
        'groupsComingSoon': true,
        'feedEnabled': false,
        'groupsEnabled': false,
      },
      'GET /v1/games': [
        game(
          'codm',
          'CoD Mobile',
          'CODM',
          launch: true,
          ranks: ['Rookie', 'Veteran', 'Elite', 'Pro', 'Master', 'Legendary'],
        ),
        game(
          'efootball',
          'eFootball',
          'EFB',
          launch: true,
          ranks: ['Div 3', 'Div 2', 'Div 1'],
          platforms: ['pc', 'playstation', 'mobile'],
        ),
        game(
          'mc',
          'Minecraft',
          'MC',
          ranks: ['Survival', 'Creative'],
          platforms: ['pc', 'mobile'],
        ),
        game(
          'mlbb',
          'Mobile Legends: Bang Bang',
          'MLBB',
          ranks: ['Warrior', 'Mythical Glory'],
        ),
      ],
      'GET /v1/me': me(onboarded: onboarded, verified: verified),
      'POST /v1/auth/login': {
        'token': 't-1',
        'user': me(onboarded: onboarded, verified: verified),
        'isNew': false,
      },
      'POST /v1/auth/signup': {
        'token': 't-1',
        'user': me(onboarded: false, verified: false),
        'isNew': true,
      },
      'GET /v1/listings/stats': {'lookingNow': 12},
      'GET /v1/me/listing': {'listing': null},
      'GET /v1/me/check-ins': {
        'items': [
          {
            'id': 'ci-1',
            'other': dave,
            'game': gameRef('codm', 'CoD Mobile', 'CODM'),
            'listingId': 'l-1',
            'playInviteId': null,
            'dueAt': _at(const Duration(hours: -1)),
          },
        ],
      },
      'GET /v1/play-invites': {
        'items': [
          {
            'id': 'pi-1',
            'from': hana,
            'to': card('me-1', 'kaleb.gg', 'Kaleb'),
            'game': gameRef('efootball', 'eFootball', 'EFB'),
            'playWhen': 'now',
            'status': 'pending',
            'startsAt': _at(Duration.zero),
            'expiresAt': _at(const Duration(minutes: 15)),
            'createdAt': _at(Duration.zero),
          },
        ],
      },
      'GET /v1/notifications/unread-count': {'count': 2},
      'GET /v1/listings': {
        'items': [listing('l-1', dave), listing('l-2', hana)],
        'nextCursor': null,
      },
      'GET /v1/connection-requests': {
        'items': [
          {
            'id': 'cr-1',
            'from': hana,
            'to': card('me-1', 'kaleb.gg', 'Kaleb'),
            'listing': null,
            'message': null,
            'status': 'pending',
            'createdAt': _at(const Duration(minutes: -30)),
          },
        ],
      },
      'GET /v1/notifications': {
        'items': [
          {
            'id': 'n-1',
            'type': 'connection_accepted',
            'actor': dave,
            'listingId': null,
            'connectionRequestId': 'cr-0',
            'playInviteId': null,
            'checkInId': null,
            'title': 'Connected',
            'text': 'Dave accepted your request',
            'route': '/players/dave.exe',
            'readAt': null,
            'createdAt': _at(const Duration(hours: -1)),
          },
        ],
        'nextCursor': null,
      },
      'POST /v1/notifications/read': null,
      'GET /v1/me/connections': {
        'items': [
          {'user': dave, 'connectedAt': _at(const Duration(days: -1))},
        ],
        'nextCursor': null,
      },
      'GET /v1/users/dave.exe': profile(
        'u-dave',
        'dave.exe',
        'Dave',
        relationship: 'connected',
      ),
      'GET /v1/users/hanaplays': profile('u-hana', 'hanaplays', 'Hana'),
      'GET /v1/users': {
        'items': [dave],
      },
      'GET /v1/me/blocks': {'items': <Object>[]},
      'POST /v1/listings': (RequestOptions o) =>
          listing('l-new', card('me-1', 'kaleb.gg', 'Kaleb')),
      'POST /v1/connection-requests': (RequestOptions o) => {
        'id': 'cr-new',
        'from': card('me-1', 'kaleb.gg', 'Kaleb'),
        'to': hana,
        'listing': null,
        'message': null,
        'status': 'pending',
        'createdAt': _at(Duration.zero),
      },
      'POST /v1/check-ins/ci-1': null,
      'POST /v1/play-invites': (RequestOptions o) => {
        'id': 'pi-2',
        'from': card('me-1', 'kaleb.gg', 'Kaleb'),
        'to': dave,
        'game': gameRef('codm', 'CoD Mobile', 'CODM'),
        'playWhen': 'tonight',
        'status': 'pending',
        'startsAt': _at(Duration.zero),
        'expiresAt': _at(const Duration(minutes: 15)),
        'createdAt': _at(Duration.zero),
      },
      'POST /v1/waitlist': null,
      'POST /v1/reports': null,
      'POST /v1/auth/logout': null,
      'PATCH /v1/me': me(onboarded: onboarded),
      'PUT /v1/me/games': me(onboarded: onboarded),
      'PUT /v1/me/platforms': me(onboarded: onboarded),
      'PUT /v1/me/tags': me(onboarded: onboarded),
      'PUT /v1/me/gaming-ids': me(onboarded: onboarded),
      'PUT /v1/me/status': me(onboarded: onboarded),
      'POST /v1/me/onboard': null,
      'GET /v1/play-invites?direction=outgoing': {
        'items': [
          {
            'id': 'pi-out',
            'from': card('me-1', 'kaleb.gg', 'Kaleb'),
            'to': dave,
            'game': gameRef('codm', 'CoD Mobile', 'CODM'),
            'playWhen': 'tonight',
            'status': 'pending',
            'startsAt': _at(const Duration(hours: 3)),
            'expiresAt': _at(const Duration(hours: 3, minutes: 15)),
            'createdAt': _at(Duration.zero),
          },
        ],
      },
      'GET /v1/usernames/taken.name': {'available': false, 'reason': 'taken'},
      'GET /v1/usernames/free.name': {'available': true},
      'POST /v1/auth/password': null,
      'DELETE /v1/me/avatar': me(onboarded: onboarded),
      'DELETE /v1/connections/u-dave': null,
      'DELETE /v1/connection-requests/cr-mine': null,
      'GET /v1/listings/l-1': listing('l-1', dave),
      'GET /v1/feed': {
        'items': [
          post('p-1', dave),
          post(
            'p-poll',
            hana,
            type: 'poll',
            kind: 'poll',
            text: pollText,
            gg: 7,
            comments: 0,
            poll: pollOf(['Firing Range', 'Standoff'], votes: [3, 1]),
          ),
          post(
            'p-rec',
            dave,
            type: 'recruitment',
            kind: 'recruit',
            text: recruitText,
            gg: 9,
            comments: 0,
            recruit: recruitOf(),
          ),
          post(
            'p-photo',
            hana,
            type: 'gameplay',
            kind: 'moment',
            text: photoText,
            gg: 11,
            comments: 0,
            photos: ['http://media.test/a.jpg', 'http://media.test/b.jpg'],
          ),
        ],
        'nextCursor': null,
      },
      'POST /v1/media/upload-url': (RequestOptions o) {
        final n = ++uploads;
        return {
          'uploadUrl': 'http://storage.test/upload/$n',
          'headers': {'content-type': (_bodyOf(o)! as Map)['contentType']},
          'key': 'media/me-1/k$n.jpg',
          'expiresAt': _at(const Duration(hours: 1)),
        };
      },
      for (var n = 1; n <= 8; n++) 'PUT /upload/$n': null,
      'POST /v1/posts/p-poll/vote': (RequestOptions o) => pollOf(
        ['Firing Range', 'Standoff'],
        votes: [3, 2],
        myVote: (_bodyOf(o)! as Map)['position'] as int,
      ),
      'GET /v1/posts/p-poll': post(
        'p-poll',
        hana,
        type: 'poll',
        kind: 'poll',
        text: pollText,
        poll: pollOf(['Firing Range', 'Standoff'], votes: [3, 1], closed: true),
      ),
      'POST /v1/posts/p-rec/apply': recruitOf(
        applications: 2,
        myApplication: 'pending',
      ),
      'GET /v1/posts/p-myrec': post(
        'p-myrec',
        card('me-1', 'kaleb.gg', 'Kaleb'),
        type: 'recruitment',
        kind: 'recruit',
        text: 'Need two for our eFootball club.',
        mine: true,
        recruit: recruitOf(slots: 2, applications: 2),
      ),
      'GET /v1/posts/p-myrec/applications': {
        'items': [application('ra-1', hana), application('ra-2', dave)],
        'nextCursor': null,
      },
      'POST /v1/recruit-applications/ra-1/accept': {
        'id': 'ra-1',
        'status': 'accepted',
      },
      'POST /v1/recruit-applications/ra-2/decline': {
        'id': 'ra-2',
        'status': 'declined',
      },
      'GET /v1/me/saved': {
        'items': [
          post(
            'p-saved',
            dave,
            text: 'Saved: smoke lineups for every map.',
            saved: true,
            gg: 21,
            comments: 0,
          ),
        ],
        'nextCursor': null,
      },
      'DELETE /v1/posts/p-saved/save': null,
      'GET /v1/groups': (RequestOptions o) {
        final q = o.uri.queryParameters;
        final all = q['tab'] == 'mine'
            ? [codmGroup]
            : [codmGroup, fcGroup, aauGroup];
        final kind = q['kind'];
        final text = (q['query'] ?? '').toLowerCase();
        return {
          'items': [
            for (final g in all)
              if ((kind == null || g['kind'] == kind) &&
                  '${g['name']} ${g['place']}'.toLowerCase().contains(text))
                g,
          ],
          'nextCursor': null,
        };
      },
      'GET /v1/me/groups': {
        'items': [
          codmGroup,
          group('g-pend', 'Hawassa Squad', short: 'HS', status: 'pending'),
        ],
        'nextCursor': null,
      },
      'GET /v1/users/dave.exe/groups': {
        'items': <Object>[],
        'nextCursor': null,
      },
      'GET /v1/users/hanaplays/groups': {
        'items': [fcGroup],
        'nextCursor': null,
      },
      'GET /v1/groups/g-codm': codmGroup,
      'GET /v1/groups/g-fc': fcGroup,
      'GET /v1/groups/g-aau': aauGroup,
      'POST /v1/groups/g-fc/join': {
        ...fcGroup,
        'myRole': 'member',
        'myStatus': 'member',
        'memberCount': 861,
      },
      'POST /v1/groups/g-aau/join': {
        ...aauGroup,
        'myRole': 'member',
        'myStatus': 'pending',
      },
      'DELETE /v1/groups/g-aau/membership': null,
      'DELETE /v1/groups/g-codm/membership': null,
      'GET /v1/groups/g-codm/posts': {
        'items': [
          post(
            'gp-1',
            dave,
            text: 'Scrims tonight, who is in?',
            gg: 3,
            comments: 0,
            group: {
              'id': 'g-codm',
              'name': 'CODM Addis',
              'short': 'CODM',
              'tone': 'accent',
            },
          ),
        ],
        'nextCursor': null,
      },
      'GET /v1/groups/g-fc/posts': {'items': <Object>[], 'nextCursor': null},
      'GET /v1/groups/g-codm/members': (RequestOptions o) =>
          o.uri.queryParameters['status'] == 'pending'
          ? {
              'items': [member(hana, status: 'pending')],
              'nextCursor': null,
            }
          : {
              'items': [member(dave), member(meCard, role: 'admin')],
              'nextCursor': null,
            },
      'GET /v1/groups/g-fc/members': {
        'items': [member(hana, role: 'admin')],
        'nextCursor': null,
      },
      'GET /v1/groups/g-aau/members': {
        'items': [member(dave, role: 'admin')],
        'nextCursor': null,
      },
      'POST /v1/groups/g-codm/members/u-hana/approve': null,
      'POST /v1/groups/g-codm/members/u-hana/decline': null,
      'PUT /v1/groups/g-codm/members/u-dave/role': null,
      'DELETE /v1/groups/g-codm/members/u-dave': null,
      'GET /v1/groups/g-codm/events': {
        'items': [groupEvent('ev-1', 'g-codm', 'Scrims vs Hawassa')],
        'nextCursor': null,
      },
      'GET /v1/groups/g-fc/events': {'items': <Object>[], 'nextCursor': null},
      'GET /v1/groups/g-aau/events': {'items': <Object>[], 'nextCursor': null},
      'POST /v1/groups/g-codm/events': (RequestOptions o) {
        final b = _bodyOf(o)! as Map;
        return {
          ...groupEvent('ev-new', 'g-codm', b['title'] as String, by: meCard),
          'startsAt': b['startsAt'],
          'imGoing': true,
          'goingPreview': [meCard],
        };
      },
      'PUT /v1/group-events/ev-1/going': groupEvent(
        'ev-1',
        'g-codm',
        'Scrims vs Hawassa',
        going: true,
        count: 2,
      ),
      'DELETE /v1/group-events/ev-1/going': groupEvent(
        'ev-1',
        'g-codm',
        'Scrims vs Hawassa',
      ),
      'DELETE /v1/group-events/ev-1': null,
      'DELETE /v1/group-events/ev-new': null,
      'DELETE /v1/posts/gp-1': null,
      'POST /v1/groups': (RequestOptions o) {
        final b = _bodyOf(o)! as Map;
        return {
          ...group(
            'g-new',
            b['name'] as String,
            kind: b['kind'] as String,
            approval: (b['approval'] as bool?) ?? false,
            role: 'admin',
            status: 'member',
            members: 1,
            rules: [for (final r in (b['rules'] as List?) ?? const []) '$r'],
            about: (b['about'] as String?) ?? '',
          ),
          'membersPreview': <Object>[],
        };
      },
      'GET /v1/groups/g-new/members': {
        'items': [member(meCard, role: 'admin')],
        'nextCursor': null,
      },
      'PATCH /v1/groups/g-codm': (RequestOptions o) {
        final b = _bodyOf(o)! as Map;
        return {...codmGroup, ...b};
      },
      'GET /v1/posts/p-1': post('p-1', dave),
      'POST /v1/posts': (RequestOptions o) {
        final b = _bodyOf(o)! as Map;
        final opts = (b['poll'] as Map?)?['options'] as List?;
        return post(
          'p-new',
          card('me-1', 'kaleb.gg', 'Kaleb'),
          type: b['type'] as String,
          kind: 'text',
          text: b['text'] as String,
          game: b['gameId'] == null
              ? null
              : gameRef(b['gameId'] as String, 'CoD Mobile', 'CODM'),
          audience: b['audience'] as String,
          gg: 0,
          comments: 0,
          mine: true,
          photos: [
            for (final k in (b['media'] as List?) ?? const [])
              'http://media.test/$k',
          ],
          poll: opts == null ? null : pollOf([for (final x in opts) '$x']),
          recruit: b['recruit'] == null
              ? null
              : recruitOf(
                  slots: (b['recruit'] as Map)['slots'] as int,
                  roles: ((b['recruit'] as Map)['roles'] as String?) ?? '',
                  applications: 0,
                ),
        );
      },
      'PUT /v1/posts/p-1/gg': {'ggCount': 5, 'myGG': true},
      'DELETE /v1/posts/p-1/gg': {'ggCount': 4, 'myGG': false},
      'PUT /v1/posts/p-1/save': null,
      'DELETE /v1/posts/p-1/save': null,
      'GET /v1/posts/p-1/comments': {
        'items': [comment('c-1', 'p-1', hana, 'It Takes Two, easily.')],
        'nextCursor': null,
      },
      'POST /v1/posts/p-1/comments': (RequestOptions o) {
        final b = _bodyOf(o)! as Map;
        return comment(
          'c-new',
          'p-1',
          card('me-1', 'kaleb.gg', 'Kaleb'),
          b['text'] as String,
          parentId: b['parentId'] as String?,
          mine: true,
        );
      },
      'DELETE /v1/comments/c-1': null,
      'GET /v1/me/posts': {
        'items': [
          post(
            'p-mine',
            card('me-1', 'kaleb.gg', 'Kaleb'),
            type: 'milestone',
            kind: 'text',
            text: 'Finally hit Legendary in ranked.',
            game: gameRef('codm', 'CoD Mobile', 'CODM'),
            gg: 12,
            comments: 3,
            mine: true,
          ),
        ],
        'nextCursor': null,
      },
      'GET /v1/users/dave.exe/posts': {'items': <Object>[], 'nextCursor': null},
      'GET /v1/users/hanaplays/posts': {
        'items': <Object>[],
        'nextCursor': null,
      },
    });
  }

  final routes = <String, Object?>{};

  /// Upload URLs handed out so far (each gets its own PUT path).
  int uploads = 0;

  /// Every request as "METHOD /path?query", for checking filters.
  final queries = <String>[];
  final sent = <({String method, String path, Object? body})>[];

  /// Each request's headers, as ("METHOD /path", headers).
  final headers = <(String, Map<String, dynamic>)>[];

  /// Answer [route] with an API error instead.
  void fail(String route, int status, String code, String message) =>
      routes[route] = _Err(status, {
        'error': {'code': code, 'message': message},
      });

  /// [route] fails as if the phone were offline.
  void unreachable(String route) => routes[route] = (RequestOptions o) =>
      throw DioException.connectionError(requestOptions: o, reason: 'offline');

  Iterable<Object?> bodiesOf(String route) =>
      sent.where((r) => '${r.method} ${r.path}' == route).map((r) => r.body);

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    // A route with its query string ("GET /v1/x?direction=outgoing") wins.
    final withQuery = '${o.method} ${o.uri.path}?${o.uri.query}';
    final key = routes.containsKey(withQuery)
        ? withQuery
        : '${o.method} ${o.uri.path}';
    Object? body = o.data;
    if (body is String && body.isNotEmpty) body = jsonDecode(body);
    sent.add((method: o.method, path: o.uri.path, body: body));
    headers.add(('${o.method} ${o.uri.path}', o.headers));
    queries.add('${o.method} ${o.uri.path}?${o.uri.query}');
    if (!routes.containsKey(key)) {
      return _json(404, {
        'error': {'code': 'not_found', 'message': 'No fake for $key'},
      });
    }
    var r = routes[key];
    if (r is Object? Function(RequestOptions)) r = r(o);
    if (r is Future) r = await r;
    if (r is _Err) return _json(r.status, r.body);
    if (r == null) return ResponseBody.fromString('', 204);
    return _json(
      o.method == 'POST' && key == 'POST /v1/listings' ? 201 : 200,
      r,
    );
  }

  ResponseBody _json(int status, Object? body) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}

class _Err {
  const _Err(this.status, this.body);
  final int status;
  final Object body;
}

Api fakeApi(FakeApi server, {String? token}) => Api(
  appVersion: '1.0.0',
  store: MemoryTokenStore(token),
  baseUrl: 'http://test',
  adapter: server,
);
