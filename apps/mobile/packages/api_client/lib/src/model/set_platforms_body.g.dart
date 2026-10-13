// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_platforms_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetPlatformsBody extends SetPlatformsBody {
  @override
  final BuiltSet<Platform> platforms;

  factory _$SetPlatformsBody(
          [void Function(SetPlatformsBodyBuilder)? updates]) =>
      (SetPlatformsBodyBuilder()..update(updates))._build();

  _$SetPlatformsBody._({required this.platforms}) : super._();
  @override
  SetPlatformsBody rebuild(void Function(SetPlatformsBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetPlatformsBodyBuilder toBuilder() =>
      SetPlatformsBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetPlatformsBody && platforms == other.platforms;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, platforms.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetPlatformsBody')
          ..add('platforms', platforms))
        .toString();
  }
}

class SetPlatformsBodyBuilder
    implements Builder<SetPlatformsBody, SetPlatformsBodyBuilder> {
  _$SetPlatformsBody? _$v;

  SetBuilder<Platform>? _platforms;
  SetBuilder<Platform> get platforms =>
      _$this._platforms ??= SetBuilder<Platform>();
  set platforms(SetBuilder<Platform>? platforms) =>
      _$this._platforms = platforms;

  SetPlatformsBodyBuilder() {
    SetPlatformsBody._defaults(this);
  }

  SetPlatformsBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platforms = $v.platforms.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetPlatformsBody other) {
    _$v = other as _$SetPlatformsBody;
  }

  @override
  void update(void Function(SetPlatformsBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetPlatformsBody build() => _build();

  _$SetPlatformsBody _build() {
    _$SetPlatformsBody _$result;
    try {
      _$result = _$v ??
          _$SetPlatformsBody._(
            platforms: platforms.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'platforms';
        platforms.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SetPlatformsBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
