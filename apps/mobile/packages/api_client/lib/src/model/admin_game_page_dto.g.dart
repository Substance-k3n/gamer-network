// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_game_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminGamePageDto extends AdminGamePageDto {
  @override
  final BuiltList<AdminGameDto> items;
  @override
  final num total;
  @override
  final num page;
  @override
  final num pageSize;

  factory _$AdminGamePageDto(
          [void Function(AdminGamePageDtoBuilder)? updates]) =>
      (AdminGamePageDtoBuilder()..update(updates))._build();

  _$AdminGamePageDto._(
      {required this.items,
      required this.total,
      required this.page,
      required this.pageSize})
      : super._();
  @override
  AdminGamePageDto rebuild(void Function(AdminGamePageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminGamePageDtoBuilder toBuilder() =>
      AdminGamePageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminGamePageDto &&
        items == other.items &&
        total == other.total &&
        page == other.page &&
        pageSize == other.pageSize;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, pageSize.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminGamePageDto')
          ..add('items', items)
          ..add('total', total)
          ..add('page', page)
          ..add('pageSize', pageSize))
        .toString();
  }
}

class AdminGamePageDtoBuilder
    implements Builder<AdminGamePageDto, AdminGamePageDtoBuilder> {
  _$AdminGamePageDto? _$v;

  ListBuilder<AdminGameDto>? _items;
  ListBuilder<AdminGameDto> get items =>
      _$this._items ??= ListBuilder<AdminGameDto>();
  set items(ListBuilder<AdminGameDto>? items) => _$this._items = items;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  AdminGamePageDtoBuilder() {
    AdminGamePageDto._defaults(this);
  }

  AdminGamePageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _page = $v.page;
      _pageSize = $v.pageSize;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminGamePageDto other) {
    _$v = other as _$AdminGamePageDto;
  }

  @override
  void update(void Function(AdminGamePageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminGamePageDto build() => _build();

  _$AdminGamePageDto _build() {
    _$AdminGamePageDto _$result;
    try {
      _$result = _$v ??
          _$AdminGamePageDto._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminGamePageDto', 'total'),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'AdminGamePageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'AdminGamePageDto', 'pageSize'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminGamePageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
