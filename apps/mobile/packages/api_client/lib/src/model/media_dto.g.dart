// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MediaDto extends MediaDto {
  @override
  final MediaKind kind;
  @override
  final String id;
  @override
  final String url;
  @override
  final String? posterUrl;
  @override
  final num? width;
  @override
  final num? height;
  @override
  final num? durationMs;

  factory _$MediaDto([void Function(MediaDtoBuilder)? updates]) =>
      (MediaDtoBuilder()..update(updates))._build();

  _$MediaDto._(
      {required this.kind,
      required this.id,
      required this.url,
      this.posterUrl,
      this.width,
      this.height,
      this.durationMs})
      : super._();
  @override
  MediaDto rebuild(void Function(MediaDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaDtoBuilder toBuilder() => MediaDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaDto &&
        kind == other.kind &&
        id == other.id &&
        url == other.url &&
        posterUrl == other.posterUrl &&
        width == other.width &&
        height == other.height &&
        durationMs == other.durationMs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, posterUrl.hashCode);
    _$hash = $jc(_$hash, width.hashCode);
    _$hash = $jc(_$hash, height.hashCode);
    _$hash = $jc(_$hash, durationMs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediaDto')
          ..add('kind', kind)
          ..add('id', id)
          ..add('url', url)
          ..add('posterUrl', posterUrl)
          ..add('width', width)
          ..add('height', height)
          ..add('durationMs', durationMs))
        .toString();
  }
}

class MediaDtoBuilder implements Builder<MediaDto, MediaDtoBuilder> {
  _$MediaDto? _$v;

  MediaKind? _kind;
  MediaKind? get kind => _$this._kind;
  set kind(MediaKind? kind) => _$this._kind = kind;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _posterUrl;
  String? get posterUrl => _$this._posterUrl;
  set posterUrl(String? posterUrl) => _$this._posterUrl = posterUrl;

  num? _width;
  num? get width => _$this._width;
  set width(num? width) => _$this._width = width;

  num? _height;
  num? get height => _$this._height;
  set height(num? height) => _$this._height = height;

  num? _durationMs;
  num? get durationMs => _$this._durationMs;
  set durationMs(num? durationMs) => _$this._durationMs = durationMs;

  MediaDtoBuilder() {
    MediaDto._defaults(this);
  }

  MediaDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _id = $v.id;
      _url = $v.url;
      _posterUrl = $v.posterUrl;
      _width = $v.width;
      _height = $v.height;
      _durationMs = $v.durationMs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaDto other) {
    _$v = other as _$MediaDto;
  }

  @override
  void update(void Function(MediaDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaDto build() => _build();

  _$MediaDto _build() {
    final _$result = _$v ??
        _$MediaDto._(
          kind:
              BuiltValueNullFieldError.checkNotNull(kind, r'MediaDto', 'kind'),
          id: BuiltValueNullFieldError.checkNotNull(id, r'MediaDto', 'id'),
          url: BuiltValueNullFieldError.checkNotNull(url, r'MediaDto', 'url'),
          posterUrl: posterUrl,
          width: width,
          height: height,
          durationMs: durationMs,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
