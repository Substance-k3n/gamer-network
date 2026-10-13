// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_game_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserGameDto extends UserGameDto {
  @override
  final String id;
  @override
  final GameRefDto? game;
  @override
  final String? customGameName;
  @override
  final RankRefDto? rank;
  @override
  final String? rankText;
  @override
  final RoleRefDto? role;

  factory _$UserGameDto([void Function(UserGameDtoBuilder)? updates]) =>
      (UserGameDtoBuilder()..update(updates))._build();

  _$UserGameDto._(
      {required this.id,
      this.game,
      this.customGameName,
      this.rank,
      this.rankText,
      this.role})
      : super._();
  @override
  UserGameDto rebuild(void Function(UserGameDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserGameDtoBuilder toBuilder() => UserGameDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserGameDto &&
        id == other.id &&
        game == other.game &&
        customGameName == other.customGameName &&
        rank == other.rank &&
        rankText == other.rankText &&
        role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, customGameName.hashCode);
    _$hash = $jc(_$hash, rank.hashCode);
    _$hash = $jc(_$hash, rankText.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserGameDto')
          ..add('id', id)
          ..add('game', game)
          ..add('customGameName', customGameName)
          ..add('rank', rank)
          ..add('rankText', rankText)
          ..add('role', role))
        .toString();
  }
}

class UserGameDtoBuilder implements Builder<UserGameDto, UserGameDtoBuilder> {
  _$UserGameDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  GameRefDtoBuilder? _game;
  GameRefDtoBuilder get game => _$this._game ??= GameRefDtoBuilder();
  set game(GameRefDtoBuilder? game) => _$this._game = game;

  String? _customGameName;
  String? get customGameName => _$this._customGameName;
  set customGameName(String? customGameName) =>
      _$this._customGameName = customGameName;

  RankRefDtoBuilder? _rank;
  RankRefDtoBuilder get rank => _$this._rank ??= RankRefDtoBuilder();
  set rank(RankRefDtoBuilder? rank) => _$this._rank = rank;

  String? _rankText;
  String? get rankText => _$this._rankText;
  set rankText(String? rankText) => _$this._rankText = rankText;

  RoleRefDtoBuilder? _role;
  RoleRefDtoBuilder get role => _$this._role ??= RoleRefDtoBuilder();
  set role(RoleRefDtoBuilder? role) => _$this._role = role;

  UserGameDtoBuilder() {
    UserGameDto._defaults(this);
  }

  UserGameDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _game = $v.game?.toBuilder();
      _customGameName = $v.customGameName;
      _rank = $v.rank?.toBuilder();
      _rankText = $v.rankText;
      _role = $v.role?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserGameDto other) {
    _$v = other as _$UserGameDto;
  }

  @override
  void update(void Function(UserGameDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserGameDto build() => _build();

  _$UserGameDto _build() {
    _$UserGameDto _$result;
    try {
      _$result = _$v ??
          _$UserGameDto._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'UserGameDto', 'id'),
            game: _game?.build(),
            customGameName: customGameName,
            rank: _rank?.build(),
            rankText: rankText,
            role: _role?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'game';
        _game?.build();

        _$failedField = 'rank';
        _rank?.build();

        _$failedField = 'role';
        _role?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserGameDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
