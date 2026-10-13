// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_card_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserCardDto extends UserCardDto {
  @override
  final PlayerStatus status;
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

  factory _$UserCardDto([void Function(UserCardDtoBuilder)? updates]) =>
      (UserCardDtoBuilder()..update(updates))._build();

  _$UserCardDto._(
      {required this.status,
      required this.id,
      required this.username,
      required this.displayName,
      this.avatarUrl,
      required this.city,
      this.statusGame,
      this.topGame})
      : super._();
  @override
  UserCardDto rebuild(void Function(UserCardDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserCardDtoBuilder toBuilder() => UserCardDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserCardDto &&
        status == other.status &&
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
    return (newBuiltValueToStringHelper(r'UserCardDto')
          ..add('status', status)
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

class UserCardDtoBuilder implements Builder<UserCardDto, UserCardDtoBuilder> {
  _$UserCardDto? _$v;

  PlayerStatus? _status;
  PlayerStatus? get status => _$this._status;
  set status(PlayerStatus? status) => _$this._status = status;

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

  UserCardDtoBuilder() {
    UserCardDto._defaults(this);
  }

  UserCardDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
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
  void replace(UserCardDto other) {
    _$v = other as _$UserCardDto;
  }

  @override
  void update(void Function(UserCardDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserCardDto build() => _build();

  _$UserCardDto _build() {
    _$UserCardDto _$result;
    try {
      _$result = _$v ??
          _$UserCardDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'UserCardDto', 'status'),
            id: BuiltValueNullFieldError.checkNotNull(id, r'UserCardDto', 'id'),
            username: BuiltValueNullFieldError.checkNotNull(
                username, r'UserCardDto', 'username'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'UserCardDto', 'displayName'),
            avatarUrl: avatarUrl,
            city: BuiltValueNullFieldError.checkNotNull(
                city, r'UserCardDto', 'city'),
            statusGame: _statusGame?.build(),
            topGame: _topGame?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'statusGame';
        _statusGame?.build();
        _$failedField = 'topGame';
        _topGame?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserCardDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
