import 'package:api_client/api_client.dart';

import 'theme.dart';

// Labels and lookups between the API's enums and what the app shows.

const platformLabel = {
  Platform.pc: 'PC',
  Platform.playstation: 'PlayStation',
  Platform.xbox: 'Xbox',
  Platform.mobile: 'Mobile',
  Platform.switch_: 'Switch',
};

const tagLabel = {
  PlayTag.competitive: 'Competitive',
  PlayTag.casual: 'Casual',
  PlayTag.fps: 'FPS',
  PlayTag.rpg: 'RPG',
  PlayTag.strategy: 'Strategy',
  PlayTag.coOp: 'Co-op',
  PlayTag.ranked: 'Ranked',
  PlayTag.achievementHunter: 'Achievement Hunter',
  PlayTag.story: 'Story Games',
};

const ageLabel = {
  AgeRange.n1617: '16–17',
  AgeRange.n1824: '18–24',
  AgeRange.n2534: '25–34',
  AgeRange.n35plus: '35+',
};

const dayLabel = {
  Day.mon: 'MO',
  Day.tue: 'TU',
  Day.wed: 'WE',
  Day.thu: 'TH',
  Day.fri: 'FR',
  Day.sat: 'SA',
  Day.sun: 'SU',
};

const reasonLabel = {
  ReportReason.harassment: 'Harassment',
  ReportReason.hate: 'Hate',
  ReportReason.sexualContent: 'Sexual content',
  ReportReason.underage: 'Under 16',
  ReportReason.spam: 'Spam',
  ReportReason.impersonation: 'Impersonation',
  ReportReason.cheatingOrScam: 'Cheating or scam',
  ReportReason.other: 'Something else',
};

const playWhenLabel = {
  PlayWhen.now: 'Now',
  PlayWhen.tonight: 'Tonight',
  PlayWhen.weekend: 'Weekend',
};
const inviteWhenLabel = {
  InviteWhen.now: 'Now',
  InviteWhen.in30Min: 'In 30 min',
  InviteWhen.tonight: 'Tonight 21:00',
};

/// "Duo", "Trio"… for a party size (including the poster).
String partyLabel(num n) => switch (n) {
  2 => 'Duo',
  3 => 'Trio',
  4 => 'Squad',
  5 => '5-stack',
  _ => '$n players',
};

/// Gaming ID kinds the profile offers a row for, in order; in-game IDs
/// (a UID per mobile game) are added per game.
const idKinds = [
  GamingIdKind.riot,
  GamingIdKind.discord,
  GamingIdKind.steam,
  GamingIdKind.playstation,
  GamingIdKind.xbox,
  GamingIdKind.epic,
  GamingIdKind.ea,
  GamingIdKind.activision,
];

const idKindLabel = {
  GamingIdKind.riot: 'Riot ID',
  GamingIdKind.discord: 'Discord',
  GamingIdKind.steam: 'Steam',
  GamingIdKind.playstation: 'PlayStation',
  GamingIdKind.xbox: 'Xbox',
  GamingIdKind.epic: 'Epic',
  GamingIdKind.ea: 'EA',
  GamingIdKind.activision: 'Activision',
  GamingIdKind.inGame: 'In-game',
};

/// The kind a non-in-game row key stands for.
GamingIdKind kindOf(String key) =>
    GamingIdKind.values.firstWhere((k) => k.name == key);

/// The key of a gaming ID row: its kind, or `in_game:<gameId>`.
String idKey(GamingIdKind kind, [String? gameId]) =>
    kind == GamingIdKind.inGame ? 'in_game:$gameId' : kind.name;

/// Status shown on a player's card, with its dot colour.
(String, Tone) statusLook(PlayerStatus s, GameRefDto? game) => switch (s) {
  PlayerStatus.looking => (
    game == null ? 'Looking for players' : 'Looking for ${game.name}',
    Tone.accent,
  ),
  PlayerStatus.playing => (
    game == null ? 'Playing' : 'Playing ${game.name}',
    Tone.lav,
  ),
  PlayerStatus.availableTonight => ('Available tonight', Tone.free),
  _ => ('Not available', Tone.faint),
};

