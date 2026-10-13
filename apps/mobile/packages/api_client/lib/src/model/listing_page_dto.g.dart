// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingPageDto extends ListingPageDto {
  @override
  final BuiltList<ListingDto> items;
  @override
  final String? nextCursor;

  factory _$ListingPageDto([void Function(ListingPageDtoBuilder)? updates]) =>
      (ListingPageDtoBuilder()..update(updates))._build();

  _$ListingPageDto._({required this.items, this.nextCursor}) : super._();
  @override
  ListingPageDto rebuild(void Function(ListingPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingPageDtoBuilder toBuilder() => ListingPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingPageDto &&
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
    return (newBuiltValueToStringHelper(r'ListingPageDto')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class ListingPageDtoBuilder
    implements Builder<ListingPageDto, ListingPageDtoBuilder> {
  _$ListingPageDto? _$v;

  ListBuilder<ListingDto>? _items;
  ListBuilder<ListingDto> get items =>
      _$this._items ??= ListBuilder<ListingDto>();
  set items(ListBuilder<ListingDto>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  ListingPageDtoBuilder() {
    ListingPageDto._defaults(this);
  }

  ListingPageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingPageDto other) {
    _$v = other as _$ListingPageDto;
  }

  @override
  void update(void Function(ListingPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingPageDto build() => _build();

  _$ListingPageDto _build() {
    _$ListingPageDto _$result;
    try {
      _$result = _$v ??
          _$ListingPageDto._(
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
            r'ListingPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
