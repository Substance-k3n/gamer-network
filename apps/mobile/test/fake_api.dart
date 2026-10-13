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
};

Map<String, Object?> me({bool onboarded = true, bool verified = true}) => {
  ...profile('me-1', 'kaleb.gg', 'Kaleb', relationship: 'self'),
  'email': 'kaleb@example.com',
  'emailVerified': verified,
  'hasPassword': true,
  'country': 'ET',
  'onboardedAt': onboarded ? _at(const Duration(days: -3)) : null,
  'createdAt': _at(const Duration(days: -3)),
  'role': 'player',
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
    });
  }

  final routes = <String, Object?>{};
  final sent = <({String method, String path, Object? body})>[];

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
    final key = '${o.method} ${o.uri.path}';
    Object? body = o.data;
    if (body is String && body.isNotEmpty) body = jsonDecode(body);
    sent.add((method: o.method, path: o.uri.path, body: body));
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
