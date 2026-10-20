// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_post_author_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicPostAuthorDto extends PublicPostAuthorDto {
  @override
  final String displayName;
  @override
  final String username;
  @override
  final String? avatarUrl;

  factory _$PublicPostAuthorDto(
          [void Function(PublicPostAuthorDtoBuilder)? updates]) =>
      (PublicPostAuthorDtoBuilder()..update(updates))._build();

  _$PublicPostAuthorDto._(
      {required this.displayName, required this.username, this.avatarUrl})
      : super._();
  @override
  PublicPostAuthorDto rebuild(
          void Function(PublicPostAuthorDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicPostAuthorDtoBuilder toBuilder() =>
      PublicPostAuthorDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicPostAuthorDto &&
        displayName == other.displayName &&
        username == other.username &&
        avatarUrl == other.avatarUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicPostAuthorDto')
          ..add('displayName', displayName)
          ..add('username', username)
          ..add('avatarUrl', avatarUrl))
        .toString();
  }
}

class PublicPostAuthorDtoBuilder
    implements Builder<PublicPostAuthorDto, PublicPostAuthorDtoBuilder> {
  _$PublicPostAuthorDto? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  PublicPostAuthorDtoBuilder() {
    PublicPostAuthorDto._defaults(this);
  }

  PublicPostAuthorDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _username = $v.username;
      _avatarUrl = $v.avatarUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicPostAuthorDto other) {
    _$v = other as _$PublicPostAuthorDto;
  }

  @override
  void update(void Function(PublicPostAuthorDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicPostAuthorDto build() => _build();

  _$PublicPostAuthorDto _build() {
    final _$result = _$v ??
        _$PublicPostAuthorDto._(
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'PublicPostAuthorDto', 'displayName'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'PublicPostAuthorDto', 'username'),
          avatarUrl: avatarUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
