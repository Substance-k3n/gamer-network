// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_avatar_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetAvatarBody extends SetAvatarBody {
  @override
  final String key;

  factory _$SetAvatarBody([void Function(SetAvatarBodyBuilder)? updates]) =>
      (SetAvatarBodyBuilder()..update(updates))._build();

  _$SetAvatarBody._({required this.key}) : super._();
  @override
  SetAvatarBody rebuild(void Function(SetAvatarBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetAvatarBodyBuilder toBuilder() => SetAvatarBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetAvatarBody && key == other.key;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetAvatarBody')..add('key', key))
        .toString();
  }
}

class SetAvatarBodyBuilder
    implements Builder<SetAvatarBody, SetAvatarBodyBuilder> {
  _$SetAvatarBody? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  SetAvatarBodyBuilder() {
    SetAvatarBody._defaults(this);
  }

  SetAvatarBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetAvatarBody other) {
    _$v = other as _$SetAvatarBody;
  }

  @override
  void update(void Function(SetAvatarBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetAvatarBody build() => _build();

  _$SetAvatarBody _build() {
    final _$result = _$v ??
        _$SetAvatarBody._(
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'SetAvatarBody', 'key'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
