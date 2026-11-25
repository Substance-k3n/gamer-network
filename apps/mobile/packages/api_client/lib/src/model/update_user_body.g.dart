// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateUserBody extends UpdateUserBody {
  @override
  final UserRole? role;
  @override
  final String? email;
  @override
  final String? username;
  @override
  final String? displayName;
  @override
  final String? city;

  factory _$UpdateUserBody([void Function(UpdateUserBodyBuilder)? updates]) =>
      (UpdateUserBodyBuilder()..update(updates))._build();

  _$UpdateUserBody._(
      {this.role, this.email, this.username, this.displayName, this.city})
      : super._();
  @override
  UpdateUserBody rebuild(void Function(UpdateUserBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateUserBodyBuilder toBuilder() => UpdateUserBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateUserBody &&
        role == other.role &&
        email == other.email &&
        username == other.username &&
        displayName == other.displayName &&
        city == other.city;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateUserBody')
          ..add('role', role)
          ..add('email', email)
          ..add('username', username)
          ..add('displayName', displayName)
          ..add('city', city))
        .toString();
  }
}

class UpdateUserBodyBuilder
    implements Builder<UpdateUserBody, UpdateUserBodyBuilder> {
  _$UpdateUserBody? _$v;

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

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  UpdateUserBodyBuilder() {
    UpdateUserBody._defaults(this);
  }

  UpdateUserBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _email = $v.email;
      _username = $v.username;
      _displayName = $v.displayName;
      _city = $v.city;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateUserBody other) {
    _$v = other as _$UpdateUserBody;
  }

  @override
  void update(void Function(UpdateUserBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateUserBody build() => _build();

  _$UpdateUserBody _build() {
    final _$result = _$v ??
        _$UpdateUserBody._(
          role: role,
          email: email,
          username: username,
          displayName: displayName,
          city: city,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
