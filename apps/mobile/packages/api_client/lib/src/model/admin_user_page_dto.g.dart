// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUserPageDto extends AdminUserPageDto {
  @override
  final BuiltList<AdminUserDto> items;
  @override
  final String? nextCursor;

  factory _$AdminUserPageDto(
          [void Function(AdminUserPageDtoBuilder)? updates]) =>
      (AdminUserPageDtoBuilder()..update(updates))._build();

  _$AdminUserPageDto._({required this.items, this.nextCursor}) : super._();
  @override
  AdminUserPageDto rebuild(void Function(AdminUserPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminUserPageDtoBuilder toBuilder() =>
      AdminUserPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUserPageDto &&
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
    return (newBuiltValueToStringHelper(r'AdminUserPageDto')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AdminUserPageDtoBuilder
    implements Builder<AdminUserPageDto, AdminUserPageDtoBuilder> {
  _$AdminUserPageDto? _$v;

  ListBuilder<AdminUserDto>? _items;
  ListBuilder<AdminUserDto> get items =>
      _$this._items ??= ListBuilder<AdminUserDto>();
  set items(ListBuilder<AdminUserDto>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminUserPageDtoBuilder() {
    AdminUserPageDto._defaults(this);
  }

  AdminUserPageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUserPageDto other) {
    _$v = other as _$AdminUserPageDto;
  }

  @override
  void update(void Function(AdminUserPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUserPageDto build() => _build();

  _$AdminUserPageDto _build() {
    _$AdminUserPageDto _$result;
    try {
      _$result = _$v ??
          _$AdminUserPageDto._(
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
            r'AdminUserPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
