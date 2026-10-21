// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecruitBody extends RecruitBody {
  @override
  final num slots;
  @override
  final String? roles;

  factory _$RecruitBody([void Function(RecruitBodyBuilder)? updates]) =>
      (RecruitBodyBuilder()..update(updates))._build();

  _$RecruitBody._({required this.slots, this.roles}) : super._();
  @override
  RecruitBody rebuild(void Function(RecruitBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecruitBodyBuilder toBuilder() => RecruitBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecruitBody && slots == other.slots && roles == other.roles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, slots.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecruitBody')
          ..add('slots', slots)
          ..add('roles', roles))
        .toString();
  }
}

class RecruitBodyBuilder implements Builder<RecruitBody, RecruitBodyBuilder> {
  _$RecruitBody? _$v;

  num? _slots;
  num? get slots => _$this._slots;
  set slots(num? slots) => _$this._slots = slots;

  String? _roles;
  String? get roles => _$this._roles;
  set roles(String? roles) => _$this._roles = roles;

  RecruitBodyBuilder() {
    RecruitBody._defaults(this);
  }

  RecruitBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _slots = $v.slots;
      _roles = $v.roles;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecruitBody other) {
    _$v = other as _$RecruitBody;
  }

  @override
  void update(void Function(RecruitBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecruitBody build() => _build();

  _$RecruitBody _build() {
    final _$result = _$v ??
        _$RecruitBody._(
          slots: BuiltValueNullFieldError.checkNotNull(
              slots, r'RecruitBody', 'slots'),
          roles: roles,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