/// Avatar colour for someone without a photo; stable per person.
Tone toneFor(String id) => const [
  Tone.soft,
  Tone.lav,
  Tone.grey,
  Tone.accent,
][id.codeUnits.fold(0, (a, b) => a + b) % 4];

String initialOf(String name) =>
    name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

/// A catalog game (GET /v1/games) or one the player typed in.
class Game {
  Game({
    required this.id,
    required this.name,
    required this.short,
    this.ranks = const [],
    this.modes = const [],
    this.roles = const [],
    this.platforms = const {},
    this.hasRanks = false,
    this.maxParty = 5,
    this.isLaunch = false,
    this.custom = false,
  });

  factory Game.fromDto(GameDto g) => Game(
    id: g.id,
    name: g.name,
    short: g.shortCode,
    ranks: g.ranks.toList()..sort((a, b) => a.tier.compareTo(b.tier)),
    modes: g.modes.toList(),
    roles: g.roles.toList(),
    platforms: g.platforms.toSet(),
    hasRanks: g.hasRanks,
    maxParty: g.maxParty.toInt(),
    isLaunch: g.isLaunch,
  );

  final String id, name, short;

  /// Lowest first. For unranked games these are play-style levels instead;
  /// empty for custom games (free-text rank).
  final List<RankDto> ranks;
  final List<ModeDto> modes;

  /// Positions or heroes to pick from (empty until the catalog has them).
  final List<RoleDto> roles;
  final Set<Platform> platforms;
  final bool hasRanks, isLaunch, custom;
  final int maxParty;

  String get rankWord => hasRanks ? 'rank' : 'level';
  List<String> get aliases => _aliases[id] ?? const [];

  RankDto? rank(String? id) => ranks.where((r) => r.id == id).firstOrNull;
  RoleDto? role(String? id) => roles.where((r) => r.id == id).firstOrNull;

  bool matches(String q) {
    final s = q.trim().toLowerCase();
    if (s.isEmpty) return true;
    return name.toLowerCase().contains(s) ||
        short.toLowerCase().contains(s) ||
        aliases.any((a) => a.contains(s));
  }
}

/// Search words people use for games beyond their name.
const _aliases = {
  'lol': ['league', 'lol'],
  'cs2': ['cs', 'csgo', 'counter strike', 'premier'],
  'ow': ['overwatch 2', 'ow2'],
  'r6': ['siege', 'r6', 'rainbow'],
  'bo7': ['cod', 'call of duty', 'black ops'],
  'wz': ['cod', 'warzone'],
  'pubgpc': ['pubg', 'battlegrounds'],
  'fc': ['fifa', 'fc 26', 'fc 27', 'ultimate team', 'football', 'soccer'],
  'efootball': ['pes', 'football', 'soccer'],
  'codm': ['cod', 'call of duty mobile'],
  'pubg': ['pubg', 'bgmi'],
  'ff': ['ff max', 'garena'],
  'mlbb': ['ml', 'mobile legends'],
  'wr': ['wild rift', 'league'],
  'coc': ['clash'],
  'cr': ['clash'],
  'unite': ['pokemon'],
  'gta': ['gta v', 'gta 5', 'grand theft auto'],
  'elden': ['nightreign'],
  'bf6': ['battlefield'],
  'mhw': ['monster hunter'],
  'nba2k': ['basketball'],
  'mkw': ['mario kart'],
};

/// The game catalog, loaded once per launch, plus games typed in by name.
class Catalog {
  Catalog([List<Game> games = const []])
    : games = List.unmodifiable(games),
      _byId = {for (final g in games) g.id: g};

  final List<Game> games;
  final Map<String, Game> _byId;
  final custom = <String, Game>{};

  List<Game> get launch => games.where((g) => g.isLaunch).toList();

  Game byId(String id) =>
      _byId[id] ??
      custom[id] ??
      Game(id: id, name: id, short: id.toUpperCase(), custom: true);

