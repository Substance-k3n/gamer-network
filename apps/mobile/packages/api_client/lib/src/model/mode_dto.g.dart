// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mode_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ModeDto extends ModeDto {
  @override
  final String id;
  @override
  final String name;
  @override
  final bool isRanked;

  factory _$ModeDto([void Function(ModeDtoBuilder)? updates]) =>
      (ModeDtoBuilder()..update(updates))._build();

  _$ModeDto._({required this.id, required this.name, required this.isRanked})
      : super._();
  @override
  ModeDto rebuild(void Function(ModeDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModeDtoBuilder toBuilder() => ModeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModeDto &&
        id == other.id &&
        name == other.name &&
        isRanked == other.isRanked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, isRanked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ModeDto')
          ..add('id', id)
          ..add('name', name)
          ..add('isRanked', isRanked))
        .toString();
  }
}

class ModeDtoBuilder implements Builder<ModeDto, ModeDtoBuilder> {
  _$ModeDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _isRanked;
  bool? get isRanked => _$this._isRanked;
  set isRanked(bool? isRanked) => _$this._isRanked = isRanked;

  ModeDtoBuilder() {
    ModeDto._defaults(this);
  }

  ModeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _isRanked = $v.isRanked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModeDto other) {
    _$v = other as _$ModeDto;
  }

  @override
  void update(void Function(ModeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModeDto build() => _build();

  _$ModeDto _build() {
    final _$result = _$v ??
        _$ModeDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ModeDto', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'ModeDto', 'name'),
          isRanked: BuiltValueNullFieldError.checkNotNull(
              isRanked, r'ModeDto', 'isRanked'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
