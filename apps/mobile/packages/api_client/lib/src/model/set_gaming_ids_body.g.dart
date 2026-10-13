// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_gaming_ids_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetGamingIdsBody extends SetGamingIdsBody {
  @override
  final BuiltList<GamingIdInput> gamingIds;

  factory _$SetGamingIdsBody(
          [void Function(SetGamingIdsBodyBuilder)? updates]) =>
      (SetGamingIdsBodyBuilder()..update(updates))._build();

  _$SetGamingIdsBody._({required this.gamingIds}) : super._();
  @override
  SetGamingIdsBody rebuild(void Function(SetGamingIdsBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetGamingIdsBodyBuilder toBuilder() =>
      SetGamingIdsBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetGamingIdsBody && gamingIds == other.gamingIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gamingIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetGamingIdsBody')
          ..add('gamingIds', gamingIds))
        .toString();
  }
}

class SetGamingIdsBodyBuilder
    implements Builder<SetGamingIdsBody, SetGamingIdsBodyBuilder> {
  _$SetGamingIdsBody? _$v;

  ListBuilder<GamingIdInput>? _gamingIds;
  ListBuilder<GamingIdInput> get gamingIds =>
      _$this._gamingIds ??= ListBuilder<GamingIdInput>();
  set gamingIds(ListBuilder<GamingIdInput>? gamingIds) =>
      _$this._gamingIds = gamingIds;

  SetGamingIdsBodyBuilder() {
    SetGamingIdsBody._defaults(this);
  }

  SetGamingIdsBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gamingIds = $v.gamingIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetGamingIdsBody other) {
    _$v = other as _$SetGamingIdsBody;
  }

  @override
  void update(void Function(SetGamingIdsBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetGamingIdsBody build() => _build();

  _$SetGamingIdsBody _build() {
    _$SetGamingIdsBody _$result;
    try {
      _$result = _$v ??
          _$SetGamingIdsBody._(
            gamingIds: gamingIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'gamingIds';
        gamingIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SetGamingIdsBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
