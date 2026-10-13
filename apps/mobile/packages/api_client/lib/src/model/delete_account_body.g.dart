// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeleteAccountBody extends DeleteAccountBody {
  @override
  final String? password;

  factory _$DeleteAccountBody(
          [void Function(DeleteAccountBodyBuilder)? updates]) =>
      (DeleteAccountBodyBuilder()..update(updates))._build();

  _$DeleteAccountBody._({this.password}) : super._();
  @override
  DeleteAccountBody rebuild(void Function(DeleteAccountBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeleteAccountBodyBuilder toBuilder() =>
      DeleteAccountBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteAccountBody && password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeleteAccountBody')
          ..add('password', password))
        .toString();
  }
}

class DeleteAccountBodyBuilder
    implements Builder<DeleteAccountBody, DeleteAccountBodyBuilder> {
  _$DeleteAccountBody? _$v;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  DeleteAccountBodyBuilder() {
    DeleteAccountBody._defaults(this);
  }

  DeleteAccountBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteAccountBody other) {
    _$v = other as _$DeleteAccountBody;
  }

  @override
  void update(void Function(DeleteAccountBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteAccountBody build() => _build();

  _$DeleteAccountBody _build() {
    final _$result = _$v ??
        _$DeleteAccountBody._(
          password: password,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
