import 'dart:typed_data';

import 'theme.dart';

enum Plat {
  pc('PC'),
  ps('PlayStation'),
  xbox('Xbox'),
  switch_('Switch'),
  mobile('Mobile');

  const Plat(this.label);
  final String label;
}

const _pc = {Plat.pc};
const _mob = {Plat.mobile};
const _console = {Plat.pc, Plat.ps, Plat.xbox};
const _all = {Plat.pc, Plat.ps, Plat.xbox, Plat.switch_};
const _every = {Plat.pc, Plat.ps, Plat.xbox, Plat.switch_, Plat.mobile};

class Game {
  const Game(this.id, this.name, this.short, this.ranks, this.platforms, {this.ranked = true, this.aliases = const [], this.custom = false});
  final String id, name, short;

  /// Competitive tiers, lowest first. For unranked games these are skill or
  /// play-style levels instead; empty for custom games (free-text rank).
  final List<String> ranks;
  final Set<Plat> platforms;
  final bool ranked, custom;
  final List<String> aliases;

  String get rankWord => ranked ? 'rank' : 'level';

  bool matches(String q) {
    final s = q.trim().toLowerCase();
    if (s.isEmpty) return true;
    return name.toLowerCase().contains(s) || short.toLowerCase().contains(s) || aliases.any((a) => a.contains(s));
  }
}

