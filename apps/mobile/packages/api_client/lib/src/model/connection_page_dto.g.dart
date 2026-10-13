// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConnectionPageDto extends ConnectionPageDto {
  @override
  final BuiltList<ConnectionDto> items;
  @override
  final String? nextCursor;

  factory _$ConnectionPageDto(
          [void Function(ConnectionPageDtoBuilder)? updates]) =>
      (ConnectionPageDtoBuilder()..update(updates))._build();

  _$ConnectionPageDto._({required this.items, this.nextCursor}) : super._();
  @override
  ConnectionPageDto rebuild(void Function(ConnectionPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConnectionPageDtoBuilder toBuilder() =>
      ConnectionPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConnectionPageDto &&
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
    return (newBuiltValueToStringHelper(r'ConnectionPageDto')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class ConnectionPageDtoBuilder
    implements Builder<ConnectionPageDto, ConnectionPageDtoBuilder> {
  _$ConnectionPageDto? _$v;

  ListBuilder<ConnectionDto>? _items;
  ListBuilder<ConnectionDto> get items =>
      _$this._items ??= ListBuilder<ConnectionDto>();
  set items(ListBuilder<ConnectionDto>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  ConnectionPageDtoBuilder() {
    ConnectionPageDto._defaults(this);
  }

  ConnectionPageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConnectionPageDto other) {
    _$v = other as _$ConnectionPageDto;
  }

  @override
  void update(void Function(ConnectionPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConnectionPageDto build() => _build();

  _$ConnectionPageDto _build() {
    _$ConnectionPageDto _$result;
    try {
      _$result = _$v ??
          _$ConnectionPageDto._(
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
            r'ConnectionPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
