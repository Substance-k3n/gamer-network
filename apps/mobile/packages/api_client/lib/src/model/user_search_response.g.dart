// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserSearchResponse extends UserSearchResponse {
  @override
  final BuiltList<UserCardDto> items;

  factory _$UserSearchResponse(
          [void Function(UserSearchResponseBuilder)? updates]) =>
      (UserSearchResponseBuilder()..update(updates))._build();

  _$UserSearchResponse._({required this.items}) : super._();
  @override
  UserSearchResponse rebuild(
          void Function(UserSearchResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserSearchResponseBuilder toBuilder() =>
      UserSearchResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserSearchResponse && items == other.items;
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
    return (newBuiltValueToStringHelper(r'UserSearchResponse')
          ..add('items', items))
        .toString();
  }
}

class UserSearchResponseBuilder
    implements Builder<UserSearchResponse, UserSearchResponseBuilder> {
  _$UserSearchResponse? _$v;

  ListBuilder<UserCardDto>? _items;
  ListBuilder<UserCardDto> get items =>
      _$this._items ??= ListBuilder<UserCardDto>();
  set items(ListBuilder<UserCardDto>? items) => _$this._items = items;

  UserSearchResponseBuilder() {
    UserSearchResponse._defaults(this);
  }

  UserSearchResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserSearchResponse other) {
    _$v = other as _$UserSearchResponse;
  }

  @override
  void update(void Function(UserSearchResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserSearchResponse build() => _build();

  _$UserSearchResponse _build() {
    _$UserSearchResponse _$result;
    try {
      _$result = _$v ??
          _$UserSearchResponse._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserSearchResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
