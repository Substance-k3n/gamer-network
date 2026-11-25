// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_number_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUserNumberPageDto extends AdminUserNumberPageDto {
  @override
  final BuiltList<AdminUserDto> items;
  @override
  final num total;
  @override
  final num page;
  @override
  final num pageSize;

  factory _$AdminUserNumberPageDto(
          [void Function(AdminUserNumberPageDtoBuilder)? updates]) =>
      (AdminUserNumberPageDtoBuilder()..update(updates))._build();

  _$AdminUserNumberPageDto._(
      {required this.items,
      required this.total,
      required this.page,
      required this.pageSize})
      : super._();
  @override
  AdminUserNumberPageDto rebuild(
          void Function(AdminUserNumberPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminUserNumberPageDtoBuilder toBuilder() =>
      AdminUserNumberPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUserNumberPageDto &&
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
    return (newBuiltValueToStringHelper(r'AdminUserNumberPageDto')
          ..add('items', items)
          ..add('total', total)
          ..add('page', page)
          ..add('pageSize', pageSize))
        .toString();
  }
}

class AdminUserNumberPageDtoBuilder
    implements Builder<AdminUserNumberPageDto, AdminUserNumberPageDtoBuilder> {
  _$AdminUserNumberPageDto? _$v;

  ListBuilder<AdminUserDto>? _items;
  ListBuilder<AdminUserDto> get items =>
      _$this._items ??= ListBuilder<AdminUserDto>();
  set items(ListBuilder<AdminUserDto>? items) => _$this._items = items;

  num? _total;
  num? get total => _$this._total;
  set total(num? total) => _$this._total = total;

  num? _page;
  num? get page => _$this._page;
  set page(num? page) => _$this._page = page;

  num? _pageSize;
  num? get pageSize => _$this._pageSize;
  set pageSize(num? pageSize) => _$this._pageSize = pageSize;

  AdminUserNumberPageDtoBuilder() {
    AdminUserNumberPageDto._defaults(this);
  }

  AdminUserNumberPageDtoBuilder get _$this {
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
  void replace(AdminUserNumberPageDto other) {
    _$v = other as _$AdminUserNumberPageDto;
  }

  @override
  void update(void Function(AdminUserNumberPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUserNumberPageDto build() => _build();

  _$AdminUserNumberPageDto _build() {
    _$AdminUserNumberPageDto _$result;
    try {
      _$result = _$v ??
          _$AdminUserNumberPageDto._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminUserNumberPageDto', 'total'),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'AdminUserNumberPageDto', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'AdminUserNumberPageDto', 'pageSize'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminUserNumberPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
