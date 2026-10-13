// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_ref_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GameRefDto extends GameRefDto {
  @override
  final String id;
  @override
  final String name;
  @override
  final String shortCode;

  factory _$GameRefDto([void Function(GameRefDtoBuilder)? updates]) =>
      (GameRefDtoBuilder()..update(updates))._build();

  _$GameRefDto._(
      {required this.id, required this.name, required this.shortCode})
      : super._();
  @override
  GameRefDto rebuild(void Function(GameRefDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GameRefDtoBuilder toBuilder() => GameRefDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GameRefDto &&
        id == other.id &&
        name == other.name &&
        shortCode == other.shortCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, shortCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GameRefDto')
          ..add('id', id)
          ..add('name', name)
          ..add('shortCode', shortCode))
        .toString();
  }
}

class GameRefDtoBuilder implements Builder<GameRefDto, GameRefDtoBuilder> {
  _$GameRefDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _shortCode;
  String? get shortCode => _$this._shortCode;
  set shortCode(String? shortCode) => _$this._shortCode = shortCode;

  GameRefDtoBuilder() {
    GameRefDto._defaults(this);
  }

  GameRefDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _shortCode = $v.shortCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GameRefDto other) {
    _$v = other as _$GameRefDto;
  }

  @override
  void update(void Function(GameRefDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GameRefDto build() => _build();

  _$GameRefDto _build() {
    final _$result = _$v ??
        _$GameRefDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'GameRefDto', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'GameRefDto', 'name'),
          shortCode: BuiltValueNullFieldError.checkNotNull(
              shortCode, r'GameRefDto', 'shortCode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
