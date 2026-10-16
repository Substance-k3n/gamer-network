// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metrics_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MetricsDto extends MetricsDto {
  @override
  final DateTime from;
  @override
  final DateTime to;
  @override
  final num listings;
  @override
  final num listingsWithRequest;
  @override
  final num listingsPlayed;
  @override
  final num playedRate;
  @override
  final num weeklyActive;
  @override
  final BuiltList<WaitlistCountDto> waitlist;

  factory _$MetricsDto([void Function(MetricsDtoBuilder)? updates]) =>
      (MetricsDtoBuilder()..update(updates))._build();

  _$MetricsDto._(
      {required this.from,
      required this.to,
      required this.listings,
      required this.listingsWithRequest,
      required this.listingsPlayed,
      required this.playedRate,
      required this.weeklyActive,
      required this.waitlist})
      : super._();
  @override
  MetricsDto rebuild(void Function(MetricsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MetricsDtoBuilder toBuilder() => MetricsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MetricsDto &&
        from == other.from &&
        to == other.to &&
        listings == other.listings &&
        listingsWithRequest == other.listingsWithRequest &&
        listingsPlayed == other.listingsPlayed &&
        playedRate == other.playedRate &&
        weeklyActive == other.weeklyActive &&
        waitlist == other.waitlist;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, listings.hashCode);
    _$hash = $jc(_$hash, listingsWithRequest.hashCode);
    _$hash = $jc(_$hash, listingsPlayed.hashCode);
    _$hash = $jc(_$hash, playedRate.hashCode);
    _$hash = $jc(_$hash, weeklyActive.hashCode);
    _$hash = $jc(_$hash, waitlist.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MetricsDto')
          ..add('from', from)
          ..add('to', to)
          ..add('listings', listings)
          ..add('listingsWithRequest', listingsWithRequest)
          ..add('listingsPlayed', listingsPlayed)
          ..add('playedRate', playedRate)
          ..add('weeklyActive', weeklyActive)
          ..add('waitlist', waitlist))
        .toString();
  }
}

class MetricsDtoBuilder implements Builder<MetricsDto, MetricsDtoBuilder> {
  _$MetricsDto? _$v;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  DateTime? _to;
  DateTime? get to => _$this._to;
  set to(DateTime? to) => _$this._to = to;

  num? _listings;
  num? get listings => _$this._listings;
  set listings(num? listings) => _$this._listings = listings;

  num? _listingsWithRequest;
  num? get listingsWithRequest => _$this._listingsWithRequest;
  set listingsWithRequest(num? listingsWithRequest) =>
      _$this._listingsWithRequest = listingsWithRequest;

  num? _listingsPlayed;
  num? get listingsPlayed => _$this._listingsPlayed;
  set listingsPlayed(num? listingsPlayed) =>
      _$this._listingsPlayed = listingsPlayed;

  num? _playedRate;
  num? get playedRate => _$this._playedRate;
  set playedRate(num? playedRate) => _$this._playedRate = playedRate;

  num? _weeklyActive;
  num? get weeklyActive => _$this._weeklyActive;
  set weeklyActive(num? weeklyActive) => _$this._weeklyActive = weeklyActive;

  ListBuilder<WaitlistCountDto>? _waitlist;
  ListBuilder<WaitlistCountDto> get waitlist =>
      _$this._waitlist ??= ListBuilder<WaitlistCountDto>();
  set waitlist(ListBuilder<WaitlistCountDto>? waitlist) =>
      _$this._waitlist = waitlist;

  MetricsDtoBuilder() {
    MetricsDto._defaults(this);
  }

  MetricsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _listings = $v.listings;
      _listingsWithRequest = $v.listingsWithRequest;
      _listingsPlayed = $v.listingsPlayed;
      _playedRate = $v.playedRate;
      _weeklyActive = $v.weeklyActive;
      _waitlist = $v.waitlist.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MetricsDto other) {
    _$v = other as _$MetricsDto;
  }

  @override
  void update(void Function(MetricsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MetricsDto build() => _build();

  _$MetricsDto _build() {
    _$MetricsDto _$result;
    try {
      _$result = _$v ??
          _$MetricsDto._(
            from: BuiltValueNullFieldError.checkNotNull(
                from, r'MetricsDto', 'from'),
            to: BuiltValueNullFieldError.checkNotNull(to, r'MetricsDto', 'to'),
            listings: BuiltValueNullFieldError.checkNotNull(
                listings, r'MetricsDto', 'listings'),
            listingsWithRequest: BuiltValueNullFieldError.checkNotNull(
                listingsWithRequest, r'MetricsDto', 'listingsWithRequest'),
            listingsPlayed: BuiltValueNullFieldError.checkNotNull(
                listingsPlayed, r'MetricsDto', 'listingsPlayed'),
            playedRate: BuiltValueNullFieldError.checkNotNull(
                playedRate, r'MetricsDto', 'playedRate'),
            weeklyActive: BuiltValueNullFieldError.checkNotNull(
                weeklyActive, r'MetricsDto', 'weeklyActive'),
            waitlist: waitlist.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'waitlist';
        waitlist.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MetricsDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
