// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metrics_day_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MetricsDayDto extends MetricsDayDto {
  @override
  final String day;
  @override
  final num signups;
  @override
  final num listings;
  @override
  final num posts;
  @override
  final num played;

  factory _$MetricsDayDto([void Function(MetricsDayDtoBuilder)? updates]) =>
      (MetricsDayDtoBuilder()..update(updates))._build();

  _$MetricsDayDto._(
      {required this.day,
      required this.signups,
      required this.listings,
      required this.posts,
      required this.played})
      : super._();
  @override
  MetricsDayDto rebuild(void Function(MetricsDayDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MetricsDayDtoBuilder toBuilder() => MetricsDayDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MetricsDayDto &&
        day == other.day &&
        signups == other.signups &&
        listings == other.listings &&
        posts == other.posts &&
        played == other.played;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, day.hashCode);
    _$hash = $jc(_$hash, signups.hashCode);
    _$hash = $jc(_$hash, listings.hashCode);
    _$hash = $jc(_$hash, posts.hashCode);
    _$hash = $jc(_$hash, played.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MetricsDayDto')
          ..add('day', day)
          ..add('signups', signups)
          ..add('listings', listings)
          ..add('posts', posts)
          ..add('played', played))
        .toString();
  }
}

class MetricsDayDtoBuilder
    implements Builder<MetricsDayDto, MetricsDayDtoBuilder> {
  _$MetricsDayDto? _$v;

  String? _day;
  String? get day => _$this._day;
  set day(String? day) => _$this._day = day;

  num? _signups;
  num? get signups => _$this._signups;
  set signups(num? signups) => _$this._signups = signups;

  num? _listings;
  num? get listings => _$this._listings;
  set listings(num? listings) => _$this._listings = listings;

  num? _posts;
  num? get posts => _$this._posts;
  set posts(num? posts) => _$this._posts = posts;

  num? _played;
  num? get played => _$this._played;
  set played(num? played) => _$this._played = played;

  MetricsDayDtoBuilder() {
    MetricsDayDto._defaults(this);
  }

  MetricsDayDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _day = $v.day;
      _signups = $v.signups;
      _listings = $v.listings;
      _posts = $v.posts;
      _played = $v.played;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MetricsDayDto other) {
    _$v = other as _$MetricsDayDto;
  }

  @override
  void update(void Function(MetricsDayDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MetricsDayDto build() => _build();

  _$MetricsDayDto _build() {
    final _$result = _$v ??
        _$MetricsDayDto._(
          day: BuiltValueNullFieldError.checkNotNull(
              day, r'MetricsDayDto', 'day'),
          signups: BuiltValueNullFieldError.checkNotNull(
              signups, r'MetricsDayDto', 'signups'),
          listings: BuiltValueNullFieldError.checkNotNull(
              listings, r'MetricsDayDto', 'listings'),
          posts: BuiltValueNullFieldError.checkNotNull(
              posts, r'MetricsDayDto', 'posts'),
          played: BuiltValueNullFieldError.checkNotNull(
              played, r'MetricsDayDto', 'played'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
