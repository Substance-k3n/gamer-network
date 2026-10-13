// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GameDto extends GameDto {
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
  final BuiltList<RankDto> ranks;
  @override
  final BuiltList<RoleDto> roles;
  @override
  final BuiltList<ModeDto> modes;

  factory _$GameDto([void Function(GameDtoBuilder)? updates]) =>
      (GameDtoBuilder()..update(updates))._build();

  _$GameDto._(
      {required this.platforms,
      required this.id,
      required this.name,
      required this.shortCode,
      required this.hasRanks,
      required this.maxParty,
      required this.isLaunch,
      required this.ranks,
      required this.roles,
      required this.modes})
      : super._();
  @override
  GameDto rebuild(void Function(GameDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GameDtoBuilder toBuilder() => GameDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GameDto &&
        platforms == other.platforms &&
        id == other.id &&
        name == other.name &&
        shortCode == other.shortCode &&
        hasRanks == other.hasRanks &&
        maxParty == other.maxParty &&
        isLaunch == other.isLaunch &&
        ranks == other.ranks &&
        roles == other.roles &&
        modes == other.modes;
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
    _$hash = $jc(_$hash, ranks.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jc(_$hash, modes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GameDto')
          ..add('platforms', platforms)
          ..add('id', id)
          ..add('name', name)
          ..add('shortCode', shortCode)
          ..add('hasRanks', hasRanks)
          ..add('maxParty', maxParty)
          ..add('isLaunch', isLaunch)
          ..add('ranks', ranks)
          ..add('roles', roles)
          ..add('modes', modes))
        .toString();
  }
}

class GameDtoBuilder implements Builder<GameDto, GameDtoBuilder> {
  _$GameDto? _$v;

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

  ListBuilder<RankDto>? _ranks;
  ListBuilder<RankDto> get ranks => _$this._ranks ??= ListBuilder<RankDto>();
  set ranks(ListBuilder<RankDto>? ranks) => _$this._ranks = ranks;

  ListBuilder<RoleDto>? _roles;
  ListBuilder<RoleDto> get roles => _$this._roles ??= ListBuilder<RoleDto>();
  set roles(ListBuilder<RoleDto>? roles) => _$this._roles = roles;

  ListBuilder<ModeDto>? _modes;
  ListBuilder<ModeDto> get modes => _$this._modes ??= ListBuilder<ModeDto>();
  set modes(ListBuilder<ModeDto>? modes) => _$this._modes = modes;

  GameDtoBuilder() {
    GameDto._defaults(this);
  }

  GameDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platforms = $v.platforms.toBuilder();
      _id = $v.id;
      _name = $v.name;
      _shortCode = $v.shortCode;
      _hasRanks = $v.hasRanks;
      _maxParty = $v.maxParty;
      _isLaunch = $v.isLaunch;
      _ranks = $v.ranks.toBuilder();
      _roles = $v.roles.toBuilder();
      _modes = $v.modes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GameDto other) {
    _$v = other as _$GameDto;
  }

  @override
  void update(void Function(GameDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GameDto build() => _build();

  _$GameDto _build() {
    _$GameDto _$result;
    try {
      _$result = _$v ??
          _$GameDto._(
            platforms: platforms.build(),
            id: BuiltValueNullFieldError.checkNotNull(id, r'GameDto', 'id'),
            name:
                BuiltValueNullFieldError.checkNotNull(name, r'GameDto', 'name'),
            shortCode: BuiltValueNullFieldError.checkNotNull(
                shortCode, r'GameDto', 'shortCode'),
            hasRanks: BuiltValueNullFieldError.checkNotNull(
                hasRanks, r'GameDto', 'hasRanks'),
            maxParty: BuiltValueNullFieldError.checkNotNull(
                maxParty, r'GameDto', 'maxParty'),
            isLaunch: BuiltValueNullFieldError.checkNotNull(
                isLaunch, r'GameDto', 'isLaunch'),
            ranks: ranks.build(),
            roles: roles.build(),
            modes: modes.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'platforms';
        platforms.build();

        _$failedField = 'ranks';
        ranks.build();
        _$failedField = 'roles';
        roles.build();
        _$failedField = 'modes';
        modes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GameDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
