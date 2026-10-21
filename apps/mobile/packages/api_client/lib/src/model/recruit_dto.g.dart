// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecruitDto extends RecruitDto {
  @override
  final ApplicationStatus? myApplication;
  @override
  final num slots;
  @override
  final String roles;
  @override
  final num applications;

  factory _$RecruitDto([void Function(RecruitDtoBuilder)? updates]) =>
      (RecruitDtoBuilder()..update(updates))._build();

  _$RecruitDto._(
      {this.myApplication,
      required this.slots,
      required this.roles,
      required this.applications})
      : super._();
  @override
  RecruitDto rebuild(void Function(RecruitDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecruitDtoBuilder toBuilder() => RecruitDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecruitDto &&
        myApplication == other.myApplication &&
        slots == other.slots &&
        roles == other.roles &&
        applications == other.applications;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, myApplication.hashCode);
    _$hash = $jc(_$hash, slots.hashCode);
    _$hash = $jc(_$hash, roles.hashCode);
    _$hash = $jc(_$hash, applications.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecruitDto')
          ..add('myApplication', myApplication)
          ..add('slots', slots)
          ..add('roles', roles)
          ..add('applications', applications))
        .toString();
  }
}

class RecruitDtoBuilder implements Builder<RecruitDto, RecruitDtoBuilder> {
  _$RecruitDto? _$v;

  ApplicationStatus? _myApplication;
  ApplicationStatus? get myApplication => _$this._myApplication;
  set myApplication(ApplicationStatus? myApplication) =>
      _$this._myApplication = myApplication;

  num? _slots;
  num? get slots => _$this._slots;
  set slots(num? slots) => _$this._slots = slots;

  String? _roles;
  String? get roles => _$this._roles;
  set roles(String? roles) => _$this._roles = roles;

  num? _applications;
  num? get applications => _$this._applications;
  set applications(num? applications) => _$this._applications = applications;

  RecruitDtoBuilder() {
    RecruitDto._defaults(this);
  }

  RecruitDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _myApplication = $v.myApplication;
      _slots = $v.slots;
      _roles = $v.roles;
      _applications = $v.applications;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecruitDto other) {
    _$v = other as _$RecruitDto;
  }

  @override
  void update(void Function(RecruitDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecruitDto build() => _build();

  _$RecruitDto _build() {
    final _$result = _$v ??
        _$RecruitDto._(
          myApplication: myApplication,
          slots: BuiltValueNullFieldError.checkNotNull(
              slots, r'RecruitDto', 'slots'),
          roles: BuiltValueNullFieldError.checkNotNull(
              roles, r'RecruitDto', 'roles'),
          applications: BuiltValueNullFieldError.checkNotNull(
              applications, r'RecruitDto', 'applications'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
