// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'totals_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TotalsDto extends TotalsDto {
  @override
  final num players;
  @override
  final num banned;
  @override
  final num games;
  @override
  final num openReports;
  @override
  final num liveGroups;

  factory _$TotalsDto([void Function(TotalsDtoBuilder)? updates]) =>
      (TotalsDtoBuilder()..update(updates))._build();

  _$TotalsDto._(
      {required this.players,
      required this.banned,
      required this.games,
      required this.openReports,
      required this.liveGroups})
      : super._();
  @override
  TotalsDto rebuild(void Function(TotalsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TotalsDtoBuilder toBuilder() => TotalsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TotalsDto &&
        players == other.players &&
        banned == other.banned &&
        games == other.games &&
        openReports == other.openReports &&
        liveGroups == other.liveGroups;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, players.hashCode);
    _$hash = $jc(_$hash, banned.hashCode);
    _$hash = $jc(_$hash, games.hashCode);
    _$hash = $jc(_$hash, openReports.hashCode);
    _$hash = $jc(_$hash, liveGroups.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TotalsDto')
          ..add('players', players)
          ..add('banned', banned)
          ..add('games', games)
          ..add('openReports', openReports)
          ..add('liveGroups', liveGroups))
        .toString();
  }
}

class TotalsDtoBuilder implements Builder<TotalsDto, TotalsDtoBuilder> {
  _$TotalsDto? _$v;

  num? _players;
  num? get players => _$this._players;
  set players(num? players) => _$this._players = players;

  num? _banned;
  num? get banned => _$this._banned;
  set banned(num? banned) => _$this._banned = banned;

  num? _games;
  num? get games => _$this._games;
  set games(num? games) => _$this._games = games;

  num? _openReports;
  num? get openReports => _$this._openReports;
  set openReports(num? openReports) => _$this._openReports = openReports;

  num? _liveGroups;
  num? get liveGroups => _$this._liveGroups;
  set liveGroups(num? liveGroups) => _$this._liveGroups = liveGroups;

  TotalsDtoBuilder() {
    TotalsDto._defaults(this);
  }

  TotalsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _players = $v.players;
      _banned = $v.banned;
      _games = $v.games;
      _openReports = $v.openReports;
      _liveGroups = $v.liveGroups;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TotalsDto other) {
    _$v = other as _$TotalsDto;
  }

  @override
  void update(void Function(TotalsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TotalsDto build() => _build();

  _$TotalsDto _build() {
    final _$result = _$v ??
        _$TotalsDto._(
          players: BuiltValueNullFieldError.checkNotNull(
              players, r'TotalsDto', 'players'),
          banned: BuiltValueNullFieldError.checkNotNull(
              banned, r'TotalsDto', 'banned'),
          games: BuiltValueNullFieldError.checkNotNull(
              games, r'TotalsDto', 'games'),
          openReports: BuiltValueNullFieldError.checkNotNull(
              openReports, r'TotalsDto', 'openReports'),
          liveGroups: BuiltValueNullFieldError.checkNotNull(
              liveGroups, r'TotalsDto', 'liveGroups'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
