// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaming_id_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GamingIdInput extends GamingIdInput {
  @override
  final GamingIdKind kind;
  @override
  final IdVisibility? visibility;
  @override
  final String? gameId;
  @override
  final String value;

  factory _$GamingIdInput([void Function(GamingIdInputBuilder)? updates]) =>
      (GamingIdInputBuilder()..update(updates))._build();

  _$GamingIdInput._(
      {required this.kind, this.visibility, this.gameId, required this.value})
      : super._();
  @override
  GamingIdInput rebuild(void Function(GamingIdInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GamingIdInputBuilder toBuilder() => GamingIdInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GamingIdInput &&
        kind == other.kind &&
        visibility == other.visibility &&
        gameId == other.gameId &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jc(_$hash, gameId.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GamingIdInput')
          ..add('kind', kind)
          ..add('visibility', visibility)
          ..add('gameId', gameId)
          ..add('value', value))
        .toString();
  }
}

class GamingIdInputBuilder
    implements Builder<GamingIdInput, GamingIdInputBuilder> {
  _$GamingIdInput? _$v;

  GamingIdKind? _kind;
  GamingIdKind? get kind => _$this._kind;
  set kind(GamingIdKind? kind) => _$this._kind = kind;

  IdVisibility? _visibility;
  IdVisibility? get visibility => _$this._visibility;
  set visibility(IdVisibility? visibility) => _$this._visibility = visibility;

  String? _gameId;
  String? get gameId => _$this._gameId;
  set gameId(String? gameId) => _$this._gameId = gameId;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  GamingIdInputBuilder() {
    GamingIdInput._defaults(this);
  }

  GamingIdInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _visibility = $v.visibility;
      _gameId = $v.gameId;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GamingIdInput other) {
    _$v = other as _$GamingIdInput;
  }

  @override
  void update(void Function(GamingIdInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GamingIdInput build() => _build();

  _$GamingIdInput _build() {
    final _$result = _$v ??
        _$GamingIdInput._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'GamingIdInput', 'kind'),
          visibility: visibility,
          gameId: gameId,
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'GamingIdInput', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
