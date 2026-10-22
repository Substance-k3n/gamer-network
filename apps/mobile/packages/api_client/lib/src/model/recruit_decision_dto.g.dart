// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_decision_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecruitDecisionDto extends RecruitDecisionDto {
  @override
  final ApplicationStatus status;
  @override
  final String id;

  factory _$RecruitDecisionDto(
          [void Function(RecruitDecisionDtoBuilder)? updates]) =>
      (RecruitDecisionDtoBuilder()..update(updates))._build();

  _$RecruitDecisionDto._({required this.status, required this.id}) : super._();
  @override
  RecruitDecisionDto rebuild(
          void Function(RecruitDecisionDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecruitDecisionDtoBuilder toBuilder() =>
      RecruitDecisionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecruitDecisionDto &&
        status == other.status &&
        id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecruitDecisionDto')
          ..add('status', status)
          ..add('id', id))
        .toString();
  }
}

class RecruitDecisionDtoBuilder
    implements Builder<RecruitDecisionDto, RecruitDecisionDtoBuilder> {
  _$RecruitDecisionDto? _$v;

  ApplicationStatus? _status;
  ApplicationStatus? get status => _$this._status;
  set status(ApplicationStatus? status) => _$this._status = status;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  RecruitDecisionDtoBuilder() {
    RecruitDecisionDto._defaults(this);
  }

  RecruitDecisionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecruitDecisionDto other) {
    _$v = other as _$RecruitDecisionDto;
  }

  @override
  void update(void Function(RecruitDecisionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecruitDecisionDto build() => _build();

  _$RecruitDecisionDto _build() {
    final _$result = _$v ??
        _$RecruitDecisionDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'RecruitDecisionDto', 'status'),
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'RecruitDecisionDto', 'id'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
