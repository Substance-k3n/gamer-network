// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_stats_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingStatsDto extends ListingStatsDto {
  @override
  final num lookingNow;

  factory _$ListingStatsDto([void Function(ListingStatsDtoBuilder)? updates]) =>
      (ListingStatsDtoBuilder()..update(updates))._build();

  _$ListingStatsDto._({required this.lookingNow}) : super._();
  @override
  ListingStatsDto rebuild(void Function(ListingStatsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingStatsDtoBuilder toBuilder() => ListingStatsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingStatsDto && lookingNow == other.lookingNow;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lookingNow.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingStatsDto')
          ..add('lookingNow', lookingNow))
        .toString();
  }
}

class ListingStatsDtoBuilder
    implements Builder<ListingStatsDto, ListingStatsDtoBuilder> {
  _$ListingStatsDto? _$v;

  num? _lookingNow;
  num? get lookingNow => _$this._lookingNow;
  set lookingNow(num? lookingNow) => _$this._lookingNow = lookingNow;

  ListingStatsDtoBuilder() {
    ListingStatsDto._defaults(this);
  }

  ListingStatsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lookingNow = $v.lookingNow;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingStatsDto other) {
    _$v = other as _$ListingStatsDto;
  }

  @override
  void update(void Function(ListingStatsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingStatsDto build() => _build();

  _$ListingStatsDto _build() {
    final _$result = _$v ??
        _$ListingStatsDto._(
          lookingNow: BuiltValueNullFieldError.checkNotNull(
              lookingNow, r'ListingStatsDto', 'lookingNow'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
