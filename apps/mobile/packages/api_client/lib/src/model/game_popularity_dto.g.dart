// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_popularity_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GamePopularityDto extends GamePopularityDto {
  @override
  final String gameId;
  @override
  final String name;
  @override
  final num listings;

  factory _$GamePopularityDto(
          [void Function(GamePopularityDtoBuilder)? updates]) =>
      (GamePopularityDtoBuilder()..update(updates))._build();

  _$GamePopularityDto._(
      {required this.gameId, required this.name, required this.listings})
      : super._();
  @override
  GamePopularityDto rebuild(void Function(GamePopularityDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GamePopularityDtoBuilder toBuilder() =>
      GamePopularityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GamePopularityDto &&
        gameId == other.gameId &&
        name == other.name &&
        listings == other.listings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, gameId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, listings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GamePopularityDto')
          ..add('gameId', gameId)
          ..add('name', name)
          ..add('listings', listings))
        .toString();
  }
}

class GamePopularityDtoBuilder
    implements Builder<GamePopularityDto, GamePopularityDtoBuilder> {
  _$GamePopularityDto? _$v;

  String? _gameId;
  String? get gameId => _$this._gameId;
  set gameId(String? gameId) => _$this._gameId = gameId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  num? _listings;
  num? get listings => _$this._listings;
  set listings(num? listings) => _$this._listings = listings;

  GamePopularityDtoBuilder() {
    GamePopularityDto._defaults(this);
  }

  GamePopularityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _gameId = $v.gameId;
      _name = $v.name;
      _listings = $v.listings;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GamePopularityDto other) {
    _$v = other as _$GamePopularityDto;
  }

  @override
  void update(void Function(GamePopularityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GamePopularityDto build() => _build();

  _$GamePopularityDto _build() {
    final _$result = _$v ??
        _$GamePopularityDto._(
          gameId: BuiltValueNullFieldError.checkNotNull(
              gameId, r'GamePopularityDto', 'gameId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'GamePopularityDto', 'name'),
          listings: BuiltValueNullFieldError.checkNotNull(
              listings, r'GamePopularityDto', 'listings'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
