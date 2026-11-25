// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateUserBody extends CreateUserBody {
  @override
  final AgeRange ageRange;
  @override
  final UserRole? role;
  @override
  final String email;
  @override
  final String username;
  @override
  final String displayName;
  @override
  final String password;

  factory _$CreateUserBody([void Function(CreateUserBodyBuilder)? updates]) =>
      (CreateUserBodyBuilder()..update(updates))._build();

  _$CreateUserBody._(
      {required this.ageRange,
      this.role,
      required this.email,
      required this.username,
      required this.displayName,
      required this.password})
      : super._();
  @override
  CreateUserBody rebuild(void Function(CreateUserBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateUserBodyBuilder toBuilder() => CreateUserBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateUserBody &&
        ageRange == other.ageRange &&
        role == other.role &&
        email == other.email &&
        username == other.username &&
        displayName == other.displayName &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ageRange.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateUserBody')
          ..add('ageRange', ageRange)
          ..add('role', role)
          ..add('email', email)
          ..add('username', username)
          ..add('displayName', displayName)
          ..add('password', password))
        .toString();
  }
}

class CreateUserBodyBuilder
    implements Builder<CreateUserBody, CreateUserBodyBuilder> {
  _$CreateUserBody? _$v;

  AgeRange? _ageRange;
  AgeRange? get ageRange => _$this._ageRange;
  set ageRange(AgeRange? ageRange) => _$this._ageRange = ageRange;

  UserRole? _role;
  UserRole? get role => _$this._role;
  set role(UserRole? role) => _$this._role = role;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  CreateUserBodyBuilder() {
    CreateUserBody._defaults(this);
  }

  CreateUserBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ageRange = $v.ageRange;
      _role = $v.role;
      _email = $v.email;
      _username = $v.username;
      _displayName = $v.displayName;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateUserBody other) {
    _$v = other as _$CreateUserBody;
  }

  @override
  void update(void Function(CreateUserBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateUserBody build() => _build();

  _$CreateUserBody _build() {
    final _$result = _$v ??
        _$CreateUserBody._(
          ageRange: BuiltValueNullFieldError.checkNotNull(
              ageRange, r'CreateUserBody', 'ageRange'),
          role: role,
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'CreateUserBody', 'email'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'CreateUserBody', 'username'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'CreateUserBody', 'displayName'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'CreateUserBody', 'password'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
