// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_count_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnreadCountDto extends UnreadCountDto {
  @override
  final num count;

  factory _$UnreadCountDto([void Function(UnreadCountDtoBuilder)? updates]) =>
      (UnreadCountDtoBuilder()..update(updates))._build();

  _$UnreadCountDto._({required this.count}) : super._();
  @override
  UnreadCountDto rebuild(void Function(UnreadCountDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnreadCountDtoBuilder toBuilder() => UnreadCountDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnreadCountDto && count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnreadCountDto')..add('count', count))
        .toString();
  }
}

class UnreadCountDtoBuilder
    implements Builder<UnreadCountDto, UnreadCountDtoBuilder> {
  _$UnreadCountDto? _$v;

  num? _count;
  num? get count => _$this._count;
  set count(num? count) => _$this._count = count;

  UnreadCountDtoBuilder() {
    UnreadCountDto._defaults(this);
  }

  UnreadCountDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnreadCountDto other) {
    _$v = other as _$UnreadCountDto;
  }

  @override
  void update(void Function(UnreadCountDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnreadCountDto build() => _build();

  _$UnreadCountDto _build() {
    final _$result = _$v ??
        _$UnreadCountDto._(
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'UnreadCountDto', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
