// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupMemberDto extends GroupMemberDto {
  @override
  final GroupRole role;
  @override
  final MembershipStatus status;
  @override
  final UserCardDto user;
  @override
  final DateTime? joinedAt;

  factory _$GroupMemberDto([void Function(GroupMemberDtoBuilder)? updates]) =>
      (GroupMemberDtoBuilder()..update(updates))._build();

  _$GroupMemberDto._(
      {required this.role,
      required this.status,
      required this.user,
      this.joinedAt})
      : super._();
  @override
  GroupMemberDto rebuild(void Function(GroupMemberDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupMemberDtoBuilder toBuilder() => GroupMemberDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupMemberDto &&
        role == other.role &&
        status == other.status &&
        user == other.user &&
        joinedAt == other.joinedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupMemberDto')
          ..add('role', role)
          ..add('status', status)
          ..add('user', user)
          ..add('joinedAt', joinedAt))
        .toString();
  }
}

class GroupMemberDtoBuilder
    implements Builder<GroupMemberDto, GroupMemberDtoBuilder> {
  _$GroupMemberDto? _$v;

  GroupRole? _role;
  GroupRole? get role => _$this._role;
  set role(GroupRole? role) => _$this._role = role;

  MembershipStatus? _status;
  MembershipStatus? get status => _$this._status;
  set status(MembershipStatus? status) => _$this._status = status;

  UserCardDtoBuilder? _user;
  UserCardDtoBuilder get user => _$this._user ??= UserCardDtoBuilder();
  set user(UserCardDtoBuilder? user) => _$this._user = user;

  DateTime? _joinedAt;
  DateTime? get joinedAt => _$this._joinedAt;
  set joinedAt(DateTime? joinedAt) => _$this._joinedAt = joinedAt;

  GroupMemberDtoBuilder() {
    GroupMemberDto._defaults(this);
  }

  GroupMemberDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _status = $v.status;
      _user = $v.user.toBuilder();
      _joinedAt = $v.joinedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupMemberDto other) {
    _$v = other as _$GroupMemberDto;
  }

  @override
  void update(void Function(GroupMemberDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupMemberDto build() => _build();

  _$GroupMemberDto _build() {
    _$GroupMemberDto _$result;
    try {
      _$result = _$v ??
          _$GroupMemberDto._(
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'GroupMemberDto', 'role'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GroupMemberDto', 'status'),
            user: user.build(),
            joinedAt: joinedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GroupMemberDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
