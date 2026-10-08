import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'data.dart';
import 'theme.dart';

enum Screen { landing, login, signup, games, ranks, platforms, home, compose, find, communities, group, createGroup, notifs, profile, editProfile, search }

enum Conn { none, sent, incoming, connected }

enum SheetKind { listing, session }

const mainScreens = {Screen.home, Screen.find, Screen.communities, Screen.notifs, Screen.profile};

class ListingDraft {
  String game = 'val', mode = 'Ranked', want = 'Duo', voice = 'Required', when = 'Tonight', note = '', dur = '6h';
}

class SessionDraft {
  String game = 'val', when = 'Tonight 21:00';
}

class ComposeDraft {
  ComposeDraft({this.game = 'val'});
  String type = 'Discussion', game, text = '', pollDur = '1 day', slots = '2', roles = '', aud = 'Everyone';
  List<MediaItem> files = [];
  List<String> poll = ['', ''];

  bool get ready => text.trim().isNotEmpty && (type != 'Poll' || poll.where((x) => x.trim().isNotEmpty).length >= 2);
}

/// Working copy of the profile while editing; applied on Save.
class ProfileDraft {
  ProfileDraft.from(AppState s)
      : name = s.name,
        handle = s.handle,
        bio = s.bio,
        city = s.city,
        games = [...s.myGames],
        ranks = {...s.ranks},
        platforms = [...s.platforms],
        ids = {...s.ids},
        idVis = {...s.idVis};

  String name, handle, bio, city;
  List<String> games;
  Map<String, String> ranks;
  List<String> platforms;
  Map<String, String> ids;
  Map<String, bool> idVis;

  bool differs(AppState s) =>
      name != s.name ||
      handle != s.handle ||
      bio != s.bio ||
      city != s.city ||
      !_listEq(games, s.myGames) ||
      !_mapEq(ranks, s.ranks) ||
      !_listEq(platforms, s.platforms) ||
      !_mapEq(ids, s.ids) ||
      !_mapEq(idVis, s.idVis);

  static bool _listEq<T>(List<T> a, List<T> b) => a.length == b.length && [for (var i = 0; i < a.length; i++) a[i] == b[i]].every((x) => x);
  static bool _mapEq<K, V>(Map<K, V> a, Map<K, V> b) => a.length == b.length && a.keys.every((k) => b.containsKey(k) && b[k] == a[k]);
}

class GroupDraft {
  String name = '', place = 'Addis Ababa', about = '';
  GroupKind kind = GroupKind.game;
  String? gameId;
  bool approval = false;
  Tone tone = Tone.accent;
}

class Session {
  const Session(this.game, this.time);
  final String game, time;
}

enum Look { strong, quiet, accent }

/// Button look for a connection state; colours come from the active skin.
class ConnLook {
  const ConnLook(this.label, this.look);
  final String label;
  final Look look;
}

/// Who wrote something: a seeded player or the current user ("me").
class Person {
  const Person(this.name, this.init, this.av);
  final String name, init;
  final Tone av;
}

const _videoExt = {'mp4', 'mov', 'm4v', 'webm', '3gp', 'mkv', 'avi'};

