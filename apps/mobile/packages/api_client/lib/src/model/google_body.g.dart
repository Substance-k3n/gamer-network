// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoogleBody extends GoogleBody {
  @override
  final AgeRange? ageRange;
  @override
  final String idToken;
  @override
  final String? username;
  @override
  final String? displayName;

  factory _$GoogleBody([void Function(GoogleBodyBuilder)? updates]) =>
      (GoogleBodyBuilder()..update(updates))._build();

  _$GoogleBody._(
      {this.ageRange, required this.idToken, this.username, this.displayName})
      : super._();
  @override
  GoogleBody rebuild(void Function(GoogleBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleBodyBuilder toBuilder() => GoogleBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleBody &&
        ageRange == other.ageRange &&
        idToken == other.idToken &&
        username == other.username &&
        displayName == other.displayName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ageRange.hashCode);
    _$hash = $jc(_$hash, idToken.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleBody')
          ..add('ageRange', ageRange)
          ..add('idToken', idToken)
          ..add('username', username)
          ..add('displayName', displayName))
        .toString();
  }
}

class GoogleBodyBuilder implements Builder<GoogleBody, GoogleBodyBuilder> {
  _$GoogleBody? _$v;

  AgeRange? _ageRange;
  AgeRange? get ageRange => _$this._ageRange;
  set ageRange(AgeRange? ageRange) => _$this._ageRange = ageRange;

  String? _idToken;
  String? get idToken => _$this._idToken;
  set idToken(String? idToken) => _$this._idToken = idToken;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  GoogleBodyBuilder() {
    GoogleBody._defaults(this);
  }

  GoogleBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ageRange = $v.ageRange;
      _idToken = $v.idToken;
      _username = $v.username;
      _displayName = $v.displayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleBody other) {
    _$v = other as _$GoogleBody;
  }

  @override
  void update(void Function(GoogleBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleBody build() => _build();

  _$GoogleBody _build() {
    final _$result = _$v ??
        _$GoogleBody._(
          ageRange: ageRange,
          idToken: BuiltValueNullFieldError.checkNotNull(
              idToken, r'GoogleBody', 'idToken'),
          username: username,
          displayName: displayName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
