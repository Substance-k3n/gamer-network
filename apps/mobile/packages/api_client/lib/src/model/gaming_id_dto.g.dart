// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaming_id_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GamingIdDto extends GamingIdDto {
  @override
  final GamingIdKind kind;
  @override
  final IdVisibility visibility;
  @override
  final String id;
  @override
  final GameRefDto? game;
  @override
  final String value;

  factory _$GamingIdDto([void Function(GamingIdDtoBuilder)? updates]) =>
      (GamingIdDtoBuilder()..update(updates))._build();

  _$GamingIdDto._(
      {required this.kind,
      required this.visibility,
      required this.id,
      this.game,
      required this.value})
      : super._();
  @override
  GamingIdDto rebuild(void Function(GamingIdDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GamingIdDtoBuilder toBuilder() => GamingIdDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GamingIdDto &&
        kind == other.kind &&
        visibility == other.visibility &&
        id == other.id &&
        game == other.game &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GamingIdDto')
          ..add('kind', kind)
          ..add('visibility', visibility)
          ..add('id', id)
          ..add('game', game)
          ..add('value', value))
        .toString();
  }
}

class GamingIdDtoBuilder implements Builder<GamingIdDto, GamingIdDtoBuilder> {
  _$GamingIdDto? _$v;

  GamingIdKind? _kind;
  GamingIdKind? get kind => _$this._kind;
  set kind(GamingIdKind? kind) => _$this._kind = kind;

  IdVisibility? _visibility;
  IdVisibility? get visibility => _$this._visibility;
  set visibility(IdVisibility? visibility) => _$this._visibility = visibility;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  GameRefDtoBuilder? _game;
  GameRefDtoBuilder get game => _$this._game ??= GameRefDtoBuilder();
  set game(GameRefDtoBuilder? game) => _$this._game = game;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  GamingIdDtoBuilder() {
    GamingIdDto._defaults(this);
  }

  GamingIdDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _visibility = $v.visibility;
      _id = $v.id;
      _game = $v.game?.toBuilder();
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GamingIdDto other) {
    _$v = other as _$GamingIdDto;
  }

  @override
  void update(void Function(GamingIdDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GamingIdDto build() => _build();

  _$GamingIdDto _build() {
    _$GamingIdDto _$result;
    try {
      _$result = _$v ??
          _$GamingIdDto._(
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'GamingIdDto', 'kind'),
            visibility: BuiltValueNullFieldError.checkNotNull(
                visibility, r'GamingIdDto', 'visibility'),
            id: BuiltValueNullFieldError.checkNotNull(id, r'GamingIdDto', 'id'),
            game: _game?.build(),
            value: BuiltValueNullFieldError.checkNotNull(
                value, r'GamingIdDto', 'value'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'game';
        _game?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GamingIdDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
