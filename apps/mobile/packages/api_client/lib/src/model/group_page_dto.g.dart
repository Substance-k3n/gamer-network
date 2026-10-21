// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupPageDto extends GroupPageDto {
  @override
  final BuiltList<GroupDto> items;
  @override
  final String? nextCursor;

  factory _$GroupPageDto([void Function(GroupPageDtoBuilder)? updates]) =>
      (GroupPageDtoBuilder()..update(updates))._build();

  _$GroupPageDto._({required this.items, this.nextCursor}) : super._();
  @override
  GroupPageDto rebuild(void Function(GroupPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupPageDtoBuilder toBuilder() => GroupPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupPageDto &&
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
    return (newBuiltValueToStringHelper(r'GroupPageDto')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class GroupPageDtoBuilder
    implements Builder<GroupPageDto, GroupPageDtoBuilder> {
  _$GroupPageDto? _$v;

  ListBuilder<GroupDto>? _items;
  ListBuilder<GroupDto> get items => _$this._items ??= ListBuilder<GroupDto>();
  set items(ListBuilder<GroupDto>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  GroupPageDtoBuilder() {
    GroupPageDto._defaults(this);
  }

  GroupPageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupPageDto other) {
    _$v = other as _$GroupPageDto;
  }

  @override
  void update(void Function(GroupPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupPageDto build() => _build();

  _$GroupPageDto _build() {
    _$GroupPageDto _$result;
    try {
      _$result = _$v ??
          _$GroupPageDto._(
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
            r'GroupPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
