// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CodeBody extends CodeBody {
  @override
  final String code;

  factory _$CodeBody([void Function(CodeBodyBuilder)? updates]) =>
      (CodeBodyBuilder()..update(updates))._build();

  _$CodeBody._({required this.code}) : super._();
  @override
  CodeBody rebuild(void Function(CodeBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CodeBodyBuilder toBuilder() => CodeBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CodeBody && code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CodeBody')..add('code', code))
        .toString();
  }
}

class CodeBodyBuilder implements Builder<CodeBody, CodeBodyBuilder> {
  _$CodeBody? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CodeBodyBuilder() {
    CodeBody._defaults(this);
  }

  CodeBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CodeBody other) {
    _$v = other as _$CodeBody;
  }

  @override
  void update(void Function(CodeBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CodeBody build() => _build();

  _$CodeBody _build() {
    final _$result = _$v ??
        _$CodeBody._(
          code:
              BuiltValueNullFieldError.checkNotNull(code, r'CodeBody', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
