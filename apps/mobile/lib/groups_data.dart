import 'data.dart';
import 'theme.dart';

// Groups run on this sample data until the API has groups
// (docs/FEED_AND_GROUPS_API.md, phase 3). Nothing here leaves the phone.

enum GroupKind {
  game('Game'),
  city('City'),
  campus('Campus'),
  squad('Squad');

  const GroupKind(this.label);
  final String label;
}

/// Someone in a sample group. [me] is the signed-in player.
class Member {
  const Member(this.name, this.handle, this.tone, this.rank);
  final String name, handle, rank;
  final Tone tone;
  String get init => initialOf(name);
}

/// The sample people groups are made of, by key; "me" is the player.
const members = {
  'dave': Member('Dave', 'dave.exe', Tone.soft, 'Diamond · Valorant'),
  'hana': Member('Hana', 'hanaplays', Tone.lav, 'Div 2 · EA SPORTS FC'),
  'yonas': Member('Yonas', 'yonasjg', Tone.grey, 'Emerald · League of Legends'),
  'meron': Member('Meron', 'meron.codm', Tone.accent, 'Legendary · CoD Mobile'),
  'abel': Member('Abel', 'abelsmokes', Tone.soft, 'Platinum · Valorant'),
  'liya': Member('Liya', 'liya.mc', Tone.lav, 'Creative · Minecraft'),
};

class GroupPost {
  GroupPost(this.who, this.text, this.time, {this.gg = 0});
  final String who, text, time;
  final int gg;
}

class GroupEvent {
  GroupEvent({
    required this.id,
    required this.title,
    required this.when,
    this.gameId,
    Set<String>? going,
  }) : going = going ?? {};
  final String id, title, when;
  final String? gameId;
  final Set<String> going;
}

/// A community. [members] holds the people the app knows ("me" and the
/// sample players); [extra] stands in for everyone else.
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
  }) : posts = posts ?? [],
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

  /// "Valorant · Ethiopia", or "City · Addis Ababa".
  String line(Catalog c) => kind == GroupKind.game && gameId != null
      ? '${c.byId(gameId!).name} · $place'
      : '${kind.label} · $place';
}

class GroupDraft {
  String name = '', place = 'Addis Ababa', about = '';
  GroupKind kind = GroupKind.game;
  String? gameId;
  bool approval = false;
  Tone tone = Tone.accent;
}

/// "1,204" style member counts.
String groupCount(int n) =>
    n >= 1000 ? '${n ~/ 1000},${(n % 1000).toString().padLeft(3, '0')}' : '$n';

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
    rules: [
      'Be decent. No slurs, no harassment.',
      'LFG posts go in the feed with your rank and region.',
      'No account selling or boosting.',
    ],
    posts: [
      GroupPost(
        'dave',
        'Customs tonight at 21:00 — need two more for the second team. Reply here.',
        '25m',
        gg: 14,
      ),
      GroupPost(
        'abel',
        'Smoke lineups for Sunset B site, thread below. Took me a week to get these clean.',
        '3h',
        gg: 31,
      ),
      GroupPost(
        'meron',
        'Anyone else getting 120ms on the Bahrain server since the patch?',
        '5h',
        gg: 6,
      ),
    ],
    events: [
      GroupEvent(
        id: 'e1',
        title: '5-stack customs',
        when: 'Tonight 21:00',
        gameId: 'val',
        going: {'dave', 'abel'},
      ),
      GroupEvent(
        id: 'e2',
        title: 'Unrated night — new players welcome',
        when: 'Sat 19:00',
        gameId: 'val',
        going: {'meron'},
      ),
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
    posts: [
      GroupPost(
        'hana',
        'Pro Clubs: we need a CB and a striker for Sunday. Div 2 club, chill vibes.',
        '1h',
        gg: 9,
      ),
    ],
    events: [
      GroupEvent(
        id: 'e3',
        title: 'Pro Clubs night',
        when: 'Sun 20:00',
        gameId: 'fc',
        going: {'hana'},
      ),
    ],
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
    rules: [
      'No griefing on the shared server.',
      'Ask before building next to someone.',
    ],
    posts: [
      GroupPost(
        'liya',
        'Meskel Square is done! Next up: the light rail. Who wants to plan the route?',
        '2h',
        gg: 22,
      ),
    ],
    events: [
      GroupEvent(
        id: 'e4',
        title: 'Build night: light rail',
        when: 'Fri 20:00',
        gameId: 'mc',
        going: {'liya'},
      ),
    ],
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
    rules: [
      'Current students and alumni only.',
      'Tournament sign-ups close 48h before start.',
    ],
    posts: [
      GroupPost(
        'meron',
        'Inter-faculty CODM tournament sign-ups are open. Squads of 5.',
        '1d',
        gg: 18,
      ),
    ],
    events: [
      GroupEvent(
        id: 'e5',
        title: 'Campus LAN day',
        when: 'Sat 14:00',
        going: {'meron', 'dave'},
      ),
    ],
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
    posts: [
      GroupPost(
        'meron',
        'Scrim vs Hawassa squad on Thursday. Need a sniper sub.',
        '6h',
        gg: 7,
      ),
    ],
  ),
];
