// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MediaUploadDto extends MediaUploadDto {
  @override
  final String uploadUrl;
  @override
  final BuiltMap<String, String> headers;
  @override
  final String key;
  @override
  final DateTime expiresAt;

  factory _$MediaUploadDto([void Function(MediaUploadDtoBuilder)? updates]) =>
      (MediaUploadDtoBuilder()..update(updates))._build();

  _$MediaUploadDto._(
      {required this.uploadUrl,
      required this.headers,
      required this.key,
      required this.expiresAt})
      : super._();
  @override
  MediaUploadDto rebuild(void Function(MediaUploadDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaUploadDtoBuilder toBuilder() => MediaUploadDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaUploadDto &&
        uploadUrl == other.uploadUrl &&
        headers == other.headers &&
        key == other.key &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, uploadUrl.hashCode);
    _$hash = $jc(_$hash, headers.hashCode);
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediaUploadDto')
          ..add('uploadUrl', uploadUrl)
          ..add('headers', headers)
          ..add('key', key)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class MediaUploadDtoBuilder
    implements Builder<MediaUploadDto, MediaUploadDtoBuilder> {
  _$MediaUploadDto? _$v;

  String? _uploadUrl;
  String? get uploadUrl => _$this._uploadUrl;
  set uploadUrl(String? uploadUrl) => _$this._uploadUrl = uploadUrl;

  MapBuilder<String, String>? _headers;
  MapBuilder<String, String> get headers =>
      _$this._headers ??= MapBuilder<String, String>();
  set headers(MapBuilder<String, String>? headers) => _$this._headers = headers;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  MediaUploadDtoBuilder() {
    MediaUploadDto._defaults(this);
  }

  MediaUploadDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uploadUrl = $v.uploadUrl;
      _headers = $v.headers.toBuilder();
      _key = $v.key;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaUploadDto other) {
    _$v = other as _$MediaUploadDto;
  }

  @override
  void update(void Function(MediaUploadDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaUploadDto build() => _build();

  _$MediaUploadDto _build() {
    _$MediaUploadDto _$result;
    try {
      _$result = _$v ??
          _$MediaUploadDto._(
            uploadUrl: BuiltValueNullFieldError.checkNotNull(
                uploadUrl, r'MediaUploadDto', 'uploadUrl'),
            headers: headers.build(),
            key: BuiltValueNullFieldError.checkNotNull(
                key, r'MediaUploadDto', 'key'),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'MediaUploadDto', 'expiresAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'headers';
        headers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MediaUploadDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
