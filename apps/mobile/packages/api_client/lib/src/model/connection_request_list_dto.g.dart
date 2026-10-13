// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_request_list_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConnectionRequestListDto extends ConnectionRequestListDto {
  @override
  final BuiltList<ConnectionRequestDto> items;

  factory _$ConnectionRequestListDto(
          [void Function(ConnectionRequestListDtoBuilder)? updates]) =>
      (ConnectionRequestListDtoBuilder()..update(updates))._build();

  _$ConnectionRequestListDto._({required this.items}) : super._();
  @override
  ConnectionRequestListDto rebuild(
          void Function(ConnectionRequestListDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConnectionRequestListDtoBuilder toBuilder() =>
      ConnectionRequestListDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConnectionRequestListDto && items == other.items;
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
    return (newBuiltValueToStringHelper(r'ConnectionRequestListDto')
          ..add('items', items))
        .toString();
  }
}

class ConnectionRequestListDtoBuilder
    implements
        Builder<ConnectionRequestListDto, ConnectionRequestListDtoBuilder> {
  _$ConnectionRequestListDto? _$v;

  ListBuilder<ConnectionRequestDto>? _items;
  ListBuilder<ConnectionRequestDto> get items =>
      _$this._items ??= ListBuilder<ConnectionRequestDto>();
  set items(ListBuilder<ConnectionRequestDto>? items) => _$this._items = items;

  ConnectionRequestListDtoBuilder() {
    ConnectionRequestListDto._defaults(this);
  }

  ConnectionRequestListDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConnectionRequestListDto other) {
    _$v = other as _$ConnectionRequestListDto;
  }

  @override
  void update(void Function(ConnectionRequestListDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConnectionRequestListDto build() => _build();

  _$ConnectionRequestListDto _build() {
    _$ConnectionRequestListDto _$result;
    try {
      _$result = _$v ??
          _$ConnectionRequestListDto._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ConnectionRequestListDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
