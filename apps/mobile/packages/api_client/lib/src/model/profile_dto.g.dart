// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProfileDto extends ProfileDto {
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

  factory _$ProfileDto([void Function(ProfileDtoBuilder)? updates]) =>
      (ProfileDtoBuilder()..update(updates))._build();

  _$ProfileDto._(
      {required this.status,
      required this.ageRange,
      required this.availableDays,
      required this.platforms,
      required this.tags,
      required this.relationship,
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
  ProfileDto rebuild(void Function(ProfileDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileDtoBuilder toBuilder() => ProfileDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileDto &&
        status == other.status &&
        ageRange == other.ageRange &&
        availableDays == other.availableDays &&
        platforms == other.platforms &&
        tags == other.tags &&
        relationship == other.relationship &&
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
    return (newBuiltValueToStringHelper(r'ProfileDto')
          ..add('status', status)
          ..add('ageRange', ageRange)
          ..add('availableDays', availableDays)
          ..add('platforms', platforms)
          ..add('tags', tags)
          ..add('relationship', relationship)
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

class ProfileDtoBuilder implements Builder<ProfileDto, ProfileDtoBuilder> {
  _$ProfileDto? _$v;

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

  ProfileDtoBuilder() {
    ProfileDto._defaults(this);
  }

  ProfileDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _ageRange = $v.ageRange;
      _availableDays = $v.availableDays.toBuilder();
      _platforms = $v.platforms.toBuilder();
      _tags = $v.tags.toBuilder();
      _relationship = $v.relationship;
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
  void replace(ProfileDto other) {
    _$v = other as _$ProfileDto;
  }

  @override
  void update(void Function(ProfileDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileDto build() => _build();

  _$ProfileDto _build() {
    _$ProfileDto _$result;
    try {
      _$result = _$v ??
          _$ProfileDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ProfileDto', 'status'),
            ageRange: BuiltValueNullFieldError.checkNotNull(
                ageRange, r'ProfileDto', 'ageRange'),
            availableDays: availableDays.build(),
            platforms: platforms.build(),
            tags: tags.build(),
            relationship: BuiltValueNullFieldError.checkNotNull(
                relationship, r'ProfileDto', 'relationship'),
            bio: bio,
            statusUntil: statusUntil,
            games: games.build(),
            gamingIds: gamingIds.build(),
            stats: stats.build(),
            incomingRequestId: incomingRequestId,
            outgoingRequestId: outgoingRequestId,
            id: BuiltValueNullFieldError.checkNotNull(id, r'ProfileDto', 'id'),
            username: BuiltValueNullFieldError.checkNotNull(
                username, r'ProfileDto', 'username'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'ProfileDto', 'displayName'),
            avatarUrl: avatarUrl,
            city: BuiltValueNullFieldError.checkNotNull(
                city, r'ProfileDto', 'city'),
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
        throw BuiltValueNestedFieldError(
            r'ProfileDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
