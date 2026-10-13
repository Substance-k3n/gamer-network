// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_game_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserGameInput extends UserGameInput {
  @override
  final String? gameId;
  @override
  final String? customGameName;
  @override
  final String? rankId;
  @override
  final String? rankText;
  @override
  final String? roleId;

  factory _$UserGameInput([void Function(UserGameInputBuilder)? updates]) =>
      (UserGameInputBuilder()..update(updates))._build();

  _$UserGameInput._(
      {this.gameId,
      this.customGameName,
      this.rankId,
      this.rankText,
      this.roleId})
      : super._();
  @override
  UserGameInput rebuild(void Function(UserGameInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserGameInputBuilder toBuilder() => UserGameInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserGameInput &&
        gameId == other.gameId &&
        customGameName == other.customGameName &&
        rankId == other.rankId &&
        rankText == other.rankText &&
        roleId == other.roleId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gameId.hashCode);
    _$hash = $jc(_$hash, customGameName.hashCode);
    _$hash = $jc(_$hash, rankId.hashCode);
    _$hash = $jc(_$hash, rankText.hashCode);
    _$hash = $jc(_$hash, roleId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserGameInput')
          ..add('gameId', gameId)
          ..add('customGameName', customGameName)
          ..add('rankId', rankId)
          ..add('rankText', rankText)
          ..add('roleId', roleId))
        .toString();
  }
}

class UserGameInputBuilder
    implements Builder<UserGameInput, UserGameInputBuilder> {
  _$UserGameInput? _$v;

  String? _gameId;
  String? get gameId => _$this._gameId;
  set gameId(String? gameId) => _$this._gameId = gameId;

  String? _customGameName;
  String? get customGameName => _$this._customGameName;
  set customGameName(String? customGameName) =>
      _$this._customGameName = customGameName;

  String? _rankId;
  String? get rankId => _$this._rankId;
  set rankId(String? rankId) => _$this._rankId = rankId;

  String? _rankText;
  String? get rankText => _$this._rankText;
  set rankText(String? rankText) => _$this._rankText = rankText;

  String? _roleId;
  String? get roleId => _$this._roleId;
  set roleId(String? roleId) => _$this._roleId = roleId;

  UserGameInputBuilder() {
    UserGameInput._defaults(this);
  }

  UserGameInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gameId = $v.gameId;
      _customGameName = $v.customGameName;
      _rankId = $v.rankId;
      _rankText = $v.rankText;
      _roleId = $v.roleId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserGameInput other) {
    _$v = other as _$UserGameInput;
  }

  @override
  void update(void Function(UserGameInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserGameInput build() => _build();

  _$UserGameInput _build() {
    final _$result = _$v ??
        _$UserGameInput._(
          gameId: gameId,
          customGameName: customGameName,
          rankId: rankId,
          rankText: rankText,
          roleId: roleId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
