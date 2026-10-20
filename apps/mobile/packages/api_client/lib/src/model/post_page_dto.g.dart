// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_page_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PostPageDto extends PostPageDto {
  @override
  final BuiltList<PostDto> items;
  @override
  final String? nextCursor;

  factory _$PostPageDto([void Function(PostPageDtoBuilder)? updates]) =>
      (PostPageDtoBuilder()..update(updates))._build();

  _$PostPageDto._({required this.items, this.nextCursor}) : super._();
  @override
  PostPageDto rebuild(void Function(PostPageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostPageDtoBuilder toBuilder() => PostPageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostPageDto &&
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
    return (newBuiltValueToStringHelper(r'PostPageDto')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class PostPageDtoBuilder implements Builder<PostPageDto, PostPageDtoBuilder> {
  _$PostPageDto? _$v;

  ListBuilder<PostDto>? _items;
  ListBuilder<PostDto> get items => _$this._items ??= ListBuilder<PostDto>();
  set items(ListBuilder<PostDto>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  PostPageDtoBuilder() {
    PostPageDto._defaults(this);
  }

  PostPageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PostPageDto other) {
    _$v = other as _$PostPageDto;
  }

  @override
  void update(void Function(PostPageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PostPageDto build() => _build();

  _$PostPageDto _build() {
    _$PostPageDto _$result;
    try {
      _$result = _$v ??
          _$PostPageDto._(
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
            r'PostPageDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
