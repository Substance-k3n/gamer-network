// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_group_role_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetGroupRoleBody extends SetGroupRoleBody {
  @override
  final GroupRole role;

  factory _$SetGroupRoleBody(
          [void Function(SetGroupRoleBodyBuilder)? updates]) =>
      (SetGroupRoleBodyBuilder()..update(updates))._build();

  _$SetGroupRoleBody._({required this.role}) : super._();
  @override
  SetGroupRoleBody rebuild(void Function(SetGroupRoleBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetGroupRoleBodyBuilder toBuilder() =>
      SetGroupRoleBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetGroupRoleBody && role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetGroupRoleBody')..add('role', role))
        .toString();
  }
}

class SetGroupRoleBodyBuilder
    implements Builder<SetGroupRoleBody, SetGroupRoleBodyBuilder> {
  _$SetGroupRoleBody? _$v;

  GroupRole? _role;
  GroupRole? get role => _$this._role;
  set role(GroupRole? role) => _$this._role = role;

  SetGroupRoleBodyBuilder() {
    SetGroupRoleBody._defaults(this);
  }

  SetGroupRoleBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetGroupRoleBody other) {
    _$v = other as _$SetGroupRoleBody;
  }

  @override
  void update(void Function(SetGroupRoleBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetGroupRoleBody build() => _build();

  _$SetGroupRoleBody _build() {
    final _$result = _$v ??
        _$SetGroupRoleBody._(
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'SetGroupRoleBody', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
