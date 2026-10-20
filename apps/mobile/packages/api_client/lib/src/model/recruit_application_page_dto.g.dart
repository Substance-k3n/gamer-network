// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_application_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecruitApplicationPageDto extends RecruitApplicationPageDto {
  @override
  final BuiltList<RecruitApplicationDto> items;
  @override
  final String? nextCursor;

  factory _$RecruitApplicationPageDto(
          [void Function(RecruitApplicationPageDtoBuilder)? updates]) =>
      (RecruitApplicationPageDtoBuilder()..update(updates))._build();

  _$RecruitApplicationPageDto._({required this.items, this.nextCursor})
      : super._();
  @override
  RecruitApplicationPageDto rebuild(
          void Function(RecruitApplicationPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecruitApplicationPageDtoBuilder toBuilder() =>
      RecruitApplicationPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecruitApplicationPageDto &&
        items == other.items &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecruitApplicationPageDto')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class RecruitApplicationPageDtoBuilder
    implements
        Builder<RecruitApplicationPageDto, RecruitApplicationPageDtoBuilder> {
  _$RecruitApplicationPageDto? _$v;

  ListBuilder<RecruitApplicationDto>? _items;
  ListBuilder<RecruitApplicationDto> get items =>
      _$this._items ??= ListBuilder<RecruitApplicationDto>();
  set items(ListBuilder<RecruitApplicationDto>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  RecruitApplicationPageDtoBuilder() {
    RecruitApplicationPageDto._defaults(this);
  }

  RecruitApplicationPageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecruitApplicationPageDto other) {
    _$v = other as _$RecruitApplicationPageDto;
  }

  @override
  void update(void Function(RecruitApplicationPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecruitApplicationPageDto build() => _build();

  _$RecruitApplicationPageDto _build() {
    _$RecruitApplicationPageDto _$result;
    try {
      _$result = _$v ??
          _$RecruitApplicationPageDto._(
            items: items.build(),
            nextCursor: nextCursor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RecruitApplicationPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
