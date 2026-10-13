// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ErrorBody extends ErrorBody {
  @override
  final BuiltMap<String, String>? fields;
  @override
  final String code;
  @override
  final String message;

  factory _$ErrorBody([void Function(ErrorBodyBuilder)? updates]) =>
      (ErrorBodyBuilder()..update(updates))._build();

  _$ErrorBody._({this.fields, required this.code, required this.message})
      : super._();
  @override
  ErrorBody rebuild(void Function(ErrorBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorBodyBuilder toBuilder() => ErrorBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorBody &&
        fields == other.fields &&
        code == other.code &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fields.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErrorBody')
          ..add('fields', fields)
          ..add('code', code)
          ..add('message', message))
        .toString();
  }
}

class ErrorBodyBuilder implements Builder<ErrorBody, ErrorBodyBuilder> {
  _$ErrorBody? _$v;

  MapBuilder<String, String>? _fields;
  MapBuilder<String, String> get fields =>
      _$this._fields ??= MapBuilder<String, String>();
  set fields(MapBuilder<String, String>? fields) => _$this._fields = fields;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ErrorBodyBuilder() {
    ErrorBody._defaults(this);
  }

  ErrorBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fields = $v.fields?.toBuilder();
      _code = $v.code;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorBody other) {
    _$v = other as _$ErrorBody;
  }

  @override
  void update(void Function(ErrorBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorBody build() => _build();

  _$ErrorBody _build() {
    _$ErrorBody _$result;
    try {
      _$result = _$v ??
          _$ErrorBody._(
            fields: _fields?.build(),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'ErrorBody', 'code'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'ErrorBody', 'message'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fields';
        _fields?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ErrorBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
