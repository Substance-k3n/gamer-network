// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waitlist_count_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WaitlistCountDto extends WaitlistCountDto {
  @override
  final String topic;
  @override
  final num count;

  factory _$WaitlistCountDto(
          [void Function(WaitlistCountDtoBuilder)? updates]) =>
      (WaitlistCountDtoBuilder()..update(updates))._build();

  _$WaitlistCountDto._({required this.topic, required this.count}) : super._();
  @override
  WaitlistCountDto rebuild(void Function(WaitlistCountDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WaitlistCountDtoBuilder toBuilder() =>
      WaitlistCountDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WaitlistCountDto &&
        topic == other.topic &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, topic.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WaitlistCountDto')
          ..add('topic', topic)
          ..add('count', count))
        .toString();
  }
}

class WaitlistCountDtoBuilder
    implements Builder<WaitlistCountDto, WaitlistCountDtoBuilder> {
  _$WaitlistCountDto? _$v;

  String? _topic;
  String? get topic => _$this._topic;
  set topic(String? topic) => _$this._topic = topic;

  num? _count;
  num? get count => _$this._count;
  set count(num? count) => _$this._count = count;

  WaitlistCountDtoBuilder() {
    WaitlistCountDto._defaults(this);
  }

  WaitlistCountDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _topic = $v.topic;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WaitlistCountDto other) {
    _$v = other as _$WaitlistCountDto;
  }

  @override
  void update(void Function(WaitlistCountDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WaitlistCountDto build() => _build();

  _$WaitlistCountDto _build() {
    final _$result = _$v ??
        _$WaitlistCountDto._(
          topic: BuiltValueNullFieldError.checkNotNull(
              topic, r'WaitlistCountDto', 'topic'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'WaitlistCountDto', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
