// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_event_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupEventPageDto extends GroupEventPageDto {
  @override
  final BuiltList<GroupEventDto> items;
  @override
  final String? nextCursor;

  factory _$GroupEventPageDto(
          [void Function(GroupEventPageDtoBuilder)? updates]) =>
      (GroupEventPageDtoBuilder()..update(updates))._build();

  _$GroupEventPageDto._({required this.items, this.nextCursor}) : super._();
  @override
  GroupEventPageDto rebuild(void Function(GroupEventPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupEventPageDtoBuilder toBuilder() =>
      GroupEventPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupEventPageDto &&
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
    return (newBuiltValueToStringHelper(r'GroupEventPageDto')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class GroupEventPageDtoBuilder
    implements Builder<GroupEventPageDto, GroupEventPageDtoBuilder> {
  _$GroupEventPageDto? _$v;

  ListBuilder<GroupEventDto>? _items;
  ListBuilder<GroupEventDto> get items =>
      _$this._items ??= ListBuilder<GroupEventDto>();
  set items(ListBuilder<GroupEventDto>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  GroupEventPageDtoBuilder() {
    GroupEventPageDto._defaults(this);
  }

  GroupEventPageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupEventPageDto other) {
    _$v = other as _$GroupEventPageDto;
  }

  @override
  void update(void Function(GroupEventPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupEventPageDto build() => _build();

  _$GroupEventPageDto _build() {
    _$GroupEventPageDto _$result;
    try {
      _$result = _$v ??
          _$GroupEventPageDto._(
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
            r'GroupEventPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
