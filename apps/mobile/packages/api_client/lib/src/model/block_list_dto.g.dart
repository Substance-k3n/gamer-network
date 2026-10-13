// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_list_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BlockListDto extends BlockListDto {
  @override
  final BuiltList<UserCardDto> items;

  factory _$BlockListDto([void Function(BlockListDtoBuilder)? updates]) =>
      (BlockListDtoBuilder()..update(updates))._build();

  _$BlockListDto._({required this.items}) : super._();
  @override
  BlockListDto rebuild(void Function(BlockListDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BlockListDtoBuilder toBuilder() => BlockListDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlockListDto && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BlockListDto')..add('items', items))
        .toString();
  }
}

class BlockListDtoBuilder
    implements Builder<BlockListDto, BlockListDtoBuilder> {
  _$BlockListDto? _$v;

  ListBuilder<UserCardDto>? _items;
  ListBuilder<UserCardDto> get items =>
      _$this._items ??= ListBuilder<UserCardDto>();
  set items(ListBuilder<UserCardDto>? items) => _$this._items = items;

  BlockListDtoBuilder() {
    BlockListDto._defaults(this);
  }

  BlockListDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlockListDto other) {
    _$v = other as _$BlockListDto;
  }

  @override
  void update(void Function(BlockListDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlockListDto build() => _build();

  _$BlockListDto _build() {
    _$BlockListDto _$result;
    try {
      _$result = _$v ??
          _$BlockListDto._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BlockListDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
