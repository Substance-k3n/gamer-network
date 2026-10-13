// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_games_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetGamesBody extends SetGamesBody {
  @override
  final BuiltList<UserGameInput> games;

  factory _$SetGamesBody([void Function(SetGamesBodyBuilder)? updates]) =>
      (SetGamesBodyBuilder()..update(updates))._build();

  _$SetGamesBody._({required this.games}) : super._();
  @override
  SetGamesBody rebuild(void Function(SetGamesBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetGamesBodyBuilder toBuilder() => SetGamesBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetGamesBody && games == other.games;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, games.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetGamesBody')..add('games', games))
        .toString();
  }
}

class SetGamesBodyBuilder
    implements Builder<SetGamesBody, SetGamesBodyBuilder> {
  _$SetGamesBody? _$v;

  ListBuilder<UserGameInput>? _games;
  ListBuilder<UserGameInput> get games =>
      _$this._games ??= ListBuilder<UserGameInput>();
  set games(ListBuilder<UserGameInput>? games) => _$this._games = games;

  SetGamesBodyBuilder() {
    SetGamesBody._defaults(this);
  }

  SetGamesBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _games = $v.games.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetGamesBody other) {
    _$v = other as _$SetGamesBody;
  }

  @override
  void update(void Function(SetGamesBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetGamesBody build() => _build();

  _$SetGamesBody _build() {
    _$SetGamesBody _$result;
    try {
      _$result = _$v ??
          _$SetGamesBody._(
            games: games.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'games';
        games.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SetGamesBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
