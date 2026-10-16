// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeDto extends MeDto {
  @override
  final PlayerStatus status;
  @override
  final AgeRange ageRange;
  @override
  final BuiltList<Day> availableDays;
  @override
  final BuiltList<Platform> platforms;
  @override
  final BuiltList<PlayTag> tags;
  @override
  final Relationship relationship;
  @override
  final UserRole role;
  @override
  final String email;
  @override
  final bool emailVerified;
  @override
  final bool hasPassword;
  @override
  final String country;
  @override
  final DateTime? onboardedAt;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<String> waitlist;
  @override
  final String? bio;
  @override
  final DateTime? statusUntil;
  @override
  final BuiltList<UserGameDto> games;
  @override
  final BuiltList<GamingIdDto> gamingIds;
  @override
  final ProfileStatsDto stats;
  @override
  final String? incomingRequestId;
  @override
  final String? outgoingRequestId;
  @override
  final String id;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  final String city;
  @override
  final GameRefDto? statusGame;
  @override
  final UserGameDto? topGame;

  factory _$MeDto([void Function(MeDtoBuilder)? updates]) =>
      (MeDtoBuilder()..update(updates))._build();

  _$MeDto._(
      {required this.status,
      required this.ageRange,
      required this.availableDays,
      required this.platforms,
      required this.tags,
      required this.relationship,
      required this.role,
      required this.email,
      required this.emailVerified,
      required this.hasPassword,
      required this.country,
      this.onboardedAt,
      required this.createdAt,
      required this.waitlist,
      this.bio,
      this.statusUntil,
      required this.games,
      required this.gamingIds,
      required this.stats,
      this.incomingRequestId,
      this.outgoingRequestId,
      required this.id,
      required this.username,
      required this.displayName,
      this.avatarUrl,
      required this.city,
      this.statusGame,
      this.topGame})
      : super._();
  @override
  MeDto rebuild(void Function(MeDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeDtoBuilder toBuilder() => MeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeDto &&
        status == other.status &&
        ageRange == other.ageRange &&
        availableDays == other.availableDays &&
        platforms == other.platforms &&
        tags == other.tags &&
        relationship == other.relationship &&
        role == other.role &&
        email == other.email &&
        emailVerified == other.emailVerified &&
        hasPassword == other.hasPassword &&
        country == other.country &&
        onboardedAt == other.onboardedAt &&
        createdAt == other.createdAt &&
        waitlist == other.waitlist &&
        bio == other.bio &&
        statusUntil == other.statusUntil &&
        games == other.games &&
        gamingIds == other.gamingIds &&
        stats == other.stats &&
        incomingRequestId == other.incomingRequestId &&
        outgoingRequestId == other.outgoingRequestId &&
        id == other.id &&
        username == other.username &&
        displayName == other.displayName &&
        avatarUrl == other.avatarUrl &&
        city == other.city &&
        statusGame == other.statusGame &&
        topGame == other.topGame;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, ageRange.hashCode);
    _$hash = $jc(_$hash, availableDays.hashCode);
    _$hash = $jc(_$hash, platforms.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, relationship.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, emailVerified.hashCode);
    _$hash = $jc(_$hash, hasPassword.hashCode);
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jc(_$hash, onboardedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, waitlist.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, statusUntil.hashCode);
    _$hash = $jc(_$hash, games.hashCode);
    _$hash = $jc(_$hash, gamingIds.hashCode);
    _$hash = $jc(_$hash, stats.hashCode);
    _$hash = $jc(_$hash, incomingRequestId.hashCode);
    _$hash = $jc(_$hash, outgoingRequestId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, statusGame.hashCode);
    _$hash = $jc(_$hash, topGame.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeDto')
          ..add('status', status)
          ..add('ageRange', ageRange)
          ..add('availableDays', availableDays)
          ..add('platforms', platforms)
          ..add('tags', tags)
          ..add('relationship', relationship)
          ..add('role', role)
          ..add('email', email)
          ..add('emailVerified', emailVerified)
          ..add('hasPassword', hasPassword)
          ..add('country', country)
          ..add('onboardedAt', onboardedAt)
          ..add('createdAt', createdAt)
          ..add('waitlist', waitlist)
          ..add('bio', bio)
          ..add('statusUntil', statusUntil)
          ..add('games', games)
          ..add('gamingIds', gamingIds)
          ..add('stats', stats)
          ..add('incomingRequestId', incomingRequestId)
          ..add('outgoingRequestId', outgoingRequestId)
          ..add('id', id)
          ..add('username', username)
          ..add('displayName', displayName)
          ..add('avatarUrl', avatarUrl)
          ..add('city', city)
          ..add('statusGame', statusGame)
          ..add('topGame', topGame))
        .toString();
  }
}

