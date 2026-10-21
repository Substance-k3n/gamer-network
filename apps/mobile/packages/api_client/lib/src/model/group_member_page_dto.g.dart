// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupMemberPageDto extends GroupMemberPageDto {
  @override
  final BuiltList<GroupMemberDto> items;
  @override
  final String? nextCursor;

  factory _$GroupMemberPageDto(
          [void Function(GroupMemberPageDtoBuilder)? updates]) =>
      (GroupMemberPageDtoBuilder()..update(updates))._build();

  _$GroupMemberPageDto._({required this.items, this.nextCursor}) : super._();
  @override
  GroupMemberPageDto rebuild(
          void Function(GroupMemberPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupMemberPageDtoBuilder toBuilder() =>
      GroupMemberPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupMemberPageDto &&
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
    return (newBuiltValueToStringHelper(r'GroupMemberPageDto')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class GroupMemberPageDtoBuilder
    implements Builder<GroupMemberPageDto, GroupMemberPageDtoBuilder> {
  _$GroupMemberPageDto? _$v;

  ListBuilder<GroupMemberDto>? _items;
  ListBuilder<GroupMemberDto> get items =>
      _$this._items ??= ListBuilder<GroupMemberDto>();
  set items(ListBuilder<GroupMemberDto>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  GroupMemberPageDtoBuilder() {
    GroupMemberPageDto._defaults(this);
  }

  GroupMemberPageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupMemberPageDto other) {
    _$v = other as _$GroupMemberPageDto;
  }

  @override
  void update(void Function(GroupMemberPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupMemberPageDto build() => _build();

  _$GroupMemberPageDto _build() {
    _$GroupMemberPageDto _$result;
    try {
      _$result = _$v ??
          _$GroupMemberPageDto._(
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
            r'GroupMemberPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
