// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_invite_list_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlayInviteListDto extends PlayInviteListDto {
  @override
  final BuiltList<PlayInviteDto> items;

  factory _$PlayInviteListDto(
          [void Function(PlayInviteListDtoBuilder)? updates]) =>
      (PlayInviteListDtoBuilder()..update(updates))._build();

  _$PlayInviteListDto._({required this.items}) : super._();
  @override
  PlayInviteListDto rebuild(void Function(PlayInviteListDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlayInviteListDtoBuilder toBuilder() =>
      PlayInviteListDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlayInviteListDto && items == other.items;
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
    return (newBuiltValueToStringHelper(r'PlayInviteListDto')
          ..add('items', items))
        .toString();
  }
}

class PlayInviteListDtoBuilder
    implements Builder<PlayInviteListDto, PlayInviteListDtoBuilder> {
  _$PlayInviteListDto? _$v;

  ListBuilder<PlayInviteDto>? _items;
  ListBuilder<PlayInviteDto> get items =>
      _$this._items ??= ListBuilder<PlayInviteDto>();
  set items(ListBuilder<PlayInviteDto>? items) => _$this._items = items;

  PlayInviteListDtoBuilder() {
    PlayInviteListDto._defaults(this);
  }

  PlayInviteListDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlayInviteListDto other) {
    _$v = other as _$PlayInviteListDto;
  }

  @override
  void update(void Function(PlayInviteListDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlayInviteListDto build() => _build();

  _$PlayInviteListDto _build() {
    _$PlayInviteListDto _$result;
    try {
      _$result = _$v ??
          _$PlayInviteListDto._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PlayInviteListDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