  /// Registers a free-text game and returns its id (re-uses an existing match).
  String addCustom(String name) {
    final n = name.trim();
    for (final g in [...games, ...custom.values]) {
      if (g.name.toLowerCase() == n.toLowerCase()) return g.id;
    }
    final id = 'x:${n.toLowerCase()}';
    final words = n.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final short = words.length > 1
        ? words.take(4).map((w) => w[0]).join().toUpperCase()
        : n.substring(0, n.length < 4 ? n.length : 4).toUpperCase();
    custom[id] = Game(id: id, name: n, short: short, custom: true);
    return id;
  }

  /// The app-side id of a profile game: the catalog id, or `x:<name>`.
  String keyOf(UserGameDto g) =>
      g.game?.id ?? addCustom(g.customGameName ?? '?');
}

/// A profile game as the screens show it.
class GameLine {
  const GameLine({
    required this.name,
    required this.short,
    required this.rank,
    required this.role,
  });
  final String name, short, rank, role;
}

/// A player's profile, either mine (GET /me) or someone else's
/// (GET /users/{username}), in one shape for the profile screen.
class Profile {
  Profile._({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.city,
    required this.status,
    required this.statusGame,
    required this.bio,
    required this.games,
    required this.platforms,
    required this.tags,
    required this.gamingIds,
    required this.stats,
    required this.relationship,
    required this.incomingRequestId,
    required this.availableDays,
  });

  factory Profile.me(MeDto m) => Profile._(
    id: m.id,
    username: m.username,
    displayName: m.displayName,
    avatarUrl: m.avatarUrl,
    city: m.city,
    status: m.status,
    statusGame: m.statusGame,
    bio: m.bio,
    games: m.games.toList(),
    platforms: m.platforms.toList(),
    tags: m.tags.toList(),
    gamingIds: m.gamingIds.toList(),
    stats: m.stats,
    relationship: Relationship.self,
    incomingRequestId: null,
    availableDays: m.availableDays.toList(),
  );

  factory Profile.of(ProfileDto p) => Profile._(
    id: p.id,
    username: p.username,
    displayName: p.displayName,
    avatarUrl: p.avatarUrl,
    city: p.city,
    status: p.status,
    statusGame: p.statusGame,
    bio: p.bio,
    games: p.games.toList(),
    platforms: p.platforms.toList(),
    tags: p.tags.toList(),
    gamingIds: p.gamingIds.toList(),
    stats: p.stats,
    relationship: p.relationship,
    incomingRequestId: p.incomingRequestId,
    availableDays: p.availableDays.toList(),
  );

  final String id, username, displayName, city;
  final String? avatarUrl, bio, incomingRequestId;
  final PlayerStatus status;
  final GameRefDto? statusGame;
  final List<UserGameDto> games;
  final List<Platform> platforms;
  final List<PlayTag> tags;
  final List<GamingIdDto> gamingIds;
  final ProfileStatsDto stats;
  final Relationship relationship;
  final List<Day> availableDays;

  bool get isMe => relationship == Relationship.self;
}

class Intro {
  const Intro(
    this.kicker,
    this.step,
    this.body,
    this.left,
    this.top,
    this.hr,
    this.vr,
  );
  final String kicker, step, body;
  final double left, top;
  final List<double> hr, vr;
}

const intros = [
  Intro(
    'Who are you as a gamer?',
    'Step 1 · Build your gamer ID',
    'Your games, ranks, platforms and IDs in one profile — not split across six apps.',
    -150,
    90,
    [48, 52, 60, 40],
    [55, 45, 55, 45],
  ),
  Intro(
    'Who’s up for a game tonight?',
    'Step 2 · Find players who fit',
    'Browse short-lived “Looking for Players” listings, or post your own in seconds.',
    -20,
    60,
    [60, 40, 42, 58],
    [48, 62, 38, 52],
  ),
  Intro(
    'Stop queueing with strangers.',
    'Step 3 · Connect & play',
    'Send a request, get connected, and lock in a session together.',
    -110,
    120,
    [42, 58, 55, 45],
    [60, 40, 60, 40],
  ),
];
