// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_me_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateMeBody extends UpdateMeBody {
  @override
  final AgeRange? ageRange;
  @override
  final String? displayName;
  @override
  final String? username;
  @override
  final String? bio;
  @override
  final String? city;

  factory _$UpdateMeBody([void Function(UpdateMeBodyBuilder)? updates]) =>
      (UpdateMeBodyBuilder()..update(updates))._build();

  _$UpdateMeBody._(
      {this.ageRange, this.displayName, this.username, this.bio, this.city})
      : super._();
  @override
  UpdateMeBody rebuild(void Function(UpdateMeBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateMeBodyBuilder toBuilder() => UpdateMeBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateMeBody &&
        ageRange == other.ageRange &&
        displayName == other.displayName &&
        username == other.username &&
        bio == other.bio &&
        city == other.city;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ageRange.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateMeBody')
          ..add('ageRange', ageRange)
          ..add('displayName', displayName)
          ..add('username', username)
          ..add('bio', bio)
          ..add('city', city))
        .toString();
  }
}

class UpdateMeBodyBuilder
    implements Builder<UpdateMeBody, UpdateMeBodyBuilder> {
  _$UpdateMeBody? _$v;

  AgeRange? _ageRange;
  AgeRange? get ageRange => _$this._ageRange;
  set ageRange(AgeRange? ageRange) => _$this._ageRange = ageRange;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  UpdateMeBodyBuilder() {
    UpdateMeBody._defaults(this);
  }

  UpdateMeBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ageRange = $v.ageRange;
      _displayName = $v.displayName;
      _username = $v.username;
      _bio = $v.bio;
      _city = $v.city;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateMeBody other) {
    _$v = other as _$UpdateMeBody;
  }

  @override
  void update(void Function(UpdateMeBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateMeBody build() => _build();

  _$UpdateMeBody _build() {
    final _$result = _$v ??
        _$UpdateMeBody._(
          ageRange: ageRange,
          displayName: displayName,
          username: username,
          bio: bio,
          city: city,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
