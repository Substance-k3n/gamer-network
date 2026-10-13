// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResetPasswordBody extends ResetPasswordBody {
  @override
  final String code;
  @override
  final String email;
  @override
  final String newPassword;

  factory _$ResetPasswordBody(
          [void Function(ResetPasswordBodyBuilder)? updates]) =>
      (ResetPasswordBodyBuilder()..update(updates))._build();

  _$ResetPasswordBody._(
      {required this.code, required this.email, required this.newPassword})
      : super._();
  @override
  ResetPasswordBody rebuild(void Function(ResetPasswordBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResetPasswordBodyBuilder toBuilder() =>
      ResetPasswordBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResetPasswordBody &&
        code == other.code &&
        email == other.email &&
        newPassword == other.newPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, newPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResetPasswordBody')
          ..add('code', code)
          ..add('email', email)
          ..add('newPassword', newPassword))
        .toString();
  }
}

class ResetPasswordBodyBuilder
    implements Builder<ResetPasswordBody, ResetPasswordBodyBuilder> {
  _$ResetPasswordBody? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _newPassword;
  String? get newPassword => _$this._newPassword;
  set newPassword(String? newPassword) => _$this._newPassword = newPassword;

  ResetPasswordBodyBuilder() {
    ResetPasswordBody._defaults(this);
  }

  ResetPasswordBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _email = $v.email;
      _newPassword = $v.newPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResetPasswordBody other) {
    _$v = other as _$ResetPasswordBody;
  }

  @override
  void update(void Function(ResetPasswordBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResetPasswordBody build() => _build();

  _$ResetPasswordBody _build() {
    final _$result = _$v ??
        _$ResetPasswordBody._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ResetPasswordBody', 'code'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'ResetPasswordBody', 'email'),
          newPassword: BuiltValueNullFieldError.checkNotNull(
              newPassword, r'ResetPasswordBody', 'newPassword'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
