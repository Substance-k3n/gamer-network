// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ForgotPasswordBody extends ForgotPasswordBody {
  @override
  final String email;

  factory _$ForgotPasswordBody(
          [void Function(ForgotPasswordBodyBuilder)? updates]) =>
      (ForgotPasswordBodyBuilder()..update(updates))._build();

  _$ForgotPasswordBody._({required this.email}) : super._();
  @override
  ForgotPasswordBody rebuild(
          void Function(ForgotPasswordBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ForgotPasswordBodyBuilder toBuilder() =>
      ForgotPasswordBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ForgotPasswordBody && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ForgotPasswordBody')
          ..add('email', email))
        .toString();
  }
}

class ForgotPasswordBodyBuilder
    implements Builder<ForgotPasswordBody, ForgotPasswordBodyBuilder> {
  _$ForgotPasswordBody? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ForgotPasswordBodyBuilder() {
    ForgotPasswordBody._defaults(this);
  }

  ForgotPasswordBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ForgotPasswordBody other) {
    _$v = other as _$ForgotPasswordBody;
  }

  @override
  void update(void Function(ForgotPasswordBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ForgotPasswordBody build() => _build();

  _$ForgotPasswordBody _build() {
    final _$result = _$v ??
        _$ForgotPasswordBody._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'ForgotPasswordBody', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
