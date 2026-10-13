// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConnectionDto extends ConnectionDto {
  @override
  final UserCardDto user;
  @override
  final DateTime connectedAt;

  factory _$ConnectionDto([void Function(ConnectionDtoBuilder)? updates]) =>
      (ConnectionDtoBuilder()..update(updates))._build();

  _$ConnectionDto._({required this.user, required this.connectedAt})
      : super._();
  @override
  ConnectionDto rebuild(void Function(ConnectionDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConnectionDtoBuilder toBuilder() => ConnectionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConnectionDto &&
        user == other.user &&
        connectedAt == other.connectedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, connectedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConnectionDto')
          ..add('user', user)
          ..add('connectedAt', connectedAt))
        .toString();
  }
}

class ConnectionDtoBuilder
    implements Builder<ConnectionDto, ConnectionDtoBuilder> {
  _$ConnectionDto? _$v;

  UserCardDtoBuilder? _user;
  UserCardDtoBuilder get user => _$this._user ??= UserCardDtoBuilder();
  set user(UserCardDtoBuilder? user) => _$this._user = user;

  DateTime? _connectedAt;
  DateTime? get connectedAt => _$this._connectedAt;
  set connectedAt(DateTime? connectedAt) => _$this._connectedAt = connectedAt;

  ConnectionDtoBuilder() {
    ConnectionDto._defaults(this);
  }

  ConnectionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _connectedAt = $v.connectedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConnectionDto other) {
    _$v = other as _$ConnectionDto;
  }

  @override
  void update(void Function(ConnectionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConnectionDto build() => _build();

  _$ConnectionDto _build() {
    _$ConnectionDto _$result;
    try {
      _$result = _$v ??
          _$ConnectionDto._(
            user: user.build(),
            connectedAt: BuiltValueNullFieldError.checkNotNull(
                connectedAt, r'ConnectionDto', 'connectedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ConnectionDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
