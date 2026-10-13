// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_upload_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AvatarUploadBody extends AvatarUploadBody {
  @override
  final AvatarType contentType;
  @override
  final num size;

  factory _$AvatarUploadBody(
          [void Function(AvatarUploadBodyBuilder)? updates]) =>
      (AvatarUploadBodyBuilder()..update(updates))._build();

  _$AvatarUploadBody._({required this.contentType, required this.size})
      : super._();
  @override
  AvatarUploadBody rebuild(void Function(AvatarUploadBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AvatarUploadBodyBuilder toBuilder() =>
      AvatarUploadBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AvatarUploadBody &&
        contentType == other.contentType &&
        size == other.size;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AvatarUploadBody')
          ..add('contentType', contentType)
          ..add('size', size))
        .toString();
  }
}

class AvatarUploadBodyBuilder
    implements Builder<AvatarUploadBody, AvatarUploadBodyBuilder> {
  _$AvatarUploadBody? _$v;

  AvatarType? _contentType;
  AvatarType? get contentType => _$this._contentType;
  set contentType(AvatarType? contentType) => _$this._contentType = contentType;

  num? _size;
  num? get size => _$this._size;
  set size(num? size) => _$this._size = size;

  AvatarUploadBodyBuilder() {
    AvatarUploadBody._defaults(this);
  }

  AvatarUploadBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _size = $v.size;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AvatarUploadBody other) {
    _$v = other as _$AvatarUploadBody;
  }

  @override
  void update(void Function(AvatarUploadBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AvatarUploadBody build() => _build();

  _$AvatarUploadBody _build() {
    final _$result = _$v ??
        _$AvatarUploadBody._(
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'AvatarUploadBody', 'contentType'),
          size: BuiltValueNullFieldError.checkNotNull(
              size, r'AvatarUploadBody', 'size'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