class AppState extends ChangeNotifier {
  AppState({Screen start = Screen.landing, String? themeId, this.persistTheme}) : screen = start, theme = ValueNotifier(themeById(themeId)) {
    final t0 = DateTime.now();
    now = ValueNotifier(t0);
    listings = seedListings(t0);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => now.value = DateTime.now());
  }

  late final ValueNotifier<DateTime> now;

  /// Active skin. Separate from the main notifier so only MaterialApp listens.
  final ValueNotifier<RallyTheme> theme;
  final void Function(String id)? persistTheme;
  late final Timer _ticker;
  Timer? _toastTimer;
  final _timers = <Timer>[];

  // Navigation
  Screen screen;
  Screen prev = Screen.home;
  SheetKind? sheet;
  String? toastMsg;
  String? viewing;
  int introIdx = 0;

  // Me
  String name = 'Kaleb', handle = 'kaleb.gg', email = '', age = '18–24';
  String loginUser = '', loginPass = '', password = '';
  String bio = 'Gold Valorant, Div 3 FC. Looking for people who actually call out.', city = 'Addis Ababa';

  /// Set while the Edit profile form is open.
  ProfileDraft? edit;
  bool confirmDiscard = false;
  List<String> myGames = ['val', 'fc'];
  Map<String, String> ranks = {'val': 'Gold', 'fc': 'Div 3'};
  List<String> platforms = ['PC', 'PlayStation'];
  Map<String, String> ids = {'Riot ID': 'kaleb#ADD', 'Discord': 'kaleb.gg', 'Steam': '', 'PlayStation': ''};
  Map<String, bool> idVis = {'Riot ID': true, 'Discord': true, 'Steam': false, 'PlayStation': false};
  int statusIdx = 0;

  // Social
  Map<String, Conn> conn = {'hana': Conn.incoming, 'yonas': Conn.incoming, 'meron': Conn.connected};
  Map<String, Session> sessions = {};
  late List<Listing> listings;
  List<Post> posts = seedPosts();
  Map<String, List<Comment>> comments = seedComments();
  Set<String> gg = {}, openC = {}, cGG = {}, applied = {};
  Map<String, String> cDraft = {};
  Map<String, int> pollVote = {};
  bool notify = false;

  // Groups
  List<Group> groups = seedGroups();
  String groupsTab = 'Discover', groupKind = 'All', groupQuery = '';
  String? groupId;
  Screen groupPrev = Screen.communities;
  String groupTab = 'Feed';
  String groupDraftPost = '';
  Set<String> groupRequests = {};
  GroupDraft? newGroup;
  Set<String> saved = {};

  // Home feed
  String feedTab = 'For you';
  bool filterOpen = false;

  // Find / search / profile
  String filterGame = 'all';
  bool fMic = false, fTonight = false, fComp = false;
  String q = '';
  String ptab = 'Overview';

  // Drafts
  ListingDraft draft = ListingDraft();
  SessionDraft sess = SessionDraft();
  ComposeDraft cp = ComposeDraft();

  /// Mutate state and rebuild.
  void update(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.cancel();
    _toastTimer?.cancel();
    for (final t in _timers) {
      t.cancel();
    }
    now.dispose();
    theme.dispose();
    super.dispose();
  }

  // ---- derived ----

  String get init => name.isEmpty ? '?' : name[0].toUpperCase();
  StatusOption get status => statuses[statusIdx];
  List<Listing> get live => listings.where((l) => l.exp.isAfter(now.value)).toList();
  List<String> get requestIds => conn.keys.where((k) => conn[k] == Conn.incoming).toList();
  List<String> get connectedIds => conn.keys.where((k) => conn[k] == Conn.connected).toList();

  Person who(String pid) {
    if (pid == 'me') return Person(name, init, Tone.accent);
    final p = players[pid]!;
    return Person(p.name, p.init, p.av);
  }

  /// "Diamond Valorant" — a player's headline rank.
  String rankLine(String pid) {
    if (pid == 'me') {
      if (myGames.isEmpty) return '';
      final g = gameById(myGames.first);
      return '${ranks[g.id] ?? ''} ${g.name}';
    }
    final g = players[pid]!.games.first;
    return '${g.rank} ${gameById(g.id).name}';
  }

  ConnLook connLook(String pid) => switch (conn[pid] ?? Conn.none) {
        Conn.connected => const ConnLook('Connected ✓', Look.strong),
        Conn.sent => const ConnLook('Requested…', Look.quiet),
        Conn.incoming => const ConnLook('Accept request', Look.accent),
        Conn.none => const ConnLook('Connect', Look.accent),
      };

  int commentCount(Post p) => p.c + (comments[p.id] ?? const []).where((c) => c.mine).length;

  String commentLabel(Post p) {
    final open = openC.contains(p.id);
    return '${open ? 'Hide · ' : ''}${commentCount(p)}${p.kind == PostKind.discussion ? ' answers' : ' comments'}';
  }

  /// Posts for the current feed filter.
  List<Post> get feed => switch (feedTab) {
        'For you' => posts,
        'Connections' => posts.where((p) => p.pid == 'me' || conn[p.pid] == Conn.connected).toList(),
        'LFG' => posts.where((p) => p.kind == PostKind.recruit || p.tag == 'Looking for players' || p.tag == 'Recruitment').toList(),
        final gid => posts.where((p) => gameByLabel(p.game)?.id == gid).toList(),
      };

  /// (id, label) options in the feed filter menu.
  List<(String, String)> get feedOptions => [
        ('For you', 'For you'),
        ('Connections', 'Connections'),
        ('LFG', 'LFG & recruiting'),
        for (final id in myGames) (id, gameById(id).name),
      ];

  Group? get group => groups.where((g) => g.id == groupId).firstOrNull;
  List<Group> groupsOf(String pid) => groups.where((g) => g.members.contains(pid)).toList();

  // ---- actions ----

  void setTheme(String id) {
    if (theme.value.id == id) return;
    theme.value = themeById(id);
    persistTheme?.call(id);
  }

  void setFeedTab(String id) => update(() {
        feedTab = id;
        filterOpen = false;
      });

  void toggleSave(String postId) {
    final on = !saved.contains(postId);
    update(() => on ? saved.add(postId) : saved.remove(postId));
    if (on) toast('Saved to your bookmarks');
  }

  Future<void> share(Post p) async {
    await Clipboard.setData(ClipboardData(text: '${who(p.pid).name} on rally: “${p.text}”'));
    toast('Copied to clipboard');
  }

  void toast(String msg) {
    _toastTimer?.cancel();
    update(() => toastMsg = msg);
    _toastTimer = Timer(const Duration(milliseconds: 2600), () => update(() => toastMsg = null));
  }

  void go(Screen s, [VoidCallback? extra]) => update(() {
        screen = s;
        sheet = null;
        filterOpen = false;
        extra?.call();
      });

  void goProfileTab() => go(Screen.profile, () {
        viewing = null;
        ptab = 'Overview';
      });

  void openPlayer(String pid) {
    if (pid == 'me') return goProfileTab();
    update(() {
      if (screen != Screen.profile) prev = screen;
      screen = Screen.profile;
      viewing = pid;
      ptab = 'Overview';
      sheet = null;
    });
  }

  void back() => go(prev != Screen.profile ? prev : Screen.home, () => viewing = null);

  void goSearch() => update(() {
        if (screen != Screen.search) prev = screen;
        screen = Screen.search;
        q = '';
      });

  void connect(String pid) {
    final c = conn[pid] ?? Conn.none;
    final n = players[pid]!.name;
    switch (c) {
      case Conn.none:
        update(() => conn[pid] = Conn.sent);
        toast('Request sent to $n');
        // Prototype stand-in for the other side: auto-accept after a moment.
        _timers.add(Timer(const Duration(milliseconds: 3500), () {
          if (conn[pid] == Conn.sent) {
            update(() => conn[pid] = Conn.connected);
            toast('$n accepted — you’re connected');
          }
        }));
      case Conn.incoming:
        update(() => conn[pid] = Conn.connected);
        toast('Connected with $n');
      case Conn.connected:
        openSessionSheet();
      case Conn.sent:
        break;
    }
  }

  void accept(String pid) {
    update(() => conn[pid] = Conn.connected);
    toast('Connected with ${players[pid]!.name}');
  }

  void decline(String pid) => update(() => conn[pid] = Conn.none);

  void cycleStatus() => update(() => statusIdx = (statusIdx + 1) % statuses.length);

  void openListingSheet() => update(() {
        draft.game = myGames.isNotEmpty ? myGames.first : 'val';
        sheet = SheetKind.listing;
      });

  void openSessionSheet() {
    final pid = viewing;
    if (pid == null) return;
    update(() {
      sess
        ..game = players[pid]!.games.first.id
        ..when = 'Tonight 21:00';
      sheet = SheetKind.session;
    });
  }

  void closeSheet() => update(() => sheet = null);

  void submitListing() {
    final d = draft;
    final l = Listing(
      id: DateTime.now().millisecondsSinceEpoch,
      pid: 'me',
      game: d.game,
      mode: d.mode,
      rank: ranks[d.game] ?? 'Unranked',
      want: d.want,
      mic: d.voice == 'Required',
      platform: platforms.isNotEmpty ? platforms.first : 'PC',
      when: d.when,
      note: d.note.trim().isNotEmpty ? d.note.trim() : 'Looking for a ${d.mode.toLowerCase()} ${d.want.toLowerCase()} ${d.when.toLowerCase()}.',
      exp: DateTime.now().add(Duration(hours: int.parse(d.dur.replaceAll('h', '')))),
    );
    update(() {
      listings = [l, ...listings];
      sheet = null;
      screen = Screen.find;
      filterGame = 'all';
      fMic = fTonight = fComp = false;
      statusIdx = 0;
      draft.note = '';
    });
    toast('Listing live — status set to Looking for players');
  }

  void submitSession() {
    final pid = viewing;
    if (pid == null) return;
    final t = now.value;
    final time = switch (sess.when) {
      'Now' => '${pad2(t.hour)}:${pad2(t.minute)}',
      'In 30 min' => () {
          final x = t.add(const Duration(minutes: 30));
          return '${pad2(x.hour)}:${pad2(x.minute)}';
        }(),
      _ => '21:00',
    };
    update(() {
      sessions[pid] = Session(gameById(sess.game).name, time);
      sheet = null;
    });
    toast('Invite sent — ${players[pid]!.name} gets a notification');
  }

  void toggleGG(String postId) => update(() => gg.contains(postId) ? gg.remove(postId) : gg.add(postId));
  void toggleComments(String postId) => update(() => openC.contains(postId) ? openC.remove(postId) : openC.add(postId));
  void toggleCommentGG(String key) => update(() => cGG.contains(key) ? cGG.remove(key) : cGG.add(key));

  void sendComment(String postId) {
    final t = (cDraft[postId] ?? '').trim();
    if (t.isEmpty) return;
    update(() {
      cDraft[postId] = '';
      comments[postId] = [...(comments[postId] ?? const []), Comment('me', t, 'now', 0, mine: true)];
    });
  }

  void vote(String postId, int i) {
    if (pollVote.containsKey(postId)) return;
    update(() => pollVote[postId] = i);
  }

  void apply(Post p) {
    if (p.pid == 'me' || applied.contains(p.id)) return;
    update(() => applied.add(p.id));
    toast('Applied — ${who(p.pid).name} will see your gamer profile');
  }

  // ---- compose ----

  void openCompose([String? type]) => update(() {
        screen = Screen.compose;
        sheet = null;
        if (type != null) cp.type = type;
        cp.game = myGames.isNotEmpty ? myGames.first : 'val';
      });

  Future<void> openComposeMedia() async {
    openCompose('Gameplay');
    await pickMedia();
  }

  Future<void> pickMedia() async {
    final room = 4 - cp.files.length;
    if (room <= 0) return toast('Up to 4 files per post');
    try {
      final picker = ImagePicker();
      final picked = room == 1
          ? [?await picker.pickMedia()]
          : await picker.pickMultipleMedia(limit: room);
      final items = <MediaItem>[];
      for (final x in picked.take(room)) {
        final ext = x.name.split('.').last.toLowerCase();
        final isVideo = (x.mimeType?.startsWith('video') ?? false) || _videoExt.contains(ext);
        items.add(MediaItem(name: x.name, isVideo: isVideo, bytes: isVideo ? null : await x.readAsBytes()));
      }
      if (items.isEmpty) return;
      update(() => cp.files = [...cp.files, ...items].take(4).toList());
    } on PlatformException {
      toast('Couldn’t open your gallery');
    }
  }

  void submitPost() {
    final c = cp;
    if (!c.ready) {
      return toast(c.type == 'Poll' && c.text.trim().isNotEmpty ? 'Add at least 2 poll options' : 'Write something first');
    }
    final kind = c.type == 'Poll' ? PostKind.poll : c.type == 'Recruitment' ? PostKind.recruit : PostKind.text;
    final opts = c.poll.map((x) => x.trim()).where((x) => x.isNotEmpty).toList();
    final post = Post(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      pid: 'me',
      kind: kind,
      tag: c.type,
      game: c.game == 'any' ? 'GAMING' : gameById(c.game).short.toUpperCase(),
      text: c.text.trim(),
      gg: 0,
      c: 0,
      time: 'now',
      media: c.files,
      poll: kind == PostKind.poll ? Poll(opts, List.filled(opts.length, 0), c.pollDur) : null,
      recruit: kind == PostKind.recruit ? Recruit(c.slots, c.roles.trim()) : null,
    );
    update(() {
      posts = [post, ...posts];
      screen = Screen.home;
      cp = ComposeDraft(game: myGames.isNotEmpty ? myGames.first : 'val');
    });
    toast('${c.type} posted');
  }

  // ---- onboarding ----

  /// Sign-up step 1 → games, once the account fields look valid.
  void submitSignup() {
    String? problem;
    if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(email.trim())) {
      problem = 'Enter a valid email';
    } else if (name.trim().isEmpty) {
      problem = 'Add a display name';
    } else if (handle.trim().isEmpty) {
      problem = 'Pick a username';
    } else if (password.length < 8) {
      problem = 'Password needs at least 8 characters';
    }
    if (problem != null) return toast(problem);
    go(Screen.games);
  }

  void toggleGame(List<String> list, String id) => update(() => list.contains(id) ? list.remove(id) : list.add(id));

  void goRanks() {
    if (myGames.isEmpty) return toast('Pick at least one game');
    go(Screen.ranks);
  }

  // ---- groups ----

  void openGroup(String id) => update(() {
        if (screen != Screen.group) groupPrev = screen;
        screen = Screen.group;
        groupId = id;
        groupTab = 'Feed';
        groupDraftPost = '';
        sheet = null;
      });

  void closeGroup() => go(groupPrev == Screen.group ? Screen.communities : groupPrev);

  /// Joins right away, or sends a request when the group needs approval
  /// (auto-approved after a moment, standing in for an admin).
  void joinGroup(Group g) {
    if (g.members.contains('me') || groupRequests.contains(g.id)) return;
    if (!g.approval) {
      update(() => g.members.add('me'));
      return toast('You joined ${g.name}');
    }
    update(() => groupRequests.add(g.id));
    toast('Request sent to ${g.name} admins');
    _timers.add(Timer(const Duration(milliseconds: 3500), () {
      if (!groupRequests.remove(g.id)) return;
      update(() => g.members.add('me'));
      toast('You’re in — ${g.name} approved your request');
    }));
  }

  void leaveGroup(Group g) {
    if (g.admins.contains('me') && g.admins.length == 1) return toast('Make someone else admin before leaving');
    update(() {
      g.members.remove('me');
      g.admins.remove('me');
    });
    toast('You left ${g.name}');
  }

  void postInGroup(Group g) {
    final text = groupDraftPost.trim();
    if (text.isEmpty) return;
    update(() {
      g.posts.insert(0, GroupPost('me', text, 'now'));
      groupDraftPost = '';
    });
  }

  void toggleGoing(GroupEvent e) => update(() => e.going.contains('me') ? e.going.remove('me') : e.going.add('me'));

  void addGroupEvent(Group g, String title, String when, String? gameId) {
    update(() => g.events.insert(0, GroupEvent(id: 'e${DateTime.now().millisecondsSinceEpoch}', title: title, when: when, gameId: gameId, going: {'me'})));
    toast('Event added — members will see it');
  }

  void openCreateGroup() => go(Screen.createGroup, () {
        newGroup = GroupDraft()
          ..gameId = myGames.isNotEmpty ? myGames.first : null
          ..place = city;
      });

  void createGroup() {
    final d = newGroup;
    if (d == null) return;
    final name = d.name.trim();
    if (name.length < 3) return toast('Give your group a name (3+ characters)');
    if (d.kind == GroupKind.game && d.gameId == null) return toast('Pick the game this group is for');
    if (d.place.trim().isEmpty) return toast('Add a city, campus or country');
    final words = name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final short = d.kind == GroupKind.game && d.gameId != null
        ? gameById(d.gameId!).short
        : (words.length > 1 ? words.take(3).map((w) => w[0]).join() : name.substring(0, name.length < 3 ? name.length : 3)).toUpperCase();
    final g = Group(
      id: 'g-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      short: short,
      kind: d.kind,
      gameId: d.kind == GroupKind.game ? d.gameId : null,
      place: d.place.trim(),
      about: d.about.trim().isEmpty ? 'A new group on rally.' : d.about.trim(),
      tone: d.tone,
      members: {'me'},
      admins: {'me'},
      approval: d.approval,
      since: 'Today',
    );
    update(() {
      groups = [g, ...groups];
      newGroup = null;
      groupsTab = 'Yours';
      groupPrev = Screen.communities;
      groupId = g.id;
      groupTab = 'About';
      screen = Screen.group;
    });
    toast('${g.name} is live — invite your squad');
  }

  // ---- edit profile ----

  void openEditProfile() => go(Screen.editProfile, () {
        edit = ProfileDraft.from(this);
        confirmDiscard = false;
      });

  void saveProfile() {
    final d = edit;
    if (d == null) return;
    if (d.name.trim().isEmpty || d.handle.trim().isEmpty) return toast('Name and username can’t be empty');
    if (d.games.isEmpty) return toast('Keep at least one game');
    update(() {
      name = d.name.trim();
      handle = d.handle.trim();
      bio = d.bio.trim();
      city = d.city.trim().isEmpty ? city : d.city.trim();
      myGames = [...d.games];
      ranks = {for (final id in d.games) if (d.ranks[id] != null) id: d.ranks[id]!};
      platforms = [...d.platforms];
      ids = {...d.ids};
      idVis = {...d.idVis};
      edit = null;
      screen = Screen.profile;
      viewing = null;
    });
    toast('Profile updated');
  }

  /// Leave the form; asks first when there are unsaved changes.
  void closeEditProfile({bool force = false}) {
    final d = edit;
    if (!force && d != null && d.differs(this)) return update(() => confirmDiscard = true);
    go(Screen.profile, () {
      edit = null;
      confirmDiscard = false;
      viewing = null;
    });
  }

  void finishOnboarding() {
    go(Screen.home);
    toast('Profile live — welcome, $name');
  }

  void doLogin() {
    go(Screen.home);
    toast('Welcome back. ${requestIds.length} connection requests waiting');
  }

  /// System back. Returns false when the app should close.
  bool handleBack() {
    if (sheet != null) {
      closeSheet();
      return true;
    }
    switch (screen) {
      case Screen.landing:
        if (introIdx == 0) return false;
        update(() => introIdx--);
      case Screen.home:
        return false;
      case Screen.login:
        go(Screen.landing);
      case Screen.signup:
        go(Screen.login);
      case Screen.games:
        go(Screen.signup);
      case Screen.ranks:
        go(Screen.games);
      case Screen.platforms:
        go(Screen.ranks);
      case Screen.group:
        closeGroup();
      case Screen.createGroup:
        go(Screen.communities, () => newGroup = null);
      case Screen.editProfile:
        if (confirmDiscard) {
          update(() => confirmDiscard = false);
        } else {
          closeEditProfile();
        }
      case Screen.search:
        back();
      case Screen.profile when viewing != null:
        back();
      default:
        go(Screen.home);
    }
    return true;
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);

  static AppState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

extension AppContext on BuildContext {
  AppState get app => AppScope.of(this);
}
