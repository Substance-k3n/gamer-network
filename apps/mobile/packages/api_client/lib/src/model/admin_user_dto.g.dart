// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUserDto extends AdminUserDto {
  @override
  final AccountState state;
  @override
  final String id;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final String email;
  @override
  final String city;
  @override
  final String? mainGame;
  @override
  final String? banReason;
  @override
  final bool onboarded;
  @override
  final DateTime createdAt;
  @override
  final DateTime? lastSeenAt;
  @override
  final num connections;
  @override
  final num playedWith;
  @override
  final num openReports;

  factory _$AdminUserDto([void Function(AdminUserDtoBuilder)? updates]) =>
      (AdminUserDtoBuilder()..update(updates))._build();

  _$AdminUserDto._(
      {required this.state,
      required this.id,
      required this.username,
      required this.displayName,
      required this.email,
      required this.city,
      this.mainGame,
      this.banReason,
      required this.onboarded,
      required this.createdAt,
      this.lastSeenAt,
      required this.connections,
      required this.playedWith,
      required this.openReports})
      : super._();
  @override
  AdminUserDto rebuild(void Function(AdminUserDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminUserDtoBuilder toBuilder() => AdminUserDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUserDto &&
        state == other.state &&
        id == other.id &&
        username == other.username &&
        displayName == other.displayName &&
        email == other.email &&
        city == other.city &&
        mainGame == other.mainGame &&
        banReason == other.banReason &&
        onboarded == other.onboarded &&
        createdAt == other.createdAt &&
        lastSeenAt == other.lastSeenAt &&
        connections == other.connections &&
        playedWith == other.playedWith &&
        openReports == other.openReports;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, mainGame.hashCode);
    _$hash = $jc(_$hash, banReason.hashCode);
    _$hash = $jc(_$hash, onboarded.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jc(_$hash, connections.hashCode);
    _$hash = $jc(_$hash, playedWith.hashCode);
    _$hash = $jc(_$hash, openReports.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminUserDto')
          ..add('state', state)
          ..add('id', id)
          ..add('username', username)
          ..add('displayName', displayName)
          ..add('email', email)
          ..add('city', city)
          ..add('mainGame', mainGame)
          ..add('banReason', banReason)
          ..add('onboarded', onboarded)
          ..add('createdAt', createdAt)
          ..add('lastSeenAt', lastSeenAt)
          ..add('connections', connections)
          ..add('playedWith', playedWith)
          ..add('openReports', openReports))
        .toString();
  }
}

class AdminUserDtoBuilder
    implements Builder<AdminUserDto, AdminUserDtoBuilder> {
  _$AdminUserDto? _$v;

  AccountState? _state;
  AccountState? get state => _$this._state;
  set state(AccountState? state) => _$this._state = state;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _mainGame;
  String? get mainGame => _$this._mainGame;
  set mainGame(String? mainGame) => _$this._mainGame = mainGame;

  String? _banReason;
  String? get banReason => _$this._banReason;
  set banReason(String? banReason) => _$this._banReason = banReason;

  bool? _onboarded;
  bool? get onboarded => _$this._onboarded;
  set onboarded(bool? onboarded) => _$this._onboarded = onboarded;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _lastSeenAt;
  DateTime? get lastSeenAt => _$this._lastSeenAt;
  set lastSeenAt(DateTime? lastSeenAt) => _$this._lastSeenAt = lastSeenAt;

  num? _connections;
  num? get connections => _$this._connections;
  set connections(num? connections) => _$this._connections = connections;

  num? _playedWith;
  num? get playedWith => _$this._playedWith;
  set playedWith(num? playedWith) => _$this._playedWith = playedWith;

  num? _openReports;
  num? get openReports => _$this._openReports;
  set openReports(num? openReports) => _$this._openReports = openReports;

  AdminUserDtoBuilder() {
    AdminUserDto._defaults(this);
  }

  AdminUserDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _id = $v.id;
      _username = $v.username;
      _displayName = $v.displayName;
      _email = $v.email;
      _city = $v.city;
      _mainGame = $v.mainGame;
      _banReason = $v.banReason;
      _onboarded = $v.onboarded;
      _createdAt = $v.createdAt;
      _lastSeenAt = $v.lastSeenAt;
      _connections = $v.connections;
      _playedWith = $v.playedWith;
      _openReports = $v.openReports;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUserDto other) {
    _$v = other as _$AdminUserDto;
  }

  @override
  void update(void Function(AdminUserDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUserDto build() => _build();

  _$AdminUserDto _build() {
    final _$result = _$v ??
        _$AdminUserDto._(
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'AdminUserDto', 'state'),
          id: BuiltValueNullFieldError.checkNotNull(id, r'AdminUserDto', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'AdminUserDto', 'username'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'AdminUserDto', 'displayName'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'AdminUserDto', 'email'),
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'AdminUserDto', 'city'),
          mainGame: mainGame,
          banReason: banReason,
          onboarded: BuiltValueNullFieldError.checkNotNull(
              onboarded, r'AdminUserDto', 'onboarded'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminUserDto', 'createdAt'),
          lastSeenAt: lastSeenAt,
          connections: BuiltValueNullFieldError.checkNotNull(
              connections, r'AdminUserDto', 'connections'),
          playedWith: BuiltValueNullFieldError.checkNotNull(
              playedWith, r'AdminUserDto', 'playedWith'),
          openReports: BuiltValueNullFieldError.checkNotNull(
              openReports, r'AdminUserDto', 'openReports'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
