// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_ref_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoleRefDto extends RoleRefDto {
  @override
  final String id;
  @override
  final String name;

  factory _$RoleRefDto([void Function(RoleRefDtoBuilder)? updates]) =>
      (RoleRefDtoBuilder()..update(updates))._build();

  _$RoleRefDto._({required this.id, required this.name}) : super._();
  @override
  RoleRefDto rebuild(void Function(RoleRefDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoleRefDtoBuilder toBuilder() => RoleRefDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoleRefDto && id == other.id && name == other.name;
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
    return (newBuiltValueToStringHelper(r'RoleRefDto')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class RoleRefDtoBuilder implements Builder<RoleRefDto, RoleRefDtoBuilder> {
  _$RoleRefDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RoleRefDtoBuilder() {
    RoleRefDto._defaults(this);
  }

  RoleRefDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoleRefDto other) {
    _$v = other as _$RoleRefDto;
  }

  @override
  void update(void Function(RoleRefDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoleRefDto build() => _build();

  _$RoleRefDto _build() {
    final _$result = _$v ??
        _$RoleRefDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'RoleRefDto', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'RoleRefDto', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
