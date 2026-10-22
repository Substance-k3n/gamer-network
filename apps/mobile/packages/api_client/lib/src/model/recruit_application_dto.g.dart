// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruit_application_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecruitApplicationDto extends RecruitApplicationDto {
  @override
  final ApplicationStatus status;
  @override
  final String id;
  @override
  final UserCardDto user;
  @override
  final DateTime createdAt;

  factory _$RecruitApplicationDto(
          [void Function(RecruitApplicationDtoBuilder)? updates]) =>
      (RecruitApplicationDtoBuilder()..update(updates))._build();

  _$RecruitApplicationDto._(
      {required this.status,
      required this.id,
      required this.user,
      required this.createdAt})
      : super._();
  @override
  RecruitApplicationDto rebuild(
          void Function(RecruitApplicationDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecruitApplicationDtoBuilder toBuilder() =>
      RecruitApplicationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecruitApplicationDto &&
        status == other.status &&
        id == other.id &&
        user == other.user &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecruitApplicationDto')
          ..add('status', status)
          ..add('id', id)
          ..add('user', user)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class RecruitApplicationDtoBuilder
    implements Builder<RecruitApplicationDto, RecruitApplicationDtoBuilder> {
  _$RecruitApplicationDto? _$v;

  ApplicationStatus? _status;
  ApplicationStatus? get status => _$this._status;
  set status(ApplicationStatus? status) => _$this._status = status;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  UserCardDtoBuilder? _user;
  UserCardDtoBuilder get user => _$this._user ??= UserCardDtoBuilder();
  set user(UserCardDtoBuilder? user) => _$this._user = user;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  RecruitApplicationDtoBuilder() {
    RecruitApplicationDto._defaults(this);
  }

  RecruitApplicationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _id = $v.id;
      _user = $v.user.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecruitApplicationDto other) {
    _$v = other as _$RecruitApplicationDto;
  }

  @override
  void update(void Function(RecruitApplicationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecruitApplicationDto build() => _build();

  _$RecruitApplicationDto _build() {
    _$RecruitApplicationDto _$result;
    try {
      _$result = _$v ??
          _$RecruitApplicationDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'RecruitApplicationDto', 'status'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'RecruitApplicationDto', 'id'),
            user: user.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'RecruitApplicationDto', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RecruitApplicationDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