class MeDtoBuilder implements Builder<MeDto, MeDtoBuilder> {
  _$MeDto? _$v;

  PlayerStatus? _status;
  PlayerStatus? get status => _$this._status;
  set status(PlayerStatus? status) => _$this._status = status;

  AgeRange? _ageRange;
  AgeRange? get ageRange => _$this._ageRange;
  set ageRange(AgeRange? ageRange) => _$this._ageRange = ageRange;

  ListBuilder<Day>? _availableDays;
  ListBuilder<Day> get availableDays =>
      _$this._availableDays ??= ListBuilder<Day>();
  set availableDays(ListBuilder<Day>? availableDays) =>
      _$this._availableDays = availableDays;

  ListBuilder<Platform>? _platforms;
  ListBuilder<Platform> get platforms =>
      _$this._platforms ??= ListBuilder<Platform>();
  set platforms(ListBuilder<Platform>? platforms) =>
      _$this._platforms = platforms;

  ListBuilder<PlayTag>? _tags;
  ListBuilder<PlayTag> get tags => _$this._tags ??= ListBuilder<PlayTag>();
  set tags(ListBuilder<PlayTag>? tags) => _$this._tags = tags;

  Relationship? _relationship;
  Relationship? get relationship => _$this._relationship;
  set relationship(Relationship? relationship) =>
      _$this._relationship = relationship;

  UserRole? _role;
  UserRole? get role => _$this._role;
  set role(UserRole? role) => _$this._role = role;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  bool? _emailVerified;
  bool? get emailVerified => _$this._emailVerified;
  set emailVerified(bool? emailVerified) =>
      _$this._emailVerified = emailVerified;

  bool? _hasPassword;
  bool? get hasPassword => _$this._hasPassword;
  set hasPassword(bool? hasPassword) => _$this._hasPassword = hasPassword;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  DateTime? _onboardedAt;
  DateTime? get onboardedAt => _$this._onboardedAt;
  set onboardedAt(DateTime? onboardedAt) => _$this._onboardedAt = onboardedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<String>? _waitlist;
  ListBuilder<String> get waitlist =>
      _$this._waitlist ??= ListBuilder<String>();
  set waitlist(ListBuilder<String>? waitlist) => _$this._waitlist = waitlist;

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  DateTime? _statusUntil;
  DateTime? get statusUntil => _$this._statusUntil;
  set statusUntil(DateTime? statusUntil) => _$this._statusUntil = statusUntil;

  ListBuilder<UserGameDto>? _games;
  ListBuilder<UserGameDto> get games =>
      _$this._games ??= ListBuilder<UserGameDto>();
  set games(ListBuilder<UserGameDto>? games) => _$this._games = games;

  ListBuilder<GamingIdDto>? _gamingIds;
  ListBuilder<GamingIdDto> get gamingIds =>
      _$this._gamingIds ??= ListBuilder<GamingIdDto>();
  set gamingIds(ListBuilder<GamingIdDto>? gamingIds) =>
      _$this._gamingIds = gamingIds;

  ProfileStatsDtoBuilder? _stats;
  ProfileStatsDtoBuilder get stats =>
      _$this._stats ??= ProfileStatsDtoBuilder();
  set stats(ProfileStatsDtoBuilder? stats) => _$this._stats = stats;

  String? _incomingRequestId;
  String? get incomingRequestId => _$this._incomingRequestId;
  set incomingRequestId(String? incomingRequestId) =>
      _$this._incomingRequestId = incomingRequestId;