/// Well-known PC, console and mobile games with their current ranked tiers
/// (top-level tiers only; sub-divisions like "Gold II" are omitted).
/// Tiers last checked October 2026.
const games = [
  // PC / console
  Game('val', 'Valorant', 'VAL', ['Iron', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Ascendant', 'Immortal', 'Radiant'], {Plat.pc, Plat.ps, Plat.xbox}),
  Game('lol', 'League of Legends', 'LoL', ['Iron', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Emerald', 'Diamond', 'Master', 'Grandmaster', 'Challenger'], _pc, aliases: ['league', 'lol']),
  Game('cs2', 'Counter-Strike 2', 'CS2', ['Grey · 0–4,999', 'Light Blue · 5,000+', 'Blue · 10,000+', 'Purple · 15,000+', 'Pink · 20,000+', 'Red · 25,000+', 'Gold · 30,000+'], _pc, aliases: ['cs', 'csgo', 'counter strike', 'premier']),
  Game('dota', 'Dota 2', 'DOTA', ['Herald', 'Guardian', 'Crusader', 'Archon', 'Legend', 'Ancient', 'Divine', 'Immortal'], _pc),
  Game('fn', 'Fortnite', 'FN', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Elite', 'Champion', 'Unreal'], _every),
  Game('apex', 'Apex Legends', 'APEX', ['Rookie', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Master', 'Apex Predator'], _all),
  Game('ow', 'Overwatch', 'OW', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Master', 'Grandmaster', 'Champion', 'Top 500'], _all, aliases: ['overwatch 2', 'ow2']),
  Game('rivals', 'Marvel Rivals', 'MR', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Grandmaster', 'Celestial', 'Eternity', 'One Above All'], _console),
  Game('r6', 'Rainbow Six Siege X', 'R6', ['Copper', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Emerald', 'Diamond', 'Champion'], _console, aliases: ['siege', 'r6', 'rainbow']),
  Game('bo7', 'Call of Duty: Black Ops 7', 'BO7', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Crimson', 'Iridescent', 'Top 250'], _console, aliases: ['cod', 'call of duty', 'black ops']),
  Game('wz', 'Call of Duty: Warzone', 'WZ', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Crimson', 'Iridescent', 'Top 250'], _console, aliases: ['cod', 'warzone']),
  Game('pubgpc', 'PUBG: Battlegrounds', 'PUBG', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Master', 'Top 500'], _console, aliases: ['pubg', 'battlegrounds']),
  Game('rl', 'Rocket League', 'RL', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Champion', 'Grand Champion', 'Supersonic Legend'], _all),
  Game('deadlock', 'Deadlock', 'DL', ['Initiate', 'Seeker', 'Alchemist', 'Arcanist', 'Ritualist', 'Emissary', 'Archon', 'Oracle', 'Phantom', 'Ascendant', 'Eternus'], _pc),
  Game('fc', 'EA SPORTS FC', 'FC', ['Div 10', 'Div 9', 'Div 8', 'Div 7', 'Div 6', 'Div 5', 'Div 4', 'Div 3', 'Div 2', 'Div 1', 'Elite'], _all, aliases: ['fifa', 'fc 26', 'fc 27', 'ultimate team', 'football', 'soccer']),
  Game('efootball', 'eFootball', 'EFB', ['Div 10', 'Div 9', 'Div 8', 'Div 7', 'Div 6', 'Div 5', 'Div 4', 'Div 3', 'Div 2', 'Div 1'], _every, aliases: ['pes', 'football', 'soccer']),
  Game('tft', 'Teamfight Tactics', 'TFT', ['Iron', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Emerald', 'Diamond', 'Master', 'Grandmaster', 'Challenger'], {Plat.pc, Plat.mobile}),
  Game('hs', 'Hearthstone', 'HS', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Legend'], {Plat.pc, Plat.mobile}),
  Game('tekken', 'Tekken 8', 'T8', ['Beginner', '1st Dan', '2nd Dan', 'Fighter', 'Strategist', 'Combatant', 'Brawler', 'Ranger', 'Cavalry', 'Warrior', 'Assailant', 'Dominator', 'Vanquisher', 'Destroyer', 'Eliminator', 'Garyu', 'Shinryu', 'Tenryu', 'Mighty Ruler', 'Flame Ruler', 'Battle Ruler', 'Fujin', 'Raijin', 'Kishin', 'Bushin', 'Tekken King', 'Tekken Emperor', 'Tekken God', 'Tekken God Supreme', 'God of Destruction'], _console),
  Game('sf6', 'Street Fighter 6', 'SF6', ['Rookie', 'Iron', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Master', 'High Master', 'Grand Master', 'Ultimate Master', 'Legend'], {Plat.pc, Plat.ps, Plat.xbox, Plat.switch_}),
  Game('halo', 'Halo Infinite', 'HALO', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Onyx'], {Plat.pc, Plat.xbox}),
  Game('finals', 'The Finals', 'TF', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Ruby'], _console),
  Game('splatoon', 'Splatoon 3', 'SPL3', ['C-', 'C', 'C+', 'B-', 'B', 'B+', 'A-', 'A', 'A+', 'S', 'S+'], {Plat.switch_}),
  Game('dbd', 'Dead by Daylight', 'DBD', ['Ash', 'Bronze', 'Silver', 'Gold', 'Iridescent'], _every),
  // Mobile
  Game('codm', 'CoD Mobile', 'CODM', ['Rookie', 'Veteran', 'Elite', 'Pro', 'Master', 'Grandmaster', 'Legendary'], _mob, aliases: ['cod', 'call of duty mobile']),
  Game('pubg', 'PUBG Mobile', 'PUBGM', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Crown', 'Ace', 'Ace Master', 'Ace Dominator', 'Conqueror'], _mob, aliases: ['pubg', 'bgmi']),
  Game('ff', 'Free Fire', 'FF', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Heroic', 'Master', 'Grandmaster'], _mob, aliases: ['ff max', 'garena']),
  Game('mlbb', 'Mobile Legends: Bang Bang', 'MLBB', ['Warrior', 'Elite', 'Master', 'Grandmaster', 'Epic', 'Legend', 'Mythic', 'Mythical Honor', 'Mythical Glory', 'Mythical Immortal'], _mob, aliases: ['ml', 'mobile legends']),
  Game('hok', 'Honor of Kings', 'HOK', ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Master', 'Grandmaster', 'Mythic', 'Epic', 'Legend'], _mob),
  Game('wr', 'LoL: Wild Rift', 'WR', ['Iron', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Emerald', 'Diamond', 'Master', 'Grandmaster', 'Challenger', 'Sovereign'], _mob, aliases: ['wild rift', 'league']),
  Game('bs', 'Brawl Stars', 'BS', ['Bronze', 'Silver', 'Gold', 'Diamond', 'Mythic', 'Legendary', 'Masters', 'Pro'], _mob),
  Game('coc', 'Clash of Clans', 'COC', ['Skeleton', 'Barbarian', 'Archer', 'Wizard', 'Valkyrie', 'Witch', 'Golem', 'P.E.K.K.A', 'Titan', 'Dragon', 'Electro', 'Legend III', 'Legend II', 'Legend I'], _mob, aliases: ['clash']),
  Game('cr', 'Clash Royale', 'CR', ['Trophy Road', 'Path of Legends', 'Ultimate Champion'], _mob, ranked: false, aliases: ['clash']),
  Game('unite', 'Pokémon UNITE', 'UNITE', ['Beginner', 'Great', 'Expert', 'Veteran', 'Ultra', 'Master'], {Plat.mobile, Plat.switch_}, aliases: ['pokemon']),
  // Unranked — levels describe how you play
  Game('mc', 'Minecraft', 'MC', ['Survival', 'Creative', 'Hardcore', 'PvP'], _every),
  Game('roblox', 'Roblox', 'RBX', ['Casual', 'Regular', 'Competitive'], {Plat.pc, Plat.ps, Plat.xbox, Plat.mobile}, ranked: false),
  Game('gta', 'GTA Online', 'GTA', ['Casual', 'Grinder', 'Roleplay', 'Racing'], _console, ranked: false, aliases: ['gta v', 'gta 5', 'grand theft auto']),
  Game('elden', 'Elden Ring', 'ER', ['Casual', 'Co-op', 'Challenge runs'], _console, ranked: false, aliases: ['nightreign']),
  Game('helldivers', 'Helldivers 2', 'HD2', ['Difficulty 1–3', 'Difficulty 4–6', 'Difficulty 7–9', 'Super Helldive'], _console, ranked: false),
  Game('bf6', 'Battlefield 6', 'BF6', ['Casual', 'Regular', 'Competitive'], _console, ranked: false, aliases: ['battlefield']),
  Game('arc', 'ARC Raiders', 'ARC', ['Casual', 'Regular', 'Hardcore'], _console, ranked: false),
  Game('mhw', 'Monster Hunter Wilds', 'MHW', ['HR 1–49', 'HR 50–99', 'HR 100+'], _console, ranked: false, aliases: ['monster hunter']),
  Game('genshin', 'Genshin Impact', 'GI', ['AR 1–35', 'AR 36–50', 'AR 51–57', 'AR 58–60'], {Plat.pc, Plat.ps, Plat.mobile}, ranked: false),
  Game('nba2k', 'NBA 2K', '2K', ['Rookie', 'Pro', 'All-Star', 'Superstar', 'Legend'], _all, ranked: false, aliases: ['basketball']),
  Game('mkw', 'Mario Kart World', 'MKW', ['Casual', 'Online regular', 'Competitive'], {Plat.switch_}, ranked: false, aliases: ['mario kart']),
  Game('rust', 'Rust', 'RUST', ['Casual', 'Regular', 'Hardcore'], _console, ranked: false),
  Game('sot', 'Sea of Thieves', 'SOT', ['Casual', 'Regular', 'Hardcore'], _console, ranked: false),
  Game('amongus', 'Among Us', 'AU', ['Casual', 'Regular', 'Competitive'], _every, ranked: false),
  Game('fallguys', 'Fall Guys', 'FG', ['Casual', 'Regular', 'Competitive'], _all, ranked: false),
];

/// Games the user typed in themselves ("Other game"), keyed by id.
final customGames = <String, Game>{};

final Map<String, Game> _byId = {for (final g in games) g.id: g};

Game gameById(String id) => _byId[id] ?? customGames[id]!;

/// Registers a free-text game and returns its id (re-uses an existing match).
String addCustomGame(String name) {
  final n = name.trim();
  for (final g in [...games, ...customGames.values]) {
    if (g.name.toLowerCase() == n.toLowerCase()) return g.id;
  }
  final id = 'x:${n.toLowerCase()}';
  final words = n.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  final short = words.length > 1 ? words.take(4).map((w) => w[0]).join().toUpperCase() : n.substring(0, n.length < 4 ? n.length : 4).toUpperCase();
  customGames[id] = Game(id, n, short, const [], const {}, ranked: false, custom: true);
  return id;
}

/// Matches a post's game label ("VALORANT", "CODM") back to a game, if any.
Game? gameByLabel(String label) {
  for (final g in games) {
    if (g.name.toUpperCase() == label || g.short.toUpperCase() == label) return g;
  }
  return null;
}

class PlayerGame {
  const PlayerGame(this.id, this.rank, this.role);
  final String id, rank, role;
}

class GamingId {
  const GamingId(this.k, this.v);
  final String k, v;
}

class Player {
  const Player({
    required this.name,
    required this.handle,
    required this.av,
    required this.city,
    required this.status,
    required this.sc,
    required this.bio,
    required this.games,
    required this.platforms,
    required this.tags,
    required this.ids,
    required this.conn,
    required this.played,
  });
  final String name, handle, city, status, bio;
  final Tone av, sc;
  final List<PlayerGame> games;
  final List<String> platforms, tags;
  final List<GamingId> ids;
  final int conn, played;
  String get init => name[0];
}

const players = <String, Player>{
  'dave': Player(name: 'Dave', handle: 'dave.exe', av: Tone.soft, city: 'Addis Ababa', status: 'Looking for players', sc: Tone.accent, bio: 'Duelist main. Grinding to Ascendant before the semester ends.', games: [PlayerGame('val', 'Diamond', 'Duelist'), PlayerGame('codm', 'Master', 'Slayer')], platforms: ['PC', 'Mobile'], tags: ['Competitive', 'FPS', 'Ranked'], ids: [GamingId('Riot ID', 'dave#ETH1'), GamingId('Discord', 'dave.exe')], conn: 48, played: 31),
  'hana': Player(name: 'Hana', handle: 'hanaplays', av: Tone.lav, city: 'Addis Ababa', status: 'Available tonight', sc: Tone.lav, bio: 'FC on weekends, Elden Ring when I want to suffer.', games: [PlayerGame('fc', 'Div 2', 'Pro Clubs · CDM'), PlayerGame('elden', 'Co-op', 'Summon helper')], platforms: ['PlayStation'], tags: ['Casual', 'Co-op', 'Story Games'], ids: [GamingId('PlayStation', 'hana_plays')], conn: 22, played: 14),
  'yonas': Player(name: 'Yonas', handle: 'yonasjg', av: Tone.grey, city: 'Bahir Dar', status: 'Playing League', sc: Tone.lav, bio: 'Jungle diff. Looking for a mid who roams.', games: [PlayerGame('lol', 'Emerald', 'Jungle')], platforms: ['PC'], tags: ['Competitive', 'Strategy', 'Ranked'], ids: [GamingId('Riot ID', 'yonas#JNG'), GamingId('Discord', 'yonasjg')], conn: 63, played: 40),
  'meron': Player(name: 'Meron', handle: 'meron.codm', av: Tone.accent, city: 'Addis Ababa', status: 'Looking for players', sc: Tone.accent, bio: 'CODM squad captain. Tournaments soon, practice now.', games: [PlayerGame('codm', 'Legendary', 'Sniper'), PlayerGame('pubg', 'Ace', 'IGL')], platforms: ['Mobile'], tags: ['Competitive', 'FPS', 'Ranked'], ids: [GamingId('Discord', 'meron.codm')], conn: 91, played: 57),
  'abel': Player(name: 'Abel', handle: 'abelsmokes', av: Tone.soft, city: 'Adama', status: 'Looking for players', sc: Tone.accent, bio: 'Controller main. Comms > aim.', games: [PlayerGame('val', 'Platinum', 'Controller'), PlayerGame('tekken', 'Garyu', 'Kazuya')], platforms: ['PC', 'PlayStation'], tags: ['Competitive', 'Co-op', 'FPS'], ids: [GamingId('Riot ID', 'abel#SMK')], conn: 17, played: 9),
  'liya': Player(name: 'Liya', handle: 'liya.mc', av: Tone.lav, city: 'Hawassa', status: 'Available tonight', sc: Tone.lav, bio: 'Building a whole city on our server. Builders welcome.', games: [PlayerGame('mc', 'Creative', 'Builder'), PlayerGame('elden', 'Casual', 'Explorer')], platforms: ['PC'], tags: ['Casual', 'Co-op', 'Achievement Hunter'], ids: [GamingId('Discord', 'liya.mc')], conn: 35, played: 20),
};

class StatusOption {
  const StatusOption(this.label, this.color);
  final String label;
  final Tone color;
}

const statuses = [
  StatusOption('Looking for players', Tone.accent),
  StatusOption('Playing Valorant', Tone.lav),
  StatusOption('Available tonight', Tone.free),
  StatusOption('Not available', Tone.faint),
];

class PostType {
  const PostType(this.label, this.bg, this.placeholder);
  final String label, placeholder;
  final Tone bg;
}

const postTypes = [
  PostType('Discussion', Tone.lav, 'Start a conversation — e.g. Best co-op game you’ve played recently?'),
  PostType('Gameplay', Tone.accent, 'Add a caption for your clip or screenshot…'),
  PostType('Recruitment', Tone.soft, 'Tell players about your team and what you’re looking for…'),
  PostType('Poll', Tone.lav, 'Ask the community something…'),
  PostType('Milestone', Tone.accent, 'Finally hit Diamond? Share it…'),
  PostType('Question', Tone.soft, 'What do you want to know?'),
  PostType('Looking for players', Tone.accent, 'What are you playing, and when?'),
  PostType('Tip / Guide', Tone.lav, 'Share a tip that helped you climb…'),
  PostType('Review', Tone.soft, 'What did you think of it?'),
  PostType('Event', Tone.lav, 'What’s happening, where and when?'),
  PostType('Meme', Tone.soft, 'Caption it…'),
];

PostType? postTypeByLabel(String? label) {
  for (final t in postTypes) {
    if (t.label == label) return t;
  }
  return null;
}

class Listing {
  const Listing({required this.id, required this.pid, required this.game, required this.mode, required this.rank, required this.want, required this.mic, required this.platform, required this.when, required this.note, required this.exp});
  final int id;
  final String pid, game, mode, rank, want, platform, when, note;
  final bool mic;
  final DateTime exp;
}

class MediaItem {
  const MediaItem({required this.name, required this.isVideo, this.bytes});
  final String name;
  final bool isVideo;
  final Uint8List? bytes;
}

class Poll {
  const Poll(this.opts, this.votes, this.dur);
  final List<String> opts;
  final List<int> votes;
  final String dur;
}

class Recruit {
  const Recruit(this.slots, this.roles);
  final String slots, roles;
}

enum PostKind { text, moment, discussion, poll, recruit }

class Post {
  const Post({required this.id, required this.pid, required this.kind, this.tag, required this.game, required this.text, required this.gg, required this.c, required this.time, this.dur, this.top, this.poll, this.recruit, this.media = const []});
  final String id, pid, game, text, time;
  final PostKind kind;
  final String? tag, dur;
  final int gg, c;
  final (String, String)? top;
  final Poll? poll;
  final Recruit? recruit;
  final List<MediaItem> media;

  /// The tag shown on the card; moments and discussions get an implicit one.
  String? get tagName => tag ?? (kind == PostKind.moment ? 'Gameplay' : kind == PostKind.discussion ? 'Discussion' : null);
}

class Comment {
  const Comment(this.pid, this.text, this.t, this.gg, {this.mine = false});
  final String pid, text, t;
  final int gg;
  final bool mine;
}

class Intro {
  const Intro(this.kicker, this.step, this.body, this.left, this.top, this.hr, this.vr);
  final String kicker, step, body;
  final double left, top;
  final List<double> hr, vr;
}

const intros = [
  Intro('Who are you as a gamer?', 'Step 1 · Build your gamer ID', 'Your games, ranks, platforms and IDs in one profile — not split across six apps.', -150, 90, [48, 52, 60, 40], [55, 45, 55, 45]),
  Intro('Who’s up for a game tonight?', 'Step 2 · Find players who fit', 'Browse short-lived “Looking for Players” listings, or post your own in seconds.', -20, 60, [60, 40, 42, 58], [48, 62, 38, 52]),
  Intro('Stop queueing with strangers.', 'Step 3 · Connect & play', 'Send a request, get connected, and lock in a session together.', -110, 120, [42, 58, 55, 45], [60, 40, 60, 40]),
];

enum GroupKind {
  game('Game'),
  city('City'),
  campus('Campus'),
  squad('Squad');

  const GroupKind(this.label);
  final String label;
}

class GroupPost {
  GroupPost(this.pid, this.text, this.time, {this.gg = 0});
  final String pid, text, time;
  final int gg;
}

class GroupEvent {
  GroupEvent({required this.id, required this.title, required this.when, this.gameId, Set<String>? going}) : going = going ?? {};
  final String id, title, when;
  final String? gameId;
  final Set<String> going;
}

/// A community. [members] holds the people the app knows ("me" and seeded
/// players); [extra] stands in for everyone else so counts look real.
class Group {
  Group({
    required this.id,
    required this.name,
    required this.short,
    required this.kind,
    required this.place,
    required this.about,
    required this.tone,
    required this.members,
    required this.admins,
    required this.since,
    this.gameId,
    this.extra = 0,
    this.approval = false,
    this.rules = const [],
    List<GroupPost>? posts,
    List<GroupEvent>? events,
  })  : posts = posts ?? [],
        events = events ?? [];

  final String id, name, short, place, about, since;
  final GroupKind kind;
  final String? gameId;
  final Tone tone;
  final Set<String> members, admins;
  final int extra;
  final bool approval;
  final List<String> rules;
  final List<GroupPost> posts;
  final List<GroupEvent> events;

  int get count => members.length + extra;
  String get line => kind == GroupKind.game && gameId != null ? '${gameById(gameId!).name} · $place' : '${kind.label} · $place';
}

/// "1,204" style member counts.
String groupCount(int n) => n >= 1000 ? '${n ~/ 1000},${(n % 1000).toString().padLeft(3, '0')}' : '$n';

List<Group> seedGroups() => [
      Group(
        id: 'g-val',
        name: 'Valorant Ethiopia',
        short: 'VAL',
        kind: GroupKind.game,
        gameId: 'val',
        place: 'Ethiopia',
        tone: Tone.accent,
        members: {'me', 'dave', 'abel', 'meron'},
        admins: {'dave'},
        extra: 1197,
        since: 'Mar 2025',
        about: 'The home of Valorant in Ethiopia. Find a duo, organise 5-stacks, share clips and talk agents. Every rank welcome — Iron to Radiant.',
        rules: ['Be decent. No slurs, no harassment.', 'LFG posts go in the feed with your rank and region.', 'No account selling or boosting.'],
        posts: [
          GroupPost('dave', 'Customs tonight at 21:00 — need two more for the second team. Reply here.', '25m', gg: 14),
          GroupPost('abel', 'Smoke lineups for Sunset B site, thread below. Took me a week to get these clean.', '3h', gg: 31),
          GroupPost('meron', 'Anyone else getting 120ms on the Bahrain server since the patch?', '5h', gg: 6),
        ],
        events: [
          GroupEvent(id: 'e1', title: '5-stack customs', when: 'Tonight 21:00', gameId: 'val', going: {'dave', 'abel'}),
          GroupEvent(id: 'e2', title: 'Unrated night — new players welcome', when: 'Sat 19:00', gameId: 'val', going: {'meron'}),
        ],
      ),
      Group(
        id: 'g-fc',
        name: 'Ethiopian FC Players',
        short: 'FC',
        kind: GroupKind.game,
        gameId: 'fc',
        place: 'Ethiopia',
        tone: Tone.lav,
        members: {'hana', 'yonas'},
        admins: {'hana'},
        extra: 858,
        since: 'Sep 2024',
        about: 'Ultimate Team, Pro Clubs and Rivals. Weekend clubs nights and a monthly local tournament.',
        rules: ['Tag your platform in LFG posts.', 'Keep trades out of the feed.'],
        posts: [GroupPost('hana', 'Pro Clubs: we need a CB and a striker for Sunday. Div 2 club, chill vibes.', '1h', gg: 9)],
        events: [GroupEvent(id: 'e3', title: 'Pro Clubs night', when: 'Sun 20:00', gameId: 'fc', going: {'hana'})],
      ),
      Group(
        id: 'g-mc',
        name: 'Addis Minecraft Community',
        short: 'MC',
        kind: GroupKind.city,
        gameId: 'mc',
        place: 'Addis Ababa',
        tone: Tone.soft,
        members: {'liya'},
        admins: {'liya'},
        extra: 339,
        since: 'Jan 2025',
        about: 'We’re building Addis block by block on our own server. Builders, redstoners and explorers all welcome.',
        rules: ['No griefing on the shared server.', 'Ask before building next to someone.'],
        posts: [GroupPost('liya', 'Meskel Square is done! Next up: the light rail. Who wants to plan the route?', '2h', gg: 22)],
        events: [GroupEvent(id: 'e4', title: 'Build night: light rail', when: 'Fri 20:00', gameId: 'mc', going: {'liya'})],
      ),
      Group(
        id: 'g-aau',
        name: 'AAU Gamers',
        short: 'AAU',
        kind: GroupKind.campus,
        place: 'Addis Ababa University',
        tone: Tone.grey,
        members: {'meron', 'dave', 'hana'},
        admins: {'meron'},
        extra: 212,
        approval: true,
        since: 'Oct 2025',
        about: 'Students and alumni of Addis Ababa University. Campus LAN days, inter-faculty tournaments and study-break sessions.',
        rules: ['Current students and alumni only.', 'Tournament sign-ups close 48h before start.'],
        posts: [GroupPost('meron', 'Inter-faculty CODM tournament sign-ups are open. Squads of 5.', '1d', gg: 18)],
        events: [GroupEvent(id: 'e5', title: 'Campus LAN day', when: 'Sat 14:00', going: {'meron', 'dave'})],
      ),
      Group(
        id: 'g-codm',
        name: 'Addis CODM Squads',
        short: 'CODM',
        kind: GroupKind.squad,
        gameId: 'codm',
        place: 'Addis Ababa',
        tone: Tone.accent,
        members: {'meron'},
        admins: {'meron'},
        extra: 74,
        since: 'Jun 2026',
        about: 'Competitive CODM squads in Addis. Scrims every week, ranked pushes every night.',
        rules: ['Mic required for scrims.'],
        posts: [GroupPost('meron', 'Scrim vs Hawassa squad on Thursday. Need a sniper sub.', '6h', gg: 7)],
      ),
    ];

class Activity {
  const Activity(this.pid, this.icon, this.text, this.t, this.bg);
  final String pid, icon, text, t;
  final Tone bg;
}

const activity = [
  Activity('meron', 'GG', 'reacted GG to your post', '12m', Tone.soft),
  Activity('dave', 'LFG', 'answered your listing', '40m', Tone.accent),
  Activity('liya', '@', 'mentioned you in a discussion', '1h', Tone.lav),
  Activity('abel', '+', 'accepted your connection', '3h', Tone.grey),
];

List<Listing> seedListings(DateTime t0) => [
      Listing(id: 1, pid: 'dave', game: 'val', mode: 'Ranked', rank: 'Diamond', want: 'Duo', mic: true, platform: 'PC', when: 'Tonight', note: 'Looking for a ranked duo tonight.', exp: t0.add(const Duration(hours: 2, minutes: 14))),
      Listing(id: 2, pid: 'meron', game: 'codm', mode: 'Ranked', rank: 'Legendary', want: 'Squad', mic: true, platform: 'Mobile', when: 'Now', note: 'Need 2 for MP ranked. Chill comms, no rage.', exp: t0.add(const Duration(minutes: 48))),
      Listing(id: 3, pid: 'hana', game: 'fc', mode: 'Pro Clubs', rank: 'Div 2', want: '3 players', mic: false, platform: 'PlayStation', when: 'Tonight', note: 'Pro Clubs squad needs a striker and two CBs.', exp: t0.add(const Duration(hours: 5, minutes: 2))),
      Listing(id: 4, pid: 'abel', game: 'val', mode: 'Unrated', rank: 'Platinum', want: 'Trio', mic: true, platform: 'PC', when: 'Weekend', note: 'Warm-up unrated then ranked if we vibe.', exp: t0.add(const Duration(hours: 20))),
      Listing(id: 5, pid: 'liya', game: 'mc', mode: 'Casual', rank: 'Creative', want: 'Builders', mic: false, platform: 'PC', when: 'Tonight', note: 'Building Addis in Minecraft. Bring ideas.', exp: t0.add(const Duration(hours: 9, minutes: 30))),
    ];

List<Post> seedPosts() => [
      const Post(id: 'p1', pid: 'dave', kind: PostKind.text, tag: 'Milestone', game: 'VALORANT', text: 'Finally reached Diamond. Took 140 games and one very patient duo.', gg: 42, c: 9, time: '2h'),
      const Post(id: 'p2', pid: 'meron', kind: PostKind.moment, game: 'CODM', text: 'Craziest clutch I’ve had all season — 1v4 on Standoff.', gg: 88, c: 21, time: '4h', dur: '00:24'),
      const Post(id: 'p3', pid: 'liya', kind: PostKind.discussion, game: 'CO-OP', text: 'Best co-op game you’ve played recently?', gg: 15, c: 34, time: '5h', top: ('Hana', 'It Takes Two, no contest.')),
      const Post(id: 'p5', pid: 'abel', kind: PostKind.poll, tag: 'Poll', game: 'VAL', text: 'Which map should get pulled from the pool next act?', gg: 19, c: 0, time: '5h', poll: Poll(['Breeze', 'Icebox', 'Fracture', 'Pearl'], [31, 18, 44, 12], '1 day')),
      const Post(id: 'p6', pid: 'meron', kind: PostKind.recruit, tag: 'Recruitment', game: 'CODM', text: 'Recruiting for our CODM team ahead of the Addis Cup. Practice 3 nights a week, mics required.', gg: 24, c: 0, time: '6h', recruit: Recruit('2', 'Sniper, Support')),
      const Post(id: 'p4', pid: 'yonas', kind: PostKind.text, tag: 'Looking for players', game: 'LoL', text: 'Anyone playing tonight? Need a mid who actually roams.', gg: 7, c: 3, time: '6h'),
    ];

Map<String, List<Comment>> seedComments() => {
      'p1': [const Comment('abel', 'Congrats! Duo queue this weekend? I’ll smoke, you entry.', '1h', 6), const Comment('meron', '140 games is dedication. GG.', '1h', 3), const Comment('yonas', 'What rank was the patient duo? Asking for me.', '50m', 2)],
      'p2': [const Comment('dave', 'That last flick was disgusting 😭 squad up later?', '3h', 11), const Comment('hana', 'Not even my game and I felt that.', '2h', 4)],
      'p3': [const Comment('hana', 'It Takes Two, no contest.', '4h', 12), const Comment('liya', 'Minecraft with a proper build plan. Our server has room.', '3h', 7), const Comment('abel', 'Deep Rock Galactic. Rock and stone.', '2h', 5)],
      'p4': [const Comment('dave', 'I can fill mid if you’re okay with an Emerald Ahri', '5h', 2)],
    };
