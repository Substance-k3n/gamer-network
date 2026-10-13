// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_list_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckInListDto extends CheckInListDto {
  @override
  final BuiltList<CheckInDto> items;

  factory _$CheckInListDto([void Function(CheckInListDtoBuilder)? updates]) =>
      (CheckInListDtoBuilder()..update(updates))._build();

  _$CheckInListDto._({required this.items}) : super._();
  @override
  CheckInListDto rebuild(void Function(CheckInListDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckInListDtoBuilder toBuilder() => CheckInListDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckInListDto && items == other.items;
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
    return (newBuiltValueToStringHelper(r'CheckInListDto')..add('items', items))
        .toString();
  }
}

class CheckInListDtoBuilder
    implements Builder<CheckInListDto, CheckInListDtoBuilder> {
  _$CheckInListDto? _$v;

  ListBuilder<CheckInDto>? _items;
  ListBuilder<CheckInDto> get items =>
      _$this._items ??= ListBuilder<CheckInDto>();
  set items(ListBuilder<CheckInDto>? items) => _$this._items = items;

  CheckInListDtoBuilder() {
    CheckInListDto._defaults(this);
  }

  CheckInListDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckInListDto other) {
    _$v = other as _$CheckInListDto;
  }

  @override
  void update(void Function(CheckInListDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckInListDto build() => _build();

  _$CheckInListDto _build() {
    _$CheckInListDto _$result;
    try {
      _$result = _$v ??
          _$CheckInListDto._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CheckInListDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
