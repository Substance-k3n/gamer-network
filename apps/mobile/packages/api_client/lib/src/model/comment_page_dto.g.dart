// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommentPageDto extends CommentPageDto {
  @override
  final BuiltList<CommentDto> items;
  @override
  final String? nextCursor;

  factory _$CommentPageDto([void Function(CommentPageDtoBuilder)? updates]) =>
      (CommentPageDtoBuilder()..update(updates))._build();

  _$CommentPageDto._({required this.items, this.nextCursor}) : super._();
  @override
  CommentPageDto rebuild(void Function(CommentPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommentPageDtoBuilder toBuilder() => CommentPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommentPageDto &&
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
    return (newBuiltValueToStringHelper(r'CommentPageDto')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class CommentPageDtoBuilder
    implements Builder<CommentPageDto, CommentPageDtoBuilder> {
  _$CommentPageDto? _$v;

  ListBuilder<CommentDto>? _items;
  ListBuilder<CommentDto> get items =>
      _$this._items ??= ListBuilder<CommentDto>();
  set items(ListBuilder<CommentDto>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  CommentPageDtoBuilder() {
    CommentPageDto._defaults(this);
  }

  CommentPageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommentPageDto other) {
    _$v = other as _$CommentPageDto;
  }

  @override
  void update(void Function(CommentPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommentPageDto build() => _build();

  _$CommentPageDto _build() {
    _$CommentPageDto _$result;
    try {
      _$result = _$v ??
          _$CommentPageDto._(
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
            r'CommentPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
