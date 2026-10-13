// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mode_ref_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ModeRefDto extends ModeRefDto {
  @override
  final String id;
  @override
  final String name;

  factory _$ModeRefDto([void Function(ModeRefDtoBuilder)? updates]) =>
      (ModeRefDtoBuilder()..update(updates))._build();

  _$ModeRefDto._({required this.id, required this.name}) : super._();
  @override
  ModeRefDto rebuild(void Function(ModeRefDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ModeRefDtoBuilder toBuilder() => ModeRefDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ModeRefDto && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ModeRefDto')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class ModeRefDtoBuilder implements Builder<ModeRefDto, ModeRefDtoBuilder> {
  _$ModeRefDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ModeRefDtoBuilder() {
    ModeRefDto._defaults(this);
  }

  ModeRefDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ModeRefDto other) {
    _$v = other as _$ModeRefDto;
  }

  @override
  void update(void Function(ModeRefDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ModeRefDto build() => _build();

  _$ModeRefDto _build() {
    final _$result = _$v ??
        _$ModeRefDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ModeRefDto', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ModeRefDto', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