  String? _outgoingRequestId;
  String? get outgoingRequestId => _$this._outgoingRequestId;
  set outgoingRequestId(String? outgoingRequestId) =>
      _$this._outgoingRequestId = outgoingRequestId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  GameRefDtoBuilder? _statusGame;
  GameRefDtoBuilder get statusGame =>
      _$this._statusGame ??= GameRefDtoBuilder();
  set statusGame(GameRefDtoBuilder? statusGame) =>
      _$this._statusGame = statusGame;

  UserGameDtoBuilder? _topGame;
  UserGameDtoBuilder get topGame => _$this._topGame ??= UserGameDtoBuilder();
  set topGame(UserGameDtoBuilder? topGame) => _$this._topGame = topGame;

  MeDtoBuilder() {
    MeDto._defaults(this);
  }

  MeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _ageRange = $v.ageRange;
      _availableDays = $v.availableDays.toBuilder();
      _platforms = $v.platforms.toBuilder();
      _tags = $v.tags.toBuilder();
      _relationship = $v.relationship;
      _role = $v.role;
      _email = $v.email;
      _emailVerified = $v.emailVerified;
      _hasPassword = $v.hasPassword;
      _country = $v.country;
      _onboardedAt = $v.onboardedAt;
      _createdAt = $v.createdAt;
      _waitlist = $v.waitlist.toBuilder();
      _bio = $v.bio;
      _statusUntil = $v.statusUntil;
      _games = $v.games.toBuilder();
      _gamingIds = $v.gamingIds.toBuilder();
      _stats = $v.stats.toBuilder();
      _incomingRequestId = $v.incomingRequestId;
      _outgoingRequestId = $v.outgoingRequestId;
      _id = $v.id;
      _username = $v.username;
      _displayName = $v.displayName;
      _avatarUrl = $v.avatarUrl;
      _city = $v.city;
      _statusGame = $v.statusGame?.toBuilder();
      _topGame = $v.topGame?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeDto other) {
    _$v = other as _$MeDto;
  }

  @override
  void update(void Function(MeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeDto build() => _build();

  _$MeDto _build() {
    _$MeDto _$result;
    try {
      _$result = _$v ??
          _$MeDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'MeDto', 'status'),
            ageRange: BuiltValueNullFieldError.checkNotNull(
                ageRange, r'MeDto', 'ageRange'),
            availableDays: availableDays.build(),
            platforms: platforms.build(),
            tags: tags.build(),
            relationship: BuiltValueNullFieldError.checkNotNull(
                relationship, r'MeDto', 'relationship'),
            role: BuiltValueNullFieldError.checkNotNull(role, r'MeDto', 'role'),
            email:
                BuiltValueNullFieldError.checkNotNull(email, r'MeDto', 'email'),
            emailVerified: BuiltValueNullFieldError.checkNotNull(
                emailVerified, r'MeDto', 'emailVerified'),
            hasPassword: BuiltValueNullFieldError.checkNotNull(
                hasPassword, r'MeDto', 'hasPassword'),
            country: BuiltValueNullFieldError.checkNotNull(
                country, r'MeDto', 'country'),
            onboardedAt: onboardedAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'MeDto', 'createdAt'),
            waitlist: waitlist.build(),
            bio: bio,
            statusUntil: statusUntil,
            games: games.build(),
            gamingIds: gamingIds.build(),
            stats: stats.build(),
            incomingRequestId: incomingRequestId,
            outgoingRequestId: outgoingRequestId,
            id: BuiltValueNullFieldError.checkNotNull(id, r'MeDto', 'id'),
            username: BuiltValueNullFieldError.checkNotNull(
                username, r'MeDto', 'username'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'MeDto', 'displayName'),
            avatarUrl: avatarUrl,
            city: BuiltValueNullFieldError.checkNotNull(city, r'MeDto', 'city'),
            statusGame: _statusGame?.build(),
            topGame: _topGame?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'availableDays';
        availableDays.build();
        _$failedField = 'platforms';
        platforms.build();
        _$failedField = 'tags';
        tags.build();

        _$failedField = 'waitlist';
        waitlist.build();

        _$failedField = 'games';
        games.build();
        _$failedField = 'gamingIds';
        gamingIds.build();
        _$failedField = 'stats';
        stats.build();

        _$failedField = 'statusGame';
        _statusGame?.build();
        _$failedField = 'topGame';
        _topGame?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'MeDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
