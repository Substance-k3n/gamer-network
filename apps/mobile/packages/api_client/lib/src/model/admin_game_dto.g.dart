// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_game_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminGameDto extends AdminGameDto {
  @override
  final BuiltList<Platform> platforms;
  @override
  final String id;
  @override
  final String name;
  @override
  final String shortCode;
  @override
  final bool hasRanks;
  @override
  final num maxParty;
  @override
  final bool isLaunch;
  @override
  final num sort;
  @override
  final BuiltList<RankDto> ranks;
  @override
  final num players;
  @override
  final num liveListings;
  @override
  final DateTime? deletedAt;

  factory _$AdminGameDto([void Function(AdminGameDtoBuilder)? updates]) =>
      (AdminGameDtoBuilder()..update(updates))._build();

  _$AdminGameDto._(
      {required this.platforms,
      required this.id,
      required this.name,
      required this.shortCode,
      required this.hasRanks,
      required this.maxParty,
      required this.isLaunch,
      required this.sort,
      required this.ranks,
      required this.players,
      required this.liveListings,
      this.deletedAt})
      : super._();
  @override
  AdminGameDto rebuild(void Function(AdminGameDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminGameDtoBuilder toBuilder() => AdminGameDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminGameDto &&
        platforms == other.platforms &&
        id == other.id &&
        name == other.name &&
        shortCode == other.shortCode &&
        hasRanks == other.hasRanks &&
        maxParty == other.maxParty &&
        isLaunch == other.isLaunch &&
        sort == other.sort &&
        ranks == other.ranks &&
        players == other.players &&
        liveListings == other.liveListings &&
        deletedAt == other.deletedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, platforms.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, shortCode.hashCode);
    _$hash = $jc(_$hash, hasRanks.hashCode);
    _$hash = $jc(_$hash, maxParty.hashCode);
    _$hash = $jc(_$hash, isLaunch.hashCode);
    _$hash = $jc(_$hash, sort.hashCode);
    _$hash = $jc(_$hash, ranks.hashCode);
    _$hash = $jc(_$hash, players.hashCode);
    _$hash = $jc(_$hash, liveListings.hashCode);
    _$hash = $jc(_$hash, deletedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminGameDto')
          ..add('platforms', platforms)
          ..add('id', id)
          ..add('name', name)
          ..add('shortCode', shortCode)
          ..add('hasRanks', hasRanks)
          ..add('maxParty', maxParty)
          ..add('isLaunch', isLaunch)
          ..add('sort', sort)
          ..add('ranks', ranks)
          ..add('players', players)
          ..add('liveListings', liveListings)
          ..add('deletedAt', deletedAt))
        .toString();
  }
}

class AdminGameDtoBuilder
    implements Builder<AdminGameDto, AdminGameDtoBuilder> {
  _$AdminGameDto? _$v;

  ListBuilder<Platform>? _platforms;
  ListBuilder<Platform> get platforms =>
      _$this._platforms ??= ListBuilder<Platform>();
  set platforms(ListBuilder<Platform>? platforms) =>
      _$this._platforms = platforms;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _shortCode;
  String? get shortCode => _$this._shortCode;
  set shortCode(String? shortCode) => _$this._shortCode = shortCode;

  bool? _hasRanks;
  bool? get hasRanks => _$this._hasRanks;
  set hasRanks(bool? hasRanks) => _$this._hasRanks = hasRanks;

  num? _maxParty;
  num? get maxParty => _$this._maxParty;
  set maxParty(num? maxParty) => _$this._maxParty = maxParty;

  bool? _isLaunch;
  bool? get isLaunch => _$this._isLaunch;
  set isLaunch(bool? isLaunch) => _$this._isLaunch = isLaunch;

  num? _sort;
  num? get sort => _$this._sort;
  set sort(num? sort) => _$this._sort = sort;

  ListBuilder<RankDto>? _ranks;
  ListBuilder<RankDto> get ranks => _$this._ranks ??= ListBuilder<RankDto>();
  set ranks(ListBuilder<RankDto>? ranks) => _$this._ranks = ranks;

  num? _players;
  num? get players => _$this._players;
  set players(num? players) => _$this._players = players;

  num? _liveListings;
  num? get liveListings => _$this._liveListings;
  set liveListings(num? liveListings) => _$this._liveListings = liveListings;

  DateTime? _deletedAt;
  DateTime? get deletedAt => _$this._deletedAt;
  set deletedAt(DateTime? deletedAt) => _$this._deletedAt = deletedAt;

  AdminGameDtoBuilder() {
    AdminGameDto._defaults(this);
  }

  AdminGameDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platforms = $v.platforms.toBuilder();
      _id = $v.id;
      _name = $v.name;
      _shortCode = $v.shortCode;
      _hasRanks = $v.hasRanks;
      _maxParty = $v.maxParty;
      _isLaunch = $v.isLaunch;
      _sort = $v.sort;
      _ranks = $v.ranks.toBuilder();
      _players = $v.players;
      _liveListings = $v.liveListings;
      _deletedAt = $v.deletedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminGameDto other) {
    _$v = other as _$AdminGameDto;
  }

  @override
  void update(void Function(AdminGameDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminGameDto build() => _build();

  _$AdminGameDto _build() {
    _$AdminGameDto _$result;
    try {
      _$result = _$v ??
          _$AdminGameDto._(
            platforms: platforms.build(),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminGameDto', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'AdminGameDto', 'name'),
            shortCode: BuiltValueNullFieldError.checkNotNull(
                shortCode, r'AdminGameDto', 'shortCode'),
            hasRanks: BuiltValueNullFieldError.checkNotNull(
                hasRanks, r'AdminGameDto', 'hasRanks'),
            maxParty: BuiltValueNullFieldError.checkNotNull(
                maxParty, r'AdminGameDto', 'maxParty'),
            isLaunch: BuiltValueNullFieldError.checkNotNull(
                isLaunch, r'AdminGameDto', 'isLaunch'),
            sort: BuiltValueNullFieldError.checkNotNull(
                sort, r'AdminGameDto', 'sort'),
            ranks: ranks.build(),
            players: BuiltValueNullFieldError.checkNotNull(
                players, r'AdminGameDto', 'players'),
            liveListings: BuiltValueNullFieldError.checkNotNull(
                liveListings, r'AdminGameDto', 'liveListings'),
            deletedAt: deletedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'platforms';
        platforms.build();

        _$failedField = 'ranks';
        ranks.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminGameDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
