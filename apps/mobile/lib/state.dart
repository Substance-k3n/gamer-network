import 'dart:async';
import 'dart:math';

import 'package:api_client/api_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'api.dart';
import 'data.dart';
import 'groups_data.dart';
import 'theme.dart';

enum Screen {
  splash,
  update,
  landing,
  login,
  signup,
  verify,
  forgot,
  games,
  ranks,
  platforms,
  home,
  compose,
  find,
  communities,
  group,
  createGroup,
  notifs,
  profile,
  editProfile,
  search,
  blocked,
  listing,
}

enum SheetKind { listing, session, applications }

const mainScreens = {
  Screen.home,
  Screen.find,
  Screen.communities,
  Screen.notifs,
  Screen.profile,
};

/// A random v4 UUID, for `Idempotency-Key` (docs/API.md "Idempotency").
String uuid4() {
  final r = Random.secure();
  final b = List<int>.generate(16, (_) => r.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40;
  b[8] = (b[8] & 0x3f) | 0x80;
  final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
}

class ListingDraft {
  String gameId = '';
  String? modeId;
  int partySize = 2;
  Platform platform = Platform.mobile;
  PlayStyle style = PlayStyle.competitive;
  Voice voice = Voice.required_;
  PlayWhen when = PlayWhen.tonight;
  int dur = 6;
  String note = '';

  /// Set when the sheet edits my live listing instead of posting one.
  String? editId;

  /// One key per listing the person means to post, reused on retries.
  String key = uuid4();
}

class SessionDraft {
  String gameId = '';
  InviteWhen when = InviteWhen.tonight;
  String key = uuid4();
}

/// A photo picked for a post, already resized on the phone.
class PickedPhoto {
  const PickedPhoto(this.bytes, this.type);
  final Uint8List bytes;
  final MediaContentType type;
}

/// Most photos a post can carry (docs/FEED_AND_GROUPS_API.md).
const maxPhotos = 4;

/// Longest recruitment roles line the API takes.
const maxRoles = 80;

/// The post being written in the composer.
class ComposeDraft {
  ComposeDraft({this.gameId});
  PostType type = PostType.discussion;

  /// Null is "Any game".
  String? gameId;

  /// The player picked the game (Any game included); reopening keeps it.
  bool gameSet = false;
  String text = '';
  PostAudience audience = PostAudience.everyone;
  String key = uuid4();

  List<PickedPhoto> photos = [];

  /// Poll options (2–4) and how long it runs.
  List<String> poll = ['', ''];
  PollDuration pollDur = PollDuration.n1d;

  /// Recruitment: open slots (1–10) and the roles wanted (≤ [maxRoles]).
  int slots = 1;
  String roles = '';

  List<String> get pollOptions => [
    for (final o in poll)
      if (o.trim().isNotEmpty) o.trim(),
  ];

  /// What Post still needs, or null when it can go.
  String? get missing {
    if (text.trim().isEmpty) return 'Write something first';
    if (type == PostType.gameplay && photos.isEmpty) {
      return 'Add at least one photo to a gameplay post';
    }
    if (type == PostType.poll && pollOptions.length < 2) {
      return 'Add at least two options';
    }
    return null;
  }

  bool get ready => missing == null;
}

/// Gamer-profile fields shared by onboarding and Edit profile: games with
/// ranks, platforms, tags and gaming IDs, keyed the way the screens use them.
class GamerDraft {
  List<String> games = [];

  /// Game key → rank id for catalog games, or free text for custom ones.
  Map<String, String> ranks = {};

  /// Game key → role id, for games whose catalog lists roles.
  Map<String, String> roles = {};
  List<Platform> platforms = [];
  List<PlayTag> tags = [];

  /// [idKey] → value / public. Rows with an empty value aren't saved.
  Map<String, String> ids = {};
  Map<String, bool> idVis = {};

  void loadFrom(MeDto me, Catalog catalog) {
    games = [];
    ranks = {};
    roles = {};
    for (final g in me.games) {
      final k = catalog.keyOf(g);
      games.add(k);
      final r = g.rank?.id ?? g.rankText;
      if (r != null && r.isNotEmpty) ranks[k] = r;
      if (g.role != null) roles[k] = g.role!.id;
    }
    platforms = me.platforms.toList();
    tags = me.tags.toList();
    ids = {};
    idVis = {};
    for (final x in me.gamingIds) {
      final k = idKey(x.kind, x.game?.id);
      ids[k] = x.value;
      idVis[k] = x.visibility == IdVisibility.public;
    }
  }

  void copyFrom(GamerDraft o) {
    games = [...o.games];
    ranks = {...o.ranks};
    roles = {...o.roles};
    platforms = [...o.platforms];
    tags = [...o.tags];
    ids = {...o.ids};
    idVis = {...o.idVis};
  }

  /// ID rows to offer: the fixed kinds, plus an in-game ID per mobile game.
  List<String> idRows(Catalog c) => [
    for (final k in idKinds) idKey(k),
    for (final g in games)
      if (!c.byId(g).custom && c.byId(g).platforms.contains(Platform.mobile))
        idKey(GamingIdKind.inGame, g),
  ];

  List<UserGameInput> gameInputs(Catalog c) => [
    for (final k in games)
      c.byId(k).custom
          ? UserGameInput(
              (b) => b
                ..customGameName = c.byId(k).name
                ..rankText = (ranks[k]?.trim().isEmpty ?? true)
                    ? null
                    : ranks[k]!.trim(),
            )
          : UserGameInput(
              (b) => b
                ..gameId = k
                ..rankId = c.byId(k).rank(ranks[k])?.id
                ..roleId = c.byId(k).role(roles[k])?.id,
            ),
  ];

  List<GamingIdInput> idInputs(Catalog c) {
    final rows = idRows(c);
    return [
      for (final k in rows)
        if ((ids[k] ?? '').trim().isNotEmpty)
          GamingIdInput((b) {
            final inGame = k.startsWith('in_game:');
            b
              ..kind = inGame ? GamingIdKind.inGame : kindOf(k)
              ..gameId = inGame ? k.substring(8) : null
              ..value = ids[k]!.trim()
              ..visibility = (idVis[k] ?? false)
                  ? IdVisibility.public
                  : IdVisibility.connections;
          }),
    ];
  }

  bool sameAs(GamerDraft o) =>
      _listEq(games, o.games) &&
      _mapEq(ranks, o.ranks) &&
      _mapEq(roles, o.roles) &&
      _listEq(platforms, o.platforms) &&
      _listEq(tags, o.tags) &&
      _mapEq(
        {
          for (final e in ids.entries)
            if (e.value.trim().isNotEmpty) e.key: e.value.trim(),
        },
        {
          for (final e in o.ids.entries)
            if (e.value.trim().isNotEmpty) e.key: e.value.trim(),
        },
      ) &&
      _mapEq(
        {
          for (final e in idVis.entries)
            if ((ids[e.key] ?? '').isNotEmpty) e.key: e.value,
        },
        {
          for (final e in o.idVis.entries)
            if ((o.ids[e.key] ?? '').isNotEmpty) e.key: e.value,
        },
      );

  static bool _listEq<T>(List<T> a, List<T> b) =>
      a.length == b.length &&
      [for (var i = 0; i < a.length; i++) a[i] == b[i]].every((x) => x);
  static bool _mapEq<K, V>(Map<K, V> a, Map<K, V> b) =>
      a.length == b.length &&
      a.keys.every((k) => b.containsKey(k) && b[k] == a[k]);
}

/// Working copy of the profile while editing; applied on Save.
class ProfileDraft extends GamerDraft {
  ProfileDraft.from(MeDto me, Catalog c)
    : name = me.displayName,
      handle = me.username,
      bio = me.bio ?? '',
      city = me.city,
      age = me.ageRange {
    loadFrom(me, c);
    _saved = GamerDraft()..copyFrom(this);
  }

  String name, handle, bio, city;
  AgeRange age;
  late final GamerDraft _saved;

  bool differs(MeDto me) =>
      name != me.displayName ||
      handle != me.username ||
      bio != (me.bio ?? '') ||
      city != me.city ||
      age != me.ageRange ||
      !sameAs(_saved);
}

enum Look { strong, quiet, accent }

/// Button look for a connection state; colours come from the active skin.
class ConnLook {
  const ConnLook(this.label, this.look);
  final String label;
  final Look look;
}

class AppState extends ChangeNotifier {
  AppState({
    required this.api,
    Screen start = Screen.splash,
    String? themeId,
    this.persistTheme,
    this.pollEvery = const Duration(seconds: 30),
  }) : screen = start,
       theme = ValueNotifier(themeById(themeId)) {
    now = ValueNotifier(DateTime.now());
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => now.value = DateTime.now(),
    );
    api.onSignedOut = _signedOut;
    api.onUpdateRequired = () => go(Screen.update);
  }

  final Api api;
  final Duration pollEvery;
  late final ValueNotifier<DateTime> now;

  /// Active skin. Separate from the main notifier so only MaterialApp listens.
  final ValueNotifier<RallyTheme> theme;
  final void Function(String id)? persistTheme;
  late final Timer _ticker;
  Timer? _toastTimer, _poll, _searchDebounce, _handleDebounce;
  bool _disposed = false;

  // Navigation
  Screen screen;

  /// Where a profile's back button returns, and where Search's does.
  Screen prev = Screen.home, searchPrev = Screen.home;
  SheetKind? sheet;
  String? toastMsg;
  int introIdx = 0;

  /// A call is running; buttons that start one wait for it.
  bool busy = false;

  /// Launch is slow (the server is waking up), or it failed to reach it.
  bool waking = false, offline = false;

  // App and catalog
  AppConfigResponse? config;
  Catalog catalog = Catalog();

  // Me
  MeDto? me;
  String email = '', name = '', handle = '', password = '';
  String loginUser = '', loginPass = '';
  AgeRange age = AgeRange.n1824;
  String code = '';

  /// Why the username being typed can't be used (sign-up, Edit profile).
  String? handleNote;

  /// Forgot password: email, then the emailed code and a new password.
  String resetEmail = '', resetCode = '', newPassword = '';
  bool resetSent = false;

  /// Onboarding draft (steps 2–4).
  final onboard = GamerDraft();

  /// Set while the Edit profile form is open.
  ProfileDraft? edit;
  bool confirmDiscard = false;

  // Home
  int lookingNow = 0, unread = 0;
  ListingDto? myListing;
  List<CheckInDto> checkIns = [];
  List<PlayInviteDto> invites = [];

  /// Invites I sent that are still waiting for an answer.
  List<PlayInviteDto> sentInvites = [];
  bool homeLoaded = false;

  // Home feed: [feedTab] is a FeedFilter name or a game id.
  List<PostDto> posts = [];
  String? postsCursor;
  bool postsLoaded = false, filterOpen = false;
  String feedTab = 'for_you';

  /// Comments under each open post, newest replies loaded on demand.
  Map<String, List<CommentDto>> comments = {}, replies = {};
  Set<String> openC = {};
  Map<String, String> cDraft = {};

  /// The comment a draft answers, per post (Reply).
  Map<String, CommentDto> replyTo = {};
  ComposeDraft cp = ComposeDraft();

  /// Applications to my recruitment post [appsPost] (the applications sheet).
  String? appsPost;
  List<RecruitApplicationDto>? apps;
  String? appsCursor;

  // Find Players
  List<ListingDto> listings = [];
  String? feedCursor;
  bool feedLoaded = false;
  String filterGame = 'all';
  bool fMic = false, fTonight = false, fComp = false;

  /// Filters offered once a game is picked: its platforms, modes, party
  /// sizes, and "my rank and up".
  Platform? fPlatform;
  String? fMode;
  int? fParty;
  bool fMyRank = false;

  /// The listing a notification or link opened (Screen.listing).
  ListingDto? openedListing;

  // Alerts
  List<ConnectionRequestDto> requests = [];
  List<NotificationDto> notifications = [];
  String? notifCursor;

  // Profiles: [viewing] is a username; null is me.
  String? viewing;
  Profile? viewed;
  List<ConnectionDto> connections = [];
  String? connCursor;
  String ptab = 'Overview';

  /// The viewed profile's posts (Posts and Moments tabs).
  List<PostDto> profilePosts = [];
  String? profilePostsCursor;

  /// My saved posts (the Saved tab on my profile), most recently saved first.
  List<PostDto>? saved;
  String? savedCursor;

  // Search
  String q = '';
  List<UserCardDto> found = [];

  // Settings
  List<UserCardDto> blocked = [];

  // Groups (the API's /v1/groups). [groupsTab] is Discover or Yours.
  List<GroupDto> groups = [];
  String? groupsCursor;
  bool groupsLoaded = false;
  String groupsTab = 'Discover', groupKind = 'All', groupQuery = '';

  /// My groups, pending requests included (GET /me/groups): Yours (n), my
  /// profile's strip and Groups tab.
  List<GroupDto> myGroups = [];

  /// The viewed player's groups (someone else's profile).
  List<GroupDto> theirGroups = [];

  // The open group page.
  String? groupId;
  GroupDto? group;
  Screen groupPrev = Screen.communities;
  String groupTab = 'Feed';
  String groupDraftPost = '';
  List<PostDto>? groupPosts;
  String? groupPostsCursor;
  List<GroupMemberDto>? members, joinRequests;
  String? membersCursor;
  List<GroupEventDto>? events;
  String? eventsCursor;

  /// The create / edit group form.
  GroupDraft? newGroup;
  String groupKey = uuid4();
  Timer? _groupSearch;

  /// The last call's error, for screens that show it inline.
  ApiError? lastError;

  // Drafts
  ListingDraft draft = ListingDraft();
  SessionDraft sess = SessionDraft();

  /// Mutate state and rebuild.
  void update(VoidCallback fn) {
    if (_disposed) return;
    fn();
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker.cancel();
    _toastTimer?.cancel();
    _poll?.cancel();
    _searchDebounce?.cancel();
    _handleDebounce?.cancel();
    _groupSearch?.cancel();
    now.dispose();
    theme.dispose();
    super.dispose();
  }

  // ---- derived ----

  String get myName => me?.displayName ?? name;
  String get init => initialOf(myName);
  bool get verified => me?.emailVerified ?? false;
  List<Game> get launchGames => catalog.launch;

  ConnLook connLook(Relationship r) => switch (r) {
    Relationship.connected => const ConnLook('Connected ✓', Look.strong),
    Relationship.outgoingRequest => const ConnLook('Requested…', Look.quiet),
    Relationship.incomingRequest => const ConnLook(
      'Accept request',
      Look.accent,
    ),
    _ => const ConnLook('Connect', Look.accent),
  };

  ConnLook listingLook(ListingDto l) => switch (l.myRequest?.status) {
    _ when l.owner.id == me?.id => const ConnLook('Your listing', Look.quiet),
    RequestStatus.accepted => const ConnLook('Connected ✓', Look.strong),
    RequestStatus.pending => const ConnLook('Requested…', Look.quiet),
    _ => const ConnLook('Connect', Look.accent),
  };

  /// "Diamond · CoD Mobile": a player's headline game.
  String rankLine(UserGameDto? g) {
    if (g == null) return '';
    final game = g.game?.name ?? g.customGameName ?? '';
    final rank = g.rank?.name ?? g.rankText;
    return rank == null || rank.isEmpty ? game : '$rank · $game';
  }

  /// (id, label) options in the feed filter menu.
  List<(String, String)> get feedOptions => [
    ('for_you', 'For you'),
    ('connections', 'Connections'),
    ('lfg', 'LFG & recruiting'),
    for (final g in me?.games ?? BuiltList<UserGameDto>())
      if (g.game != null) (g.game!.id, g.game!.name),
  ];

  bool get groupAdmin => group?.myRole == GroupRole.admin;

  /// Groups I'm a member of (not just asked to join).
  int get joinedCount =>
      myGroups.where((g) => g.myStatus == MembershipStatus.member).length;

  /// Group admins may remove anything posted in their group.
  bool canModerate(PostDto p) =>
      p.group != null && p.group!.id == group?.id && groupAdmin;

  // ---- calls ----

  /// Runs an API call: shows its error as a toast and returns null on failure.
  Future<T?> call<T>(Future<T> Function() f, {bool quiet = false}) async {
    lastError = null;
    try {
      return await f();
    } catch (e, st) {
      final err = ApiError.from(e);
      lastError = err;
      if (kDebugMode && err.status == 0) debugPrint('API call failed: $e\n$st');
      if (err.code == 'email_not_verified') {
        toast('Confirm your email first: we sent you a code.');
        go(Screen.verify);
      } else if (!quiet && err.code != 'unauthenticated' && err.status != 426) {
        toast(err.detail);
      }
      return null;
    }
  }

  /// Like [call], with [busy] set while it runs.
  Future<T?> _busy<T>(Future<T> Function() f) async {
    if (busy) return null;
    update(() => busy = true);
    try {
      return await call(f);
    } finally {
      update(() => busy = false);
    }
  }

  // ---- start ----

  /// Launch: version check, catalog, then the saved session if any.
  Future<void> boot() async {
    update(() {
      offline = false;
      screen = Screen.splash;
    });
    final slow = Timer(
      const Duration(seconds: 3),
      () => update(() => waking = true),
    );
    try {
      final cfg = await call(
        () async => (await api.app.appConfigGet()).data!,
        quiet: true,
      );
      if (cfg == null) return update(() => offline = true);
      config = cfg;
      await loadCatalog();
      await api.restore();
      if (!api.signedIn) return go(Screen.landing);
      final m = await call(
        () async => (await api.me.meGet()).data!,
        quiet: true,
      );
      if (m != null) return _signedIn(m);
      // A 401 already cleared the session; anything else keeps it for a retry.
      api.signedIn ? update(() => offline = true) : go(Screen.landing);
    } finally {
      slow.cancel();
      update(() => waking = false);
    }
  }

  Future<void> loadCatalog() async {
    final list = await call(
      () async => (await api.games.gamesList()).data!,
      quiet: true,
    );
    if (list != null) {
      update(() => catalog = Catalog([for (final g in list) Game.fromDto(g)]));
    }
  }

  void _signedIn(MeDto m) {
    me = m;
    if (m.onboardedAt == null) {
      onboard.loadFrom(m, catalog);
      go(Screen.games);
    } else {
      go(Screen.home);
      refreshHome();
    }
    _poll?.cancel();
    _poll = Timer.periodic(pollEvery, (_) => _pollTick());
  }

  void _signedOut() {
    _poll?.cancel();
    update(() {
      me = null;
      homeLoaded = feedLoaded = postsLoaded = false;
      listings = [];
      posts = [];
      saved = null;
      comments = {};
      openC = {};
      requests = [];
      notifications = [];
      invites = [];
      checkIns = [];
      myListing = null;
      viewing = null;
      viewed = null;
      sheet = null;
      screen = Screen.login;
    });
    toast('Signed out. Log in again to keep playing.');
  }

  /// Keeps the bell badge and invite banner fresh while the app is open.
  Future<void> _pollTick() async {
    if (me?.onboardedAt == null) return;
    final n = await call(
      () async =>
          (await api.notifications.notificationsUnreadCount()).data!.count,
      quiet: true,
    );
    final inv = await call(
      () async =>
          (await api.play.playInvitesList(direction: 'incoming')).data!.items
              .toList(),
      quiet: true,
    );
    update(() {
      if (n != null) unread = n.toInt();
      if (inv != null) invites = inv;
    });
  }

  // ---- toast & navigation ----

  void setTheme(String id) {
    if (theme.value.id == id) return;
    theme.value = themeById(id);
    persistTheme?.call(id);
  }

  void toast(String msg) {
    _toastTimer?.cancel();
    update(() => toastMsg = msg);
    _toastTimer = Timer(
      const Duration(milliseconds: 2600),
      () => update(() => toastMsg = null),
    );
  }

  void go(Screen s, [VoidCallback? extra]) {
    update(() {
      screen = s;
      sheet = null;
      filterOpen = false;
      extra?.call();
    });
    switch (s) {
      case Screen.home:
        refreshHome();
        if (!postsLoaded) loadPosts();
      case Screen.find:
        loadFeed();
      case Screen.notifs:
        loadAlerts();
      case Screen.profile when viewing == null:
        loadMyProfile();
      case Screen.blocked:
        loadBlocked();
      case Screen.communities:
        loadGroups();
        loadMyGroups();
      default:
    }
  }

  void goProfileTab() => go(Screen.profile, () {
    viewing = null;
    viewed = null;
    ptab = 'Overview';
  });

  Future<void> openPlayer(String username) async {
    if (username == me?.username) return goProfileTab();
    update(() {
      if (screen != Screen.profile) prev = screen;
      screen = Screen.profile;
      viewing = username;
      viewed = null;
      ptab = 'Overview';
      profilePosts = [];
      profilePostsCursor = null;
      sheet = null;
    });
    final p = await call(
      () async => (await api.users.usersGet(username: username)).data!,
    );
    if (viewing != username) return;
    if (p == null) return back();
    update(() => viewed = Profile.of(p));
    loadProfilePosts();
    loadTheirGroups(username);
  }

  void back() => go(prev != Screen.profile ? prev : Screen.home, () {
    viewing = null;
    viewed = null;
  });

  void goSearch() => update(() {
    if (screen != Screen.search) {
      searchPrev = screen == Screen.profile && viewing != null
          ? Screen.home
          : screen;
    }
    screen = Screen.search;
    q = '';
    found = [];
  });

  void leaveSearch() => go(searchPrev, () {
    viewing = null;
    viewed = null;
  });

  void closeSheet() => update(() => sheet = null);

  // ---- sign-in ----

  Future<void> doLogin() async {
    final e = loginUser.trim();
    if (e.isEmpty) return toast('Enter your email or username');
    if (loginPass.isEmpty) return toast('Enter your password');
    final r = await _busy(
      () async => (await api.auth.authLogin(
        userAgent: api.userAgent,
        loginBody: LoginBody((b) {
          // An "@" means an email; anything else is a username.
          if (e.indexOf('@') > 0) {
            b.email = e;
          } else {
            b.username = e.replaceFirst(RegExp('^@'), '');
          }
          b.password = loginPass;
        }),
      )).data!,
    );
    if (r == null) return;
    await api.setToken(r.token);
    loginPass = '';
    _signedIn(r.user);
    if (r.user.onboardedAt != null) {
      toast('Welcome back, ${r.user.displayName}');
    }
  }

  /// Sign-up step 1: creates the account, then asks for the emailed code.
  Future<void> submitSignup() async {
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
    final r = await _busy(
      () async => (await api.auth.authSignup(
        userAgent: api.userAgent,
        signupBody: SignupBody(
          (b) => b
            ..email = email.trim()
            ..password = password
            ..displayName = name.trim()
            ..username = handle.trim().toLowerCase()
            ..ageRange = age,
        ),
      )).data!,
    );
    if (r == null) return;
    await api.setToken(r.token);
    password = '';
    me = r.user;
    onboard.loadFrom(r.user, catalog);
    go(Screen.verify, () => code = '');
    _poll?.cancel();
    _poll = Timer.periodic(pollEvery, (_) => _pollTick());
  }

  Future<void> verifyEmail() async {
    if (code.trim().length < 6) {
      return toast('Enter the 6-digit code from the email');
    }
    final m = await _busy(
      () async => (await api.auth.authVerifyEmail(
        codeBody: CodeBody((b) => b..code = code.trim()),
      )).data!,
    );
    if (m == null) return;
    me = m;
    code = '';
    toast('Email confirmed');
    afterVerify();
  }

  /// Leaves the code screen: onboarding if it isn't done, else back home.
  void afterVerify() =>
      me?.onboardedAt == null ? go(Screen.games) : go(Screen.home);

  Future<void> resendCode() async {
    final ok = await _busy(() async => api.auth.authResendVerification());
    if (ok != null) toast('New code sent to ${me?.email ?? 'your email'}');
  }

  Future<void> forgotPassword() async {
    final e = resetEmail.trim();
    if (!e.contains('@')) return toast('Enter the email you signed up with');
    final ok = await _busy(
      () async => api.auth.authForgotPassword(
        forgotPasswordBody: ForgotPasswordBody((b) => b..email = e),
      ),
    );
    if (ok == null) return;
    update(() => resetSent = true);
    toast('If $e has an account, a code is on its way');
  }

  Future<void> resetPassword() async {
    if (resetCode.trim().length < 6) {
      return toast('Enter the 6-digit code from the email');
    }
    if (newPassword.length < 8) {
      return toast('Password needs at least 8 characters');
    }
    final r = await _busy(
      () async => (await api.auth.authResetPassword(
        userAgent: api.userAgent,
        resetPasswordBody: ResetPasswordBody(
          (b) => b
            ..email = resetEmail.trim()
            ..code = resetCode.trim()
            ..newPassword = newPassword,
        ),
      )).data!,
    );
    if (r == null) return;
    await api.setToken(r.token);
    resetCode = newPassword = '';
    resetSent = false;
    toast('Password changed');
    _signedIn(r.user);
  }

  Future<void> logout() async {
    await call(() => api.auth.authLogout(), quiet: true);
    await api.setToken(null);
    _poll?.cancel();
    update(() {
      me = null;
      viewing = null;
      viewed = null;
      homeLoaded = feedLoaded = postsLoaded = false;
      posts = [];
      saved = null;
      comments = {};
      openC = {};
      screen = Screen.landing;
      introIdx = 2;
    });
  }

  Future<void> deleteAccount(String pw) async {
    final ok = await _busy(
      () async => api.safety.accountDelete(
        deleteAccountBody: DeleteAccountBody(
          (b) => b..password = me?.hasPassword == true ? pw : null,
        ),
      ),
    );
    if (ok == null) return;
    await api.setToken(null);
    _poll?.cancel();
    update(() {
      me = null;
      screen = Screen.landing;
      introIdx = 0;
    });
    toast('Account deleted. Your data is erased in 30 days.');
  }

  // ---- onboarding ----

  void toggleIn<T>(List<T> list, T x) =>
      update(() => list.contains(x) ? list.remove(x) : list.add(x));

  /// Step 2 → 3: saves the games (no ranks yet, docs/API.md onboarding).
  Future<void> goRanks() async {
    if (onboard.games.isEmpty) return toast('Pick at least one game');
    final m = await _busy(
      () async => (await api.me.meSetGames(
        setGamesBody: SetGamesBody(
          (b) => b..games = ListBuilder(onboard.gameInputs(catalog)),
        ),
      )).data!,
    );
    if (m == null) return;
    me = m;
    go(Screen.ranks);
  }

  /// "Go live": ranks, platforms, IDs, then POST /me/onboard.
  Future<void> finishOnboarding() async {
    final m = await _busy(() async {
      await _saveGamer(onboard);
      await api.me.meOnboard();
      return (await api.me.meGet()).data!;
    });
    if (m == null) return;
    me = m;
    go(Screen.home);
    toast('Profile live — welcome, ${m.displayName}');
  }

  Future<void> _saveGamer(GamerDraft d) async {
    await api.me.meSetGames(
      setGamesBody: SetGamesBody(
        (b) => b..games = ListBuilder(d.gameInputs(catalog)),
      ),
    );
    await api.me.meSetPlatforms(
      setPlatformsBody: SetPlatformsBody(
        (b) => b..platforms = SetBuilder(d.platforms),
      ),
    );
    await api.me.meSetTags(
      setTagsBody: SetTagsBody((b) => b..tags = SetBuilder(d.tags)),
    );
    await api.me.meSetGamingIds(
      setGamingIdsBody: SetGamingIdsBody(
        (b) => b..gamingIds = ListBuilder(d.idInputs(catalog)),
      ),
    );
  }

  // ---- home ----

  Future<void> refreshHome() async {
    if (me?.onboardedAt == null) return;
    final results = await Future.wait([
      call(() async => (await api.me.meGet()).data!, quiet: true),
      call(
        () async =>
            (await api.listings.listingsStats()).data!.lookingNow.toInt(),
        quiet: true,
      ),
      call(() async => (await api.listings.myListingGet()).data!, quiet: true),
      call(
        () async => (await api.play.checkInsDue()).data!.items.toList(),
        quiet: true,
      ),
      call(
        () async =>
            (await api.play.playInvitesList(direction: 'incoming')).data!.items
                .toList(),
        quiet: true,
      ),
      call(
        () async => (await api.notifications.notificationsUnreadCount())
            .data!
            .count
            .toInt(),
        quiet: true,
      ),
      call(
        () async =>
            (await api.play.playInvitesList(direction: 'outgoing')).data!.items
                .toList(),
        quiet: true,
      ),
    ]);
    update(() {
      me = results[0] as MeDto? ?? me;
      sentInvites = results[6] as List<PlayInviteDto>? ?? sentInvites;
      lookingNow = results[1] as int? ?? lookingNow;
      final ml = results[2] as MyListingDto?;
      if (ml != null) myListing = ml.listing;
      checkIns = results[3] as List<CheckInDto>? ?? checkIns;
      invites = results[4] as List<PlayInviteDto>? ?? invites;
      unread = results[5] as int? ?? unread;
      homeLoaded = true;
    });
  }

  Future<void> setStatus(PlayerStatus s, {List<Day>? days}) async {
    final gameId = s == PlayerStatus.notAvailable
        ? null
        : (me?.games.firstOrNull?.game?.id);
    final m = await call(
      () async => (await api.me.meSetStatus(
        setStatusBody: SetStatusBody(
          (b) => b
            ..status = s
            ..gameId = gameId
            ..availableDays = days == null ? null : SetBuilder(days),
        ),
      )).data!,
    );
    if (m != null) update(() => me = m);
  }

  /// Taps through the statuses on the profile card.
  void cycleStatus() {
    const order = [
      PlayerStatus.looking,
      PlayerStatus.playing,
      PlayerStatus.availableTonight,
      PlayerStatus.notAvailable,
    ];
    final i = order.indexOf(me?.status ?? PlayerStatus.notAvailable);
    setStatus(order[(i + 1) % order.length]);
  }

  void toggleDay(Day d) {
    final days = [...?me?.availableDays];
    days.contains(d) ? days.remove(d) : days.add(d);
    setStatus(me?.status ?? PlayerStatus.notAvailable, days: days);
  }

  Future<void> answerCheckIn(CheckInDto c, CheckInAnswer a) async {
    final ok = await call(
      () async => api.play.checkInsAnswer(
        id: c.id,
        answerCheckInBody: AnswerCheckInBody((b) => b..answer = a),
      ),
    );
    if (ok == null) return;
    update(() => checkIns = checkIns.where((x) => x.id != c.id).toList());
    toast(a == CheckInAnswer.played ? 'GG — glad you played' : 'Thanks, noted');
  }

  Future<void> answerInvite(PlayInviteDto i, bool accept) async {
    final ok = await call(
      () async => accept
          ? (await api.play.playInvitesAccept(id: i.id)).data
          : api.play.playInvitesDecline(id: i.id),
    );
    if (ok == null) return;
    update(() => invites = invites.where((x) => x.id != i.id).toList());
    toast(
      accept
          ? 'You’re on — ${i.game.name} with ${i.from.displayName}'
          : 'Invite declined',
    );
  }

  Future<void> closeMyListing() async {
    final l = myListing;
    if (l == null) return;
    final r = await _busy(
      () async => (await api.listings.listingsClose(id: l.id)).data!,
    );
    if (r == null) return;
    update(() => myListing = null);
    toast('Listing closed');
  }

  Future<void> shareListing(ListingDto l) async {
    await Clipboard.setData(ClipboardData(text: l.shareUrl));
    toast('Link copied — paste it in Telegram or WhatsApp');
  }

  // ---- find players ----

  Future<void> loadFeed({bool more = false}) async {
    if (me?.onboardedAt == null) return;
    final p = await call(
      () async => (await api.listings.listingsFeed(
        game: filterGame == 'all' ? null : filterGame,
        voice: fMic ? 'required' : null,
        when_: fTonight ? 'tonight' : null,
        style: fComp ? PlayStyle.competitive : null,
        platform: filterGame == 'all' ? null : fPlatform,
        mode: filterGame == 'all' ? null : fMode,
        partySize: filterGame == 'all' ? null : fParty,
        minRank: filterGame == 'all' || !fMyRank ? null : myRankIn(filterGame),
        cursor: more ? feedCursor : null,
      )).data!,
    );
    if (p == null) return;
    update(() {
      listings = more ? [...listings, ...p.items] : p.items.toList();
      feedCursor = p.nextCursor;
      feedLoaded = true;
    });
  }

  void setFilter(VoidCallback fn) {
    update(fn);
    loadFeed();
  }

  /// Picks the game filter; the game-specific filters start over.
  void setGameFilter(String id) => setFilter(() {
    filterGame = id;
    fPlatform = null;
    fMode = null;
    fParty = null;
    fMyRank = false;
  });

  /// My rank id in [gameId], if my profile has one.
  String? myRankIn(String gameId) =>
      me?.games.where((g) => g.game?.id == gameId).firstOrNull?.rank?.id;

  void openListingSheet() {
    final launch = launchGames;
    if (launch.isEmpty) {
      return toast('Find Players opens soon. No games are live yet.');
    }
    final mine = [
      for (final g in me?.games ?? BuiltList<UserGameDto>()) g.game?.id,
    ].whereType<String>().toSet();
    final pick = launch.firstWhere(
      (g) => mine.contains(g.id),
      orElse: () => launch.first,
    );
    update(() {
      draft = ListingDraft();
      _setDraftGame(pick);
      sheet = SheetKind.listing;
    });
  }

  /// Reopens the composer on my live listing: style, voice, when and note.
  void openEditListing() {
    final l = myListing;
    if (l == null) return;
    update(() {
      draft = ListingDraft()
        ..editId = l.id
        ..gameId = l.game.id
        ..style = l.style
        ..voice = l.voice
        ..when = l.playWhen
        ..note = l.note ?? '';
      sheet = SheetKind.listing;
    });
  }

  Future<void> _saveListingEdit(ListingDraft d) async {
    final l = await _busy(
      () async => (await api.listings.listingsUpdate(
        id: d.editId!,
        updateListingBody: UpdateListingBody(
          (b) => b
            ..voice = d.voice
            ..style = d.style
            ..playWhen = d.when
            ..note = d.note.trim(),
        ),
      )).data!,
    );
    if (l == null) return;
    update(() {
      myListing = l;
      sheet = null;
      draft = ListingDraft();
    });
    toast('Listing updated');
  }

  void setDraftGame(String id) => update(() => _setDraftGame(catalog.byId(id)));

  void _setDraftGame(Game g) {
    final d = draft;
    d.gameId = g.id;
    d.modeId = g.modes.firstOrNull?.id;
    if (d.partySize > g.maxParty) d.partySize = 2;
    final mine = me?.platforms ?? BuiltList<Platform>();
    d.platform = g.platforms.contains(d.platform)
        ? d.platform
        : mine.firstWhere(
            g.platforms.contains,
            orElse: () =>
                g.platforms.isNotEmpty ? g.platforms.first : Platform.mobile,
          );
  }

  Future<void> submitListing() async {
    final d = draft;
    if (d.editId != null) return _saveListingEdit(d);
    final l = await _busy(
      () async => (await api.listings.listingsCreate(
        idempotencyKey: d.key,
        createListingBody: CreateListingBody(
          (b) => b
            ..gameId = d.gameId
            ..modeId = d.modeId
            ..platform = d.platform
            ..partySize = d.partySize
            ..voice = d.voice
            ..style = d.style
            ..playWhen = d.when
            ..durationHours = switch (d.dur) {
              2 => CreateListingBodyDurationHoursEnum.number2,
              24 => CreateListingBodyDurationHoursEnum.number24,
              _ => CreateListingBodyDurationHoursEnum.number6,
            }
            ..note = d.note.trim().isEmpty ? null : d.note.trim(),
        ),
      )).data!,
    );
    if (l == null) return;
    update(() {
      myListing = l;
      sheet = null;
      draft = ListingDraft();
    });
    toast('Listing live — status set to Looking for players');
    go(Screen.home);
  }

  /// Connect from a listing card.
  Future<void> connectFromListing(ListingDto l) async {
    if (l.myRequest != null) return;
    final r = await _busy(
      () async => (await api.connections.connectionRequestsSend(
        idempotencyKey: uuid4(),
        sendRequestBody: SendRequestBody(
          (b) => b
            ..toUserId = l.owner.id
            ..listingId = l.id,
        ),
      )).data!,
    );
    if (r == null) return;
    toast('Request sent to ${l.owner.displayName}');
    loadFeed();
  }

  /// Takes back my pending request on a listing.
  Future<void> withdrawFromListing(ListingDto l) async {
    final r = l.myRequest;
    if (r == null || r.status != RequestStatus.pending) return;
    final ok = await _busy(
      () async => api.connections.connectionRequestsCancel(id: r.id),
    );
    if (ok == null) return;
    toast('Request to ${l.owner.displayName} withdrawn');
    loadFeed();
    if (openedListing?.id == l.id) openListing(l.id);
  }

  /// A listing on its own, from a notification or a link.
  Future<void> openListing(String id) async {
    update(() {
      if (screen != Screen.listing) prev = screen;
      screen = Screen.listing;
      if (openedListing?.id != id) openedListing = null;
      sheet = null;
    });
    final l = await call(
      () async => (await api.listings.listingsGet(id: id)).data!,
    );
    if (l == null) return go(prev);
    update(() => openedListing = l);
  }

  // ---- connections & profiles ----

  /// The profile's main button: connect, accept, or invite to play.
  Future<void> connect() async {
    final p = viewed;
    if (p == null) return;
    switch (p.relationship) {
      case Relationship.none:
        final r = await _busy(
          () async => (await api.connections.connectionRequestsSend(
            idempotencyKey: uuid4(),
            sendRequestBody: SendRequestBody((b) => b..toUserId = p.id),
          )).data!,
        );
        if (r != null) toast('Request sent to ${p.displayName}');
      case Relationship.incomingRequest when p.incomingRequestId != null:
        final r = await _busy(
          () async => (await api.connections.connectionRequestsAccept(
            id: p.incomingRequestId!,
          )).data!,
        );
        if (r != null) toast('Connected with ${p.displayName}');
      case Relationship.connected:
        return openSessionSheet();
      default:
        return;
    }
    await openPlayer(p.username);
  }

  /// Takes back my pending request to the profile being viewed.
  Future<void> withdrawRequest() async {
    final p = viewed;
    final id = p?.outgoingRequestId;
    if (p == null || id == null) return;
    final ok = await _busy(() async {
      await api.connections.connectionRequestsCancel(id: id);
      return true;
    });
    if (ok == null) return;
    toast('Request to ${p.displayName} withdrawn');
    await openPlayer(p.username);
  }

  /// Ends a connection: gaming IDs lock again, both ways.
  Future<void> removeConnection(String userId, String name) async {
    final ok = await _busy(
      () async => api.connections.connectionsRemove(userId: userId),
    );
    if (ok == null) return;
    toast('You’re no longer connected with $name');
    final p = viewed;
    if (p != null && p.id == userId) await openPlayer(p.username);
  }

  Future<void> answerRequest(ConnectionRequestDto r, bool accept) async {
    final ok = await call(
      () async => accept
          ? (await api.connections.connectionRequestsAccept(id: r.id)).data
          : api.connections.connectionRequestsDecline(id: r.id),
    );
    if (ok == null) return;
    update(() => requests = requests.where((x) => x.id != r.id).toList());
    toast(accept ? 'Connected with ${r.from.displayName}' : 'Request hidden');
  }

  Future<void> loadMyProfile() async {
    await Future.wait([
      loadProfilePosts(),
      loadSaved(),
      loadMyGroups(),
      call(
        () async => (await api.me.meGet()).data!,
        quiet: true,
      ).then((m) => m == null ? null : update(() => me = m)),
      call(
        () async => (await api.connections.connectionsList()).data!,
        quiet: true,
      ).then(
        (c) => c == null
            ? null
            : update(() {
                connections = c.items.toList();
                connCursor = c.nextCursor;
              }),
      ),
    ]);
  }

  Future<void> loadMoreConnections() async {
    final c = await call(
      () async =>
          (await api.connections.connectionsList(cursor: connCursor)).data!,
    );
    if (c == null) return;
    update(() {
      connections = [...connections, ...c.items];
      connCursor = c.nextCursor;
    });
  }

  void openSessionSheet() {
    final p = viewed;
    if (p == null) return;
    final theirs = [for (final g in p.games) g.game?.id].whereType<String>();
    update(() {
      sess = SessionDraft()
        ..gameId = theirs.isNotEmpty
            ? theirs.first
            : (catalog.launch.firstOrNull?.id ?? '');
      sheet = SheetKind.session;
    });
  }

  Future<void> submitSession() async {
    final p = viewed;
    if (p == null || sess.gameId.isEmpty) return;
    final i = await _busy(
      () async => (await api.play.playInvitesSend(
        idempotencyKey: sess.key,
        sendInviteBody: SendInviteBody(
          (b) => b
            ..toUserId = p.id
            ..gameId = sess.gameId
            ..playWhen = sess.when,
        ),
      )).data!,
    );
    if (i == null) return;
    update(() => sheet = null);
    toast('Invite sent — ${p.displayName} gets a notification');
  }

  Future<void> block(String userId, String name) async {
    final ok = await _busy(
      () async => api.safety.safetyBlock(
        blockBody: BlockBody((b) => b..userId = userId),
      ),
    );
    if (ok == null) return;
    toast('$name is blocked. You won’t see each other.');
    if (screen == Screen.profile) back();
    loadFeed();
  }

  Future<void> report(
    String userId,
    ReportReason reason, {
    String? listingId,
    String? postId,
    String? commentId,
    String? groupId,
    String? details,
  }) async {
    final ok = await _busy(
      () async => api.safety.safetyReport(
        idempotencyKey: uuid4(),
        reportBody: ReportBody(
          (b) => b
            ..userId = userId
            ..listingId = listingId
            ..postId = postId
            ..commentId = commentId
            ..groupId = groupId
            ..reason = reason
            ..details = (details?.trim().isEmpty ?? true)
                ? null
                : details!.trim(),
        ),
      ),
    );
    if (ok != null) toast('Thanks. Our team will look at it.');
  }

  Future<void> loadBlocked() async {
    final b = await call(
      () async => (await api.safety.safetyBlocked()).data!.items.toList(),
    );
    if (b != null) update(() => blocked = b);
  }

  Future<void> unblock(UserCardDto u) async {
    final ok = await call(() async => api.safety.safetyUnblock(userId: u.id));
    if (ok == null) return;
    update(() => blocked = blocked.where((x) => x.id != u.id).toList());
    toast('${u.displayName} unblocked');
  }

  // ---- alerts ----

  Future<void> loadAlerts() async {
    final results = await Future.wait([
      call(
        () async => (await api.connections.connectionRequestsList(
          direction: 'incoming',
        )).data!.items.toList(),
        quiet: true,
      ),
      call(
        () async => (await api.notifications.notificationsList()).data!,
        quiet: true,
      ),
      call(
        () async =>
            (await api.play.playInvitesList(direction: 'incoming')).data!.items
                .toList(),
        quiet: true,
      ),
    ]);
    final page = results[1] as NotificationPageDto?;
    update(() {
      requests = results[0] as List<ConnectionRequestDto>? ?? requests;
      if (page != null) {
        notifications = page.items.toList();
        notifCursor = page.nextCursor;
      }
      invites = results[2] as List<PlayInviteDto>? ?? invites;
    });
    if (notifications.any((n) => n.readAt == null)) {
      final ok = await call(
        () async => api.notifications.notificationsMarkRead(
          markReadBody: MarkReadBody((b) => b..all = true),
        ),
        quiet: true,
      );
      if (ok != null) update(() => unread = 0);
    }
  }

  Future<void> loadMoreNotifications() async {
    final p = await call(
      () async =>
          (await api.notifications.notificationsList(cursor: notifCursor))
              .data!,
    );
    if (p == null) return;
    update(() {
      notifications = [...notifications, ...p.items];
      notifCursor = p.nextCursor;
    });
  }

  /// Follows a notification's `route` (docs/API.md "Push").
  void openRoute(String route) {
    // Routes can carry a query ("/posts/<id>?comments=1").
    final uri = Uri.parse(route);
    final parts = uri.pathSegments.where((p) => p.isNotEmpty).toList();
    switch (parts) {
      case ['players', final username]:
        openPlayer(username);
      case ['listings', final id]:
        openListing(id);
      case ['posts', final id]:
        openPost(id, comments: uri.queryParameters['comments'] == '1');
      case ['posts', final id, 'applications']:
        openPost(id).then((_) {
          if (screen == Screen.home && _post(id) != null) openApplications(id);
        });
      case ['groups', final id, 'members']:
        openGroup(id, tab: 'Members');
      case ['groups', final id]:
        openGroup(id);
      case ['check-ins', _]:
        go(Screen.home);
      default:
        go(Screen.notifs);
    }
  }

  /// Checks a username while it's typed (debounced). [mine] is the one I
  /// already have, which is fine to keep.
  void checkUsername(String v, {String? mine}) {
    _handleDebounce?.cancel();
    final name = v.trim().toLowerCase();
    if (name.isEmpty || name == mine) return update(() => handleNote = null);
    _handleDebounce = Timer(const Duration(milliseconds: 400), () async {
      final r = await call(
        () async => (await api.me.usernamesCheck(name: name)).data!,
        quiet: true,
      );
      if (r == null) return;
      update(
        () => handleNote = r.available
            ? null
            : r.reason == UsernameAvailabilityReasonEnum.invalid
            ? '3–20 characters: lowercase letters, numbers, dots and underscores'
            : '@$name is taken',
      );
    });
  }

  // ---- search ----

  void setQuery(String v) {
    update(() => q = v);
    _searchDebounce?.cancel();
    final query = v.trim();
    if (query.length < 2) return update(() => found = []);
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final r = await call(
        () async =>
            (await api.users.usersSearch(query: query)).data!.items.toList(),
        quiet: true,
      );
      if (r != null && q.trim() == query) update(() => found = r);
    });
  }

  // ---- home feed ----

  Future<void> loadPosts({bool more = false}) async {
    if (me?.onboardedAt == null) return;
    final tab = feedTab;
    final filter = switch (tab) {
      'for_you' => FeedFilter.forYou,
      'connections' => FeedFilter.connections,
      'lfg' => FeedFilter.lfg,
      _ => FeedFilter.game,
    };
    final p = await call(
      () async => (await api.feed.feedGet(
        filter: filter,
        game: filter == FeedFilter.game ? tab : null,
        cursor: more ? postsCursor : null,
      )).data!,
      quiet: more,
    );
    if (p == null || tab != feedTab) return;
    update(() {
      posts = more ? [...posts, ...p.items] : p.items.toList();
      postsCursor = p.nextCursor;
      postsLoaded = true;
    });
  }

  void setFeedTab(String id) {
    update(() {
      feedTab = id;
      filterOpen = false;
      posts = [];
      postsCursor = null;
    });
    loadPosts();
  }

  /// Replaces a post wherever it shows (feed and profile).
  void _putPost(PostDto p) => update(() {
    posts = [for (final x in posts) x.id == p.id ? p : x];
    profilePosts = [for (final x in profilePosts) x.id == p.id ? p : x];
    if (groupPosts != null) {
      groupPosts = [for (final x in groupPosts!) x.id == p.id ? p : x];
    }
    if (saved != null) saved = [for (final x in saved!) x.id == p.id ? p : x];
  });

  PostDto? _post(String id) =>
      posts.where((p) => p.id == id).firstOrNull ??
      profilePosts.where((p) => p.id == id).firstOrNull ??
      groupPosts?.where((p) => p.id == id).firstOrNull ??
      saved?.where((p) => p.id == id).firstOrNull;

  /// Reloads one post after a refused action (closed poll, full slots…).
  Future<void> refreshPost(String id) async {
    final p = await call(
      () async => (await api.feed.postsGet(id: id)).data!,
      quiet: true,
    );
    if (p != null) _putPost(p);
  }

  Future<void> toggleGG(PostDto p) async {
    final on = !p.myGG;
    // Show it at once; the API's count replaces the guess.
    _putPost(
      p.rebuild(
        (b) => b
          ..myGG = on
          ..ggCount = p.ggCount + (on ? 1 : -1),
      ),
    );
    final r = await call(
      () async =>
          (on
                  ? await api.feed.postsGg(id: p.id)
                  : await api.feed.postsUnGg(id: p.id))
              .data!,
    );
    final now = _post(p.id);
    if (now == null) return;
    _putPost(
      r == null
          ? now.rebuild(
              (b) => b
                ..myGG = p.myGG
                ..ggCount = p.ggCount,
            )
          : now.rebuild(
              (b) => b
                ..myGG = r.myGG
                ..ggCount = r.ggCount,
            ),
    );
  }

  Future<void> toggleSave(PostDto p) async {
    final on = !p.saved;
    _putPost(p.rebuild((b) => b..saved = on));
    final ok = await call(
      () async =>
          on ? api.feed.postsSave(id: p.id) : api.feed.postsUnsave(id: p.id),
    );
    final now = _post(p.id);
    if (ok == null) {
      if (now != null) _putPost(now.rebuild((b) => b..saved = p.saved));
      return;
    }
    if (on) {
      toast('Saved to your bookmarks');
    } else if (saved != null) {
      update(() => saved = saved!.where((x) => x.id != p.id).toList());
    }
  }

  Future<void> loadSaved({bool more = false}) async {
    final p = await call(
      () async =>
          (await api.feed.myPostsSaved(cursor: more ? savedCursor : null))
              .data!,
      quiet: !more,
    );
    if (p == null) return;
    update(() {
      saved = more ? [...?saved, ...p.items] : p.items.toList();
      savedCursor = p.nextCursor;
    });
  }

  // ---- polls & recruitment ----

  /// One final vote; the API's totals replace the card's.
  Future<void> vote(PostDto p, int position) async {
    final poll = p.poll;
    if (poll == null || poll.closed || poll.myVote != null || busy) return;
    final r = await _busy(
      () async => (await api.feed.postsVote(
        id: p.id,
        voteBody: VoteBody((b) => b..position = position),
      )).data!,
    );
    if (r == null) return refreshPost(p.id);
    final now = _post(p.id) ?? p;
    _putPost(now.rebuild((b) => b..poll.replace(r)));
  }

  /// Apply to someone's recruitment post; my own opens its applications.
  Future<void> apply(PostDto p) async {
    final rec = p.recruit;
    if (rec == null) return;
    if (p.mine) return openApplications(p.id);
    if (rec.myApplication != null || busy) return;
    final r = await _busy(
      () async =>
          (await api.feed.postsApply(id: p.id, idempotencyKey: uuid4())).data!,
    );
    if (r == null) return refreshPost(p.id);
    final now = _post(p.id) ?? p;
    _putPost(now.rebuild((b) => b..recruit.replace(r)));
    toast('Applied — ${p.author.displayName} gets a notification');
  }

  /// The recruitment on the post whose applications are open.
  RecruitDto? get appsRecruit =>
      appsPost == null ? null : _post(appsPost!)?.recruit;

  void openApplications(String postId) {
    update(() {
      appsPost = postId;
      apps = null;
      appsCursor = null;
      sheet = SheetKind.applications;
    });
    loadApplications();
  }

  Future<void> loadApplications({bool more = false}) async {
    final id = appsPost;
    if (id == null) return;
    final p = await call(
      () async => (await api.feed.postsApplications(
        id: id,
        cursor: more ? appsCursor : null,
      )).data!,
    );
    if (p == null || appsPost != id) return;
    update(() {
      apps = more ? [...?apps, ...p.items] : p.items.toList();
      appsCursor = p.nextCursor;
    });
  }

  /// Accept or decline an application (the author may change the answer).
  Future<void> decide(RecruitApplicationDto a, bool accept) async {
    final r = await _busy(
      () async =>
          (accept
                  ? await api.feed.recruitApplicationsAccept(id: a.id)
                  : await api.feed.recruitApplicationsDecline(id: a.id))
              .data!,
    );
    final id = appsPost;
    if (r == null) {
      if (id != null) refreshPost(id);
      return;
    }
    update(() {
      apps = [
        for (final x in apps ?? const <RecruitApplicationDto>[])
          x.id == r.id ? x.rebuild((b) => b..status = r.status) : x,
      ];
    });
    toast(
      accept
          ? 'Accepted — ${a.user.displayName} can see your gamer ID'
          : 'Declined',
    );
  }

  Future<void> sharePost(PostDto p) async {
    await Clipboard.setData(ClipboardData(text: p.shareUrl));
    toast('Link copied — paste it in Telegram or WhatsApp');
  }

  Future<void> deletePost(PostDto p) async {
    final ok = await _busy(() async => api.feed.postsDelete(id: p.id));
    if (ok == null) return;
    update(() {
      posts = posts.where((x) => x.id != p.id).toList();
      profilePosts = profilePosts.where((x) => x.id != p.id).toList();
      groupPosts = groupPosts?.where((x) => x.id != p.id).toList();
    });
    toast('Post deleted');
  }

  /// "Play" on a post: Find Players for its game, else the poster.
  void playFrom(PostDto p) {
    final g = p.game;
    if (g != null && catalog.byId(g.id).isLaunch) {
      go(Screen.find);
      return setGameFilter(g.id);
    }
    openPlayer(p.author.username);
  }

  /// A post from a link or an alert: put it on top of Home, comments open.
  Future<void> openPost(String id, {bool comments = false}) async {
    final p = await call(() async => (await api.feed.postsGet(id: id)).data!);
    if (p == null) return go(Screen.home);
    go(Screen.home, () {
      posts = [p, ...posts.where((x) => x.id != p.id)];
    });
    if (comments && !openC.contains(id)) toggleComments(id);
  }

  void toggleComments(String postId) {
    final open = !openC.contains(postId);
    update(() => open ? openC.add(postId) : openC.remove(postId));
    if (open) loadComments(postId);
  }

  Future<void> loadComments(String postId) async {
    final p = _post(postId);
    final r = await call(
      () async => (await api.feed.commentsList(
        id: postId,
        sort: p?.kind == PostKind.discussion ? CommentSort.top : null,
        limit: 50,
      )).data!,
      quiet: true,
    );
    if (r != null) update(() => comments[postId] = r.items.toList());
  }

  Future<void> loadReplies(CommentDto c) async {
    final r = await call(
      () async => (await api.feed.commentsReplies(id: c.id, limit: 50)).data!,
    );
    if (r != null) update(() => replies[c.id] = r.items.toList());
  }

  void replyToComment(String postId, CommentDto c) => update(() {
    replyTo[postId] = c;
    cDraft[postId] = '@${c.author.username} ';
  });

  Future<void> sendComment(String postId) async {
    final text = (cDraft[postId] ?? '').trim();
    if (text.isEmpty) return;
    final parent = replyTo[postId];
    final c = await _busy(
      () async => (await api.feed.commentsCreate(
        id: postId,
        idempotencyKey: uuid4(),
        createCommentBody: CreateCommentBody(
          (b) => b
            ..text = text
            ..parentId = parent?.parentId ?? parent?.id,
        ),
      )).data!,
    );
    if (c == null) return;
    final top = c.parentId;
    update(() {
      cDraft[postId] = '';
      replyTo.remove(postId);
      if (top == null) {
        comments[postId] = [...?comments[postId], c];
      } else {
        replies[top] = [...?replies[top], c];
        comments[postId] = [
          for (final x in comments[postId] ?? const <CommentDto>[])
            x.id == top ? x.rebuild((b) => b..replies = x.replies + 1) : x,
        ];
      }
    });
    final p = _post(postId);
    if (p != null) {
      _putPost(p.rebuild((b) => b..commentCount = p.commentCount + 1));
    }
  }

  void _putComment(CommentDto c) => update(() {
    for (final m in [comments, replies]) {
      for (final k in m.keys) {
        m[k] = [for (final x in m[k]!) x.id == c.id ? c : x];
      }
    }
  });

  Future<void> toggleCommentGG(CommentDto c) async {
    final on = !c.myGG;
    _putComment(
      c.rebuild(
        (b) => b
          ..myGG = on
          ..ggCount = c.ggCount + (on ? 1 : -1),
      ),
    );
    final r = await call(
      () async =>
          (on
                  ? await api.feed.commentsGg(id: c.id)
                  : await api.feed.commentsUnGg(id: c.id))
              .data!,
    );
    _putComment(
      r == null
          ? c
          : c.rebuild(
              (b) => b
                ..myGG = r.myGG
                ..ggCount = r.ggCount,
            ),
    );
  }

  Future<void> deleteComment(CommentDto c) async {
    final ok = await _busy(() async => api.feed.commentsDelete(id: c.id));
    if (ok == null) return;
    update(() {
      for (final m in [comments, replies]) {
        for (final k in m.keys) {
          m[k] = m[k]!.where((x) => x.id != c.id).toList();
        }
      }
    });
    toast('Comment deleted');
    loadComments(c.postId);
    final p = _post(c.postId);
    if (p != null) {
      final n = p.commentCount - 1 - (c.parentId == null ? c.replies : 0);
      _putPost(p.rebuild((b) => b..commentCount = n < 0 ? 0 : n));
    }
  }

  /// The profile's posts: mine (connections-only too) or theirs.
  Future<void> loadProfilePosts({bool more = false}) async {
    final who = viewing;
    final p = await call(
      () async =>
          (who == null
                  ? await api.feed.myPostsList(
                      cursor: more ? profilePostsCursor : null,
                    )
                  : await api.feed.userPostsList(
                      username: who,
                      cursor: more ? profilePostsCursor : null,
                    ))
              .data!,
      quiet: true,
    );
    if (p == null || viewing != who) return;
    update(() {
      profilePosts = more ? [...profilePosts, ...p.items] : p.items.toList();
      profilePostsCursor = p.nextCursor;
    });
  }

  // ---- compose ----

  void openCompose() => update(() {
    screen = Screen.compose;
    sheet = null;
    filterOpen = false;
    if (!cp.gameSet) cp.gameId = me?.games.firstOrNull?.game?.id;
  });

  /// Picks photos from the gallery, resized to a longest side of 1600 px.
  Future<void> pickPhotos() async {
    if (cp.photos.length >= maxPhotos) {
      return toast('Up to $maxPhotos photos per post');
    }
    List<XFile> picked;
    try {
      picked = await ImagePicker().pickMultiImage(
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
    } on PlatformException {
      return toast('Couldn’t open your gallery');
    }
    final photos = <PickedPhoto>[];
    for (final x in picked) {
      final name = x.name.toLowerCase();
      final type = switch (x.mimeType) {
        'image/png' => MediaContentType.imageSlashPng,
        'image/webp' => MediaContentType.imageSlashWebp,
        _ when name.endsWith('.png') => MediaContentType.imageSlashPng,
        _ when name.endsWith('.webp') => MediaContentType.imageSlashWebp,
        _ => MediaContentType.imageSlashJpeg,
      };
      photos.add(PickedPhoto(await x.readAsBytes(), type));
    }
    addPhotos(photos);
  }

  /// Adds picked photos to the draft, keeping the first [maxPhotos].
  void addPhotos(List<PickedPhoto> photos) {
    final room = maxPhotos - cp.photos.length;
    if (photos.length > room) toast('Up to $maxPhotos photos per post');
    if (room <= 0) return;
    update(() => cp.photos = [...cp.photos, ...photos.take(room)]);
  }

  void removePhoto(int i) =>
      update(() => cp.photos = [...cp.photos]..removeAt(i));

  /// Uploads the photos (signed URLs, docs/API.md "Images"), then creates
  /// the post. On any failure the draft stays as it was.
  Future<void> submitPost() async {
    final c = cp;
    final missing = c.missing;
    if (missing != null) return toast(missing);
    final p = await _busy(() async {
      final keys = <String>[];
      for (final ph in c.photos) {
        final u = (await api.feed.mediaUploadUrl(
          mediaUploadBody: MediaUploadBody(
            (b) => b
              ..contentType = ph.type
              ..size = ph.bytes.length,
          ),
        )).data!;
        try {
          await api.upload(u.uploadUrl, u.headers.toMap(), ph.bytes);
        } catch (_) {
          throw const ApiError(
            0,
            'upload_failed',
            'A photo didn\'t upload. Check your connection and try again.',
          );
        }
        keys.add(u.key);
      }
      return (await api.feed.postsCreate(
        idempotencyKey: c.key,
        createPostBody: CreatePostBody((b) {
          b
            ..type = c.type
            ..text = c.text.trim()
            ..gameId = c.gameId
            ..audience = c.audience;
          if (keys.isNotEmpty) b.media = SetBuilder(keys);
          if (c.type == PostType.poll) {
            b.poll = PollBodyBuilder()
              ..options = SetBuilder(c.pollOptions)
              ..duration = c.pollDur;
          }
          if (c.type == PostType.recruitment) {
            b.recruit = RecruitBodyBuilder()
              ..slots = c.slots
              ..roles = c.roles.trim().isEmpty ? null : c.roles.trim();
          }
        }),
      )).data!;
    });
    if (p == null) return;
    final label = postTypeInfo(c.type).label;
    update(() {
      posts = [p, ...posts];
      cp = ComposeDraft(gameId: me?.games.firstOrNull?.game?.id);
    });
    go(Screen.home);
    toast('$label posted');
  }

  // ---- groups ----

  GroupKind? get _kindFilter => groupKindLabel.entries
      .where((e) => e.value == groupKind)
      .firstOrNull
      ?.key;

  /// The Groups tab's list for [groupsTab], [groupKind] and [groupQuery].
  Future<void> loadGroups({bool more = false}) async {
    final q = groupQuery.trim();
    final key = '$groupsTab|$groupKind|$q';
    final p = await call(
      () async => (await api.groups.groupsList(
        tab: groupsTab == 'Yours' ? GroupTab.mine : GroupTab.discover,
        kind: _kindFilter,
        // The API takes 2–40 characters.
        query: q.length >= 2 ? q : null,
        cursor: more ? groupsCursor : null,
      )).data!,
      quiet: !more,
    );
    if (p == null || key != '$groupsTab|$groupKind|${groupQuery.trim()}') {
      return;
    }
    update(() {
      groups = more ? [...groups, ...p.items] : p.items.toList();
      groupsCursor = p.nextCursor;
      groupsLoaded = true;
    });
  }

  void setGroupsFilter(VoidCallback fn) {
    update(() {
      fn();
      groups = [];
      groupsCursor = null;
      groupsLoaded = false;
    });
    loadGroups();
  }

  /// Search as you type: waits for a pause, and for 2+ characters.
  void setGroupQuery(String v) {
    final before = groupQuery.trim();
    update(() => groupQuery = v);
    _groupSearch?.cancel();
    final q = v.trim();
    if (q.length < 2 && before.length < 2) return;
    _groupSearch = Timer(
      const Duration(milliseconds: 350),
      () => setGroupsFilter(() {}),
    );
  }

  Future<void> loadMyGroups() async {
    final p = await call(
      () async => (await api.groups.myGroupsList(limit: 50)).data!,
      quiet: true,
    );
    if (p != null) update(() => myGroups = p.items.toList());
  }

  Future<void> loadTheirGroups(String username) async {
    update(() => theirGroups = []);
    final p = await call(
      () async => (await api.groups.userGroupsList(
        username: username,
        limit: 50,
      )).data!,
      quiet: true,
    );
    if (p != null && viewing == username) {
      update(() => theirGroups = p.items.toList());
    }
  }

  /// Puts a fresh copy of [g] everywhere it shows.
  void _putGroup(GroupDto g) => update(() {
    groups = [for (final x in groups) x.id == g.id ? g : x];
    final mine = g.myStatus != null;
    myGroups = [
      if (mine && !myGroups.any((x) => x.id == g.id)) g,
      for (final x in myGroups)
        if (x.id != g.id) x else if (mine) g,
    ];
    if (groupId == g.id) group = g;
  });

  void openGroup(String id, {String tab = 'Feed'}) {
    update(() {
      if (screen != Screen.group) groupPrev = screen;
      screen = Screen.group;
      if (groupId != id) {
        group =
            groups.where((g) => g.id == id).firstOrNull ??
            myGroups.where((g) => g.id == id).firstOrNull;
      }
      groupId = id;
      groupTab = tab;
      groupDraftPost = '';
      groupPosts = null;
      members = null;
      joinRequests = null;
      events = null;
      sheet = null;
    });
    _loadGroupPage(id);
  }

  Future<void> _loadGroupPage(String id) async {
    final g = await call(
      () async => (await api.groups.groupsGet(id: id)).data!,
    );
    if (groupId != id) return;
    if (g == null) return closeGroup();
    update(() => group = g);
    _putGroup(g);
    await Future.wait([
      loadGroupPosts(),
      loadMembers(),
      loadEvents(),
      if (g.myRole == GroupRole.admin) loadRequests(),
    ]);
  }

  void setGroupTab(String tab) {
    update(() => groupTab = tab);
    final g = group;
    if (tab == 'Members' && g?.myRole == GroupRole.admin) loadRequests();
  }

  void closeGroup() =>
      go(groupPrev == Screen.group ? Screen.communities : groupPrev);

  Future<void> loadGroupPosts({bool more = false}) async {
    final id = groupId;
    if (id == null || group?.myStatus != MembershipStatus.member) {
      return update(() => groupPosts = []);
    }
    final p = await call(
      () async => (await api.groups.groupsPosts(
        id: id,
        cursor: more ? groupPostsCursor : null,
      )).data!,
      quiet: true,
    );
    if (p == null || groupId != id) return;
    update(() {
      groupPosts = more ? [...?groupPosts, ...p.items] : p.items.toList();
      groupPostsCursor = p.nextCursor;
    });
  }

  Future<void> loadMembers({bool more = false}) async {
    final id = groupId;
    if (id == null) return;
    final p = await call(
      () async => (await api.groups.groupsMembers(
        id: id,
        limit: 50,
        cursor: more ? membersCursor : null,
      )).data!,
      quiet: true,
    );
    if (p == null || groupId != id) return;
    update(() {
      members = more ? [...?members, ...p.items] : p.items.toList();
      membersCursor = p.nextCursor;
    });
  }

  /// Pending join requests (admins only).
  Future<void> loadRequests() async {
    final id = groupId;
    if (id == null) return;
    final p = await call(
      () async => (await api.groups.groupsMembers(
        id: id,
        limit: 50,
        status: MembershipStatus.pending,
      )).data!,
      quiet: true,
    );
    if (p != null && groupId == id) {
      update(() => joinRequests = p.items.toList());
    }
  }

  Future<void> loadEvents({bool more = false}) async {
    final id = groupId;
    if (id == null) return;
    final p = await call(
      () async => (await api.groups.groupsEvents(
        id: id,
        cursor: more ? eventsCursor : null,
      )).data!,
      quiet: true,
    );
    if (p == null || groupId != id) return;
    update(() {
      events = more ? [...?events, ...p.items] : p.items.toList();
      eventsCursor = p.nextCursor;
    });
  }

  /// Join, or ask to join an approval group.
  Future<void> joinGroup(GroupDto g) async {
    if (g.myStatus != null) return;
    final r = await _busy(
      () async => (await api.groups.groupsJoin(id: g.id)).data!,
    );
    if (r == null) return;
    _putGroup(r);
    if (r.myStatus == MembershipStatus.member) {
      toast('You joined ${r.name}');
      if (groupId == r.id) _loadGroupPage(r.id);
    } else {
      toast('Request sent to ${r.name} admins');
    }
  }

  /// Leave, or take back a pending request.
  Future<void> leaveGroup(GroupDto g) async {
    final pending = g.myStatus == MembershipStatus.pending;
    final ok = await _busy(() async => api.groups.groupsLeave(id: g.id));
    if (ok == null) return;
    toast(pending ? 'Request to ${g.name} cancelled' : 'You left ${g.name}');
    final fresh = await call(
      () async => (await api.groups.groupsGet(id: g.id)).data!,
      quiet: true,
    );
    if (fresh != null) {
      _putGroup(fresh);
    } else {
      // The last member left: the group is archived.
      update(() {
        groups = groups.where((x) => x.id != g.id).toList();
        myGroups = myGroups.where((x) => x.id != g.id).toList();
      });
      if (screen == Screen.group && groupId == g.id) return closeGroup();
    }
    if (screen == Screen.group && groupId == g.id) {
      update(() => groupPosts = []);
      loadMembers();
    }
  }

  /// A text post in the open group (members only).
  Future<void> postInGroup() async {
    final g = group;
    final text = groupDraftPost.trim();
    if (g == null || text.isEmpty) return;
    final p = await _busy(
      () async => (await api.feed.postsCreate(
        idempotencyKey: uuid4(),
        createPostBody: CreatePostBody(
          (b) => b
            ..type = PostType.discussion
            ..text = text
            ..groupId = g.id
            ..audience = PostAudience.everyone,
        ),
      )).data!,
    );
    if (p == null) return;
    update(() {
      groupPosts = [p, ...?groupPosts];
      groupDraftPost = '';
    });
  }

  Future<void> approveRequest(GroupMemberDto m, bool approve) async {
    final id = groupId;
    if (id == null) return;
    final ok = await _busy(
      () async => approve
          ? api.groups.groupsApprove(id: id, userId: m.user.id)
          : api.groups.groupsDecline(id: id, userId: m.user.id),
    );
    if (ok == null) return;
    update(
      () => joinRequests = joinRequests
          ?.where((x) => x.user.id != m.user.id)
          .toList(),
    );
    toast(
      approve
          ? '${m.user.displayName} is in'
          : 'Request from ${m.user.displayName} declined',
    );
    if (approve) {
      loadMembers();
      _refreshGroup();
    }
  }

  Future<void> setMemberRole(GroupMemberDto m, GroupRole role) async {
    final id = groupId;
    if (id == null) return;
    final ok = await _busy(
      () async => api.groups.groupsSetRole(
        id: id,
        userId: m.user.id,
        setGroupRoleBody: SetGroupRoleBody((b) => b..role = role),
      ),
    );
    if (ok == null) return;
    toast(
      role == GroupRole.admin
          ? '${m.user.displayName} is an admin now'
          : '${m.user.displayName} is a member now',
    );
    loadMembers();
    if (m.user.id == me?.id) _refreshGroup();
  }

  Future<void> removeMember(GroupMemberDto m) async {
    final id = groupId;
    if (id == null) return;
    final ok = await _busy(
      () async => api.groups.groupsRemoveMember(id: id, userId: m.user.id),
    );
    if (ok == null) return;
    update(
      () => members = members?.where((x) => x.user.id != m.user.id).toList(),
    );
    toast('${m.user.displayName} removed from the group');
    _refreshGroup();
  }

  Future<void> _refreshGroup() async {
    final id = groupId;
    if (id == null) return;
    final g = await call(
      () async => (await api.groups.groupsGet(id: id)).data!,
      quiet: true,
    );
    if (g != null) _putGroup(g);
  }

  /// A new event: any member, within the next 60 days.
  Future<bool> addGroupEvent(
    String title,
    DateTime startsAt,
    String? gameId,
  ) async {
    final g = group;
    if (g == null) return false;
    final e = await _busy(
      () async => (await api.groups.groupsCreateEvent(
        id: g.id,
        idempotencyKey: uuid4(),
        createGroupEventBody: CreateGroupEventBody(
          (b) => b
            ..title = title
            ..startsAt = startsAt.toUtc()
            ..gameId = gameId,
        ),
      )).data!,
    );
    if (e == null) return false;
    update(() {
      events = [...?events, e]
        ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    });
    toast('Event added — members get a notification');
    _refreshGroup();
    return true;
  }

  void _putEvent(GroupEventDto e) => update(
    () => events = [for (final x in events ?? const []) x.id == e.id ? e : x],
  );

  Future<void> toggleGoing(GroupEventDto e) async {
    final r = await call(
      () async =>
          (e.imGoing
                  ? await api.groups.groupEventsNotGoing(id: e.id)
                  : await api.groups.groupEventsGoing(id: e.id))
              .data!,
    );
    if (r != null) _putEvent(r);
  }

  Future<void> deleteGroupEvent(GroupEventDto e) async {
    final ok = await _busy(() async => api.groups.groupEventsDelete(id: e.id));
    if (ok == null) return;
    update(() => events = events?.where((x) => x.id != e.id).toList());
    toast('Event deleted');
    _refreshGroup();
  }

  /// Copies the group's web link (the PWA's `/app/groups/<id>`).
  Future<void> shareGroup(GroupDto g) async {
    await Clipboard.setData(ClipboardData(text: g.shareUrl));
    toast('Link copied — paste it in Telegram or WhatsApp');
  }

  void openCreateGroup() => go(Screen.createGroup, () {
    groupKey = uuid4();
    newGroup = GroupDraft()
      ..gameId = me?.games.firstOrNull?.game?.id
      ..place = me?.city ?? 'Addis Ababa';
  });

  void openEditGroup() {
    final g = group;
    if (g == null) return;
    go(Screen.createGroup, () => newGroup = GroupDraft.of(g));
  }

  /// Leaves the create / edit form without saving.
  void closeGroupForm() {
    final editing = newGroup?.editId != null;
    update(() => newGroup = null);
    editing ? update(() => screen = Screen.group) : go(Screen.communities);
  }

  /// Creates the group (or saves the edit), then opens its About tab.
  Future<void> createGroup() async {
    final d = newGroup;
    if (d == null) return;
    final name = d.name.trim();
    if (name.length < 3) {
      return toast('Give your group a name (3+ characters)');
    }
    if (d.kind == GroupKind.game && d.gameId == null) {
      return toast('Pick the game this group is for');
    }
    if (d.place.trim().isEmpty) return toast('Add a city, campus or country');
    update(() => d.nameError = null);
    final about = d.about.trim();
    final g = await _busy(
      () async => d.editId == null
          ? (await api.groups.groupsCreate(
              idempotencyKey: groupKey,
              createGroupBody: CreateGroupBody(
                (b) => b
                  ..name = name
                  ..kind = d.kind
                  ..gameId = d.kind == GroupKind.game ? d.gameId : null
                  ..place = d.place.trim()
                  ..about = about.isEmpty ? null : about
                  ..rules = ListBuilder(d.cleanRules)
                  ..approval = d.approval
                  ..tone = d.tone,
              ),
            )).data!
          : (await api.groups.groupsUpdate(
              id: d.editId!,
              updateGroupBody: UpdateGroupBody(
                (b) => b
                  ..name = name
                  ..place = d.place.trim()
                  ..about = about
                  ..rules = ListBuilder(d.cleanRules)
                  ..approval = d.approval
                  ..tone = d.tone,
              ),
            )).data!,
    );
    if (g == null) {
      if (lastError?.code == 'group_name_taken') {
        update(() => d.nameError = lastError!.message);
      }
      return;
    }
    final editing = d.editId != null;
    update(() {
      newGroup = null;
      if (!editing) {
        groups = [g, ...groups];
        groupsTab = 'Yours';
        groupPrev = Screen.communities;
      }
      myGroups = [g, ...myGroups.where((x) => x.id != g.id)];
      groupId = g.id;
      group = g;
      groupTab = 'About';
      screen = Screen.group;
    });
    toast(editing ? 'Group updated' : '${g.name} is live — invite your squad');
    if (!editing) {
      update(() {
        groupPosts = [];
        members = null;
        events = [];
        joinRequests = [];
      });
      loadMembers();
    }
  }

  /// A group's badge text as the API makes it: the game's short code, or
  /// initials of up to 4 words, or the first 4 letters.
  String groupShort(GroupDraft d) {
    final name = d.name.trim();
    if (d.kind == GroupKind.game && d.gameId != null) {
      return catalog.byId(d.gameId!).short;
    }
    if (name.isEmpty) return '?';
    final words = name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return (words.length > 1
            ? words.take(4).map((w) => w[0]).join()
            : name.substring(0, name.length < 4 ? name.length : 4))
        .toUpperCase();
  }

  // ---- edit profile ----

  void openEditProfile() {
    final m = me;
    if (m == null) return;
    go(Screen.editProfile, () {
      edit = ProfileDraft.from(m, catalog);
      confirmDiscard = false;
      handleNote = null;
    });
  }

  Future<void> saveProfile() async {
    final d = edit;
    final m0 = me;
    if (d == null || m0 == null) return;
    if (d.name.trim().isEmpty || d.handle.trim().isEmpty) {
      return toast('Name and username can’t be empty');
    }
    if (d.games.isEmpty) return toast('Keep at least one game');
    final m = await _busy(() async {
      final patch = UpdateMeBody((b) {
        if (d.name.trim() != m0.displayName) b.displayName = d.name.trim();
        if (d.handle.trim().toLowerCase() != m0.username) {
          b.username = d.handle.trim().toLowerCase();
        }
        if (d.bio.trim() != (m0.bio ?? '')) b.bio = d.bio.trim();
        if (d.city.trim().isNotEmpty && d.city.trim() != m0.city) {
          b.city = d.city.trim();
        }
        if (d.age != m0.ageRange) b.ageRange = d.age;
      });
      await api.me.meUpdate(updateMeBody: patch);
      await _saveGamer(d);
      return (await api.me.meGet()).data!;
    });
    if (m == null) return;
    update(() {
      me = m;
      edit = null;
      viewing = null;
    });
    go(Screen.profile);
    toast('Profile updated');
  }

  /// Leave the form; asks first when there are unsaved changes.
  void closeEditProfile({bool force = false}) {
    final d = edit;
    final m = me;
    if (!force && d != null && m != null && d.differs(m)) {
      return update(() => confirmDiscard = true);
    }
    go(Screen.profile, () {
      edit = null;
      confirmDiscard = false;
      viewing = null;
    });
  }

  /// Picks a photo, resizes it on the phone and uploads it (docs/API.md "Images").
  Future<void> changeAvatar() async {
    XFile? x;
    try {
      x = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
    } on PlatformException {
      return toast('Couldn’t open your gallery');
    }
    if (x == null) return;
    final bytes = await x.readAsBytes();
    final type =
        x.mimeType ??
        (x.name.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg');
    final m = await _busy(() async {
      final u = (await api.me.meAvatarUploadUrl(
        avatarUploadBody: AvatarUploadBody(
          (b) => b
            ..contentType = switch (type) {
              'image/png' => AvatarType.imageSlashPng,
              'image/webp' => AvatarType.imageSlashWebp,
              _ => AvatarType.imageSlashJpeg,
            }
            ..size = bytes.length,
        ),
      )).data!;
      await api.upload(u.uploadUrl, u.headers.toMap(), bytes);
      return (await api.me.meSetAvatar(
        setAvatarBody: SetAvatarBody((b) => b..key = u.key),
      )).data!;
    });
    if (m == null) return;
    update(() => me = m);
    toast('Photo updated');
  }

  Future<void> removeAvatar() async {
    final m = await _busy(() async => (await api.me.meRemoveAvatar()).data!);
    if (m == null) return;
    update(() => me = m);
    toast('Photo removed');
  }

  /// Settings → Change password. True when it worked.
  Future<bool> changePassword(String current, String next) async {
    if (next.length < 8) {
      toast('New password needs at least 8 characters');
      return false;
    }
    final ok = await _busy(
      () async => api.auth.authChangePassword(
        changePasswordBody: ChangePasswordBody(
          (b) => b
            ..currentPassword = current
            ..newPassword = next,
        ),
      ),
    );
    if (ok == null) return false;
    toast('Password changed');
    return true;
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
      case Screen.home || Screen.splash || Screen.update:
        return false;
      case Screen.login:
        go(Screen.landing);
      case Screen.signup || Screen.forgot:
        go(Screen.login);
      case Screen.verify:
        afterVerify();
      case Screen.games:
        return false;
      case Screen.ranks:
        go(Screen.games);
      case Screen.platforms:
        go(Screen.ranks);
      case Screen.editProfile:
        if (confirmDiscard) {
          update(() => confirmDiscard = false);
        } else {
          closeEditProfile();
        }
      case Screen.blocked:
        goProfileTab();
      case Screen.compose:
        go(Screen.home);
      case Screen.group:
        closeGroup();
      case Screen.createGroup:
        closeGroupForm();
      case Screen.listing:
        go(prev == Screen.listing ? Screen.home : prev);
      case Screen.search:
        leaveSearch();
      case Screen.profile when viewing != null:
        back();
      default:
        go(Screen.home);
    }
    return true;
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}

extension AppContext on BuildContext {
  AppState get app => AppScope.of(this);
}
