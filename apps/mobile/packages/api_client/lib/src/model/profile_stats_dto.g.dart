// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_stats_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProfileStatsDto extends ProfileStatsDto {
  @override
  final num connections;
  @override
  final num games;
  @override
  final num playedWith;

  factory _$ProfileStatsDto([void Function(ProfileStatsDtoBuilder)? updates]) =>
      (ProfileStatsDtoBuilder()..update(updates))._build();

  _$ProfileStatsDto._(
      {required this.connections,
      required this.games,
      required this.playedWith})
      : super._();
  @override
  ProfileStatsDto rebuild(void Function(ProfileStatsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileStatsDtoBuilder toBuilder() => ProfileStatsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileStatsDto &&
        connections == other.connections &&
        games == other.games &&
        playedWith == other.playedWith;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, connections.hashCode);
    _$hash = $jc(_$hash, games.hashCode);
    _$hash = $jc(_$hash, playedWith.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileStatsDto')
          ..add('connections', connections)
          ..add('games', games)
          ..add('playedWith', playedWith))
        .toString();
  }
}

class ProfileStatsDtoBuilder
    implements Builder<ProfileStatsDto, ProfileStatsDtoBuilder> {
  _$ProfileStatsDto? _$v;

  num? _connections;
  num? get connections => _$this._connections;
  set connections(num? connections) => _$this._connections = connections;

  num? _games;
  num? get games => _$this._games;
  set games(num? games) => _$this._games = games;

  num? _playedWith;
  num? get playedWith => _$this._playedWith;
  set playedWith(num? playedWith) => _$this._playedWith = playedWith;

  ProfileStatsDtoBuilder() {
    ProfileStatsDto._defaults(this);
  }

  ProfileStatsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _connections = $v.connections;
      _games = $v.games;
      _playedWith = $v.playedWith;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileStatsDto other) {
    _$v = other as _$ProfileStatsDto;
  }

  @override
  void update(void Function(ProfileStatsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileStatsDto build() => _build();

  _$ProfileStatsDto _build() {
    final _$result = _$v ??
        _$ProfileStatsDto._(
          connections: BuiltValueNullFieldError.checkNotNull(
              connections, r'ProfileStatsDto', 'connections'),
          games: BuiltValueNullFieldError.checkNotNull(
              games, r'ProfileStatsDto', 'games'),
          playedWith: BuiltValueNullFieldError.checkNotNull(
              playedWith, r'ProfileStatsDto', 'playedWith'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
