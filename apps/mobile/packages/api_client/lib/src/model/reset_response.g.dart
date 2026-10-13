// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResetResponse extends ResetResponse {
  @override
  final String token;
  @override
  final MeDto user;

  factory _$ResetResponse([void Function(ResetResponseBuilder)? updates]) =>
      (ResetResponseBuilder()..update(updates))._build();

  _$ResetResponse._({required this.token, required this.user}) : super._();
  @override
  ResetResponse rebuild(void Function(ResetResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResetResponseBuilder toBuilder() => ResetResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResetResponse && token == other.token && user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResetResponse')
          ..add('token', token)
          ..add('user', user))
        .toString();
  }
}

class ResetResponseBuilder
    implements Builder<ResetResponse, ResetResponseBuilder> {
  _$ResetResponse? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  MeDtoBuilder? _user;
  MeDtoBuilder get user => _$this._user ??= MeDtoBuilder();
  set user(MeDtoBuilder? user) => _$this._user = user;

  ResetResponseBuilder() {
    ResetResponse._defaults(this);
  }

  ResetResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResetResponse other) {
    _$v = other as _$ResetResponse;
  }

  @override
  void update(void Function(ResetResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResetResponse build() => _build();

  _$ResetResponse _build() {
    _$ResetResponse _$result;
    try {
      _$result = _$v ??
          _$ResetResponse._(
            token: BuiltValueNullFieldError.checkNotNull(
                token, r'ResetResponse', 'token'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ResetResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
