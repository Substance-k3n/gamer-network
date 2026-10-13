// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SignupBody extends SignupBody {
  @override
  final AgeRange ageRange;
  @override
  final String email;
  @override
  final String displayName;
  @override
  final String username;
  @override
  final String password;

  factory _$SignupBody([void Function(SignupBodyBuilder)? updates]) =>
      (SignupBodyBuilder()..update(updates))._build();

  _$SignupBody._(
      {required this.ageRange,
      required this.email,
      required this.displayName,
      required this.username,
      required this.password})
      : super._();
  @override
  SignupBody rebuild(void Function(SignupBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SignupBodyBuilder toBuilder() => SignupBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SignupBody &&
        ageRange == other.ageRange &&
        email == other.email &&
        displayName == other.displayName &&
        username == other.username &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ageRange.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SignupBody')
          ..add('ageRange', ageRange)
          ..add('email', email)
          ..add('displayName', displayName)
          ..add('username', username)
          ..add('password', password))
        .toString();
  }
}

class SignupBodyBuilder implements Builder<SignupBody, SignupBodyBuilder> {
  _$SignupBody? _$v;

  AgeRange? _ageRange;
  AgeRange? get ageRange => _$this._ageRange;
  set ageRange(AgeRange? ageRange) => _$this._ageRange = ageRange;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  SignupBodyBuilder() {
    SignupBody._defaults(this);
  }

  SignupBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ageRange = $v.ageRange;
      _email = $v.email;
      _displayName = $v.displayName;
      _username = $v.username;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SignupBody other) {
    _$v = other as _$SignupBody;
  }

  @override
  void update(void Function(SignupBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SignupBody build() => _build();

  _$SignupBody _build() {
    final _$result = _$v ??
        _$SignupBody._(
          ageRange: BuiltValueNullFieldError.checkNotNull(
              ageRange, r'SignupBody', 'ageRange'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'SignupBody', 'email'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'SignupBody', 'displayName'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'SignupBody', 'username'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'SignupBody', 'password'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
