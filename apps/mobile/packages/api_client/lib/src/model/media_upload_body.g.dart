// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MediaUploadBody extends MediaUploadBody {
  @override
  final MediaContentType contentType;
  @override
  final num size;

  factory _$MediaUploadBody([void Function(MediaUploadBodyBuilder)? updates]) =>
      (MediaUploadBodyBuilder()..update(updates))._build();

  _$MediaUploadBody._({required this.contentType, required this.size})
      : super._();
  @override
  MediaUploadBody rebuild(void Function(MediaUploadBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaUploadBodyBuilder toBuilder() => MediaUploadBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaUploadBody &&
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
    return (newBuiltValueToStringHelper(r'MediaUploadBody')
          ..add('contentType', contentType)
          ..add('size', size))
        .toString();
  }
}

class MediaUploadBodyBuilder
    implements Builder<MediaUploadBody, MediaUploadBodyBuilder> {
  _$MediaUploadBody? _$v;

  MediaContentType? _contentType;
  MediaContentType? get contentType => _$this._contentType;
  set contentType(MediaContentType? contentType) =>
      _$this._contentType = contentType;

  num? _size;
  num? get size => _$this._size;
  set size(num? size) => _$this._size = size;

  MediaUploadBodyBuilder() {
    MediaUploadBody._defaults(this);
  }

  MediaUploadBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contentType = $v.contentType;
      _size = $v.size;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaUploadBody other) {
    _$v = other as _$MediaUploadBody;
  }

  @override
  void update(void Function(MediaUploadBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaUploadBody build() => _build();

  _$MediaUploadBody _build() {
    final _$result = _$v ??
        _$MediaUploadBody._(
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'MediaUploadBody', 'contentType'),
          size: BuiltValueNullFieldError.checkNotNull(
              size, r'MediaUploadBody', 'size'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
