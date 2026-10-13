// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_invite_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PlayInviteDto extends PlayInviteDto {
  @override
  final InviteWhen playWhen;
  @override
  final InviteStatus status;
  @override
  final String id;
  @override
  final UserCardDto from;
  @override
  final UserCardDto to;
  @override
  final GameRefDto game;
  @override
  final DateTime startsAt;
  @override
  final DateTime expiresAt;
  @override
  final DateTime createdAt;

  factory _$PlayInviteDto([void Function(PlayInviteDtoBuilder)? updates]) =>
      (PlayInviteDtoBuilder()..update(updates))._build();

  _$PlayInviteDto._(
      {required this.playWhen,
      required this.status,
      required this.id,
      required this.from,
      required this.to,
      required this.game,
      required this.startsAt,
      required this.expiresAt,
      required this.createdAt})
      : super._();
  @override
  PlayInviteDto rebuild(void Function(PlayInviteDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlayInviteDtoBuilder toBuilder() => PlayInviteDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlayInviteDto &&
        playWhen == other.playWhen &&
        status == other.status &&
        id == other.id &&
        from == other.from &&
        to == other.to &&
        game == other.game &&
        startsAt == other.startsAt &&
        expiresAt == other.expiresAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, playWhen.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlayInviteDto')
          ..add('playWhen', playWhen)
          ..add('status', status)
          ..add('id', id)
          ..add('from', from)
          ..add('to', to)
          ..add('game', game)
          ..add('startsAt', startsAt)
          ..add('expiresAt', expiresAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PlayInviteDtoBuilder
    implements Builder<PlayInviteDto, PlayInviteDtoBuilder> {
  _$PlayInviteDto? _$v;

  InviteWhen? _playWhen;
  InviteWhen? get playWhen => _$this._playWhen;
  set playWhen(InviteWhen? playWhen) => _$this._playWhen = playWhen;

  InviteStatus? _status;
  InviteStatus? get status => _$this._status;
  set status(InviteStatus? status) => _$this._status = status;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  UserCardDtoBuilder? _from;
  UserCardDtoBuilder get from => _$this._from ??= UserCardDtoBuilder();
  set from(UserCardDtoBuilder? from) => _$this._from = from;

  UserCardDtoBuilder? _to;
  UserCardDtoBuilder get to => _$this._to ??= UserCardDtoBuilder();
  set to(UserCardDtoBuilder? to) => _$this._to = to;

  GameRefDtoBuilder? _game;
  GameRefDtoBuilder get game => _$this._game ??= GameRefDtoBuilder();
  set game(GameRefDtoBuilder? game) => _$this._game = game;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PlayInviteDtoBuilder() {
    PlayInviteDto._defaults(this);
  }

  PlayInviteDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _playWhen = $v.playWhen;
      _status = $v.status;
      _id = $v.id;
      _from = $v.from.toBuilder();
      _to = $v.to.toBuilder();
      _game = $v.game.toBuilder();
      _startsAt = $v.startsAt;
      _expiresAt = $v.expiresAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlayInviteDto other) {
    _$v = other as _$PlayInviteDto;
  }

  @override
  void update(void Function(PlayInviteDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlayInviteDto build() => _build();

  _$PlayInviteDto _build() {
    _$PlayInviteDto _$result;
    try {
      _$result = _$v ??
          _$PlayInviteDto._(
            playWhen: BuiltValueNullFieldError.checkNotNull(
                playWhen, r'PlayInviteDto', 'playWhen'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PlayInviteDto', 'status'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PlayInviteDto', 'id'),
            from: from.build(),
            to: to.build(),
            game: game.build(),
            startsAt: BuiltValueNullFieldError.checkNotNull(
                startsAt, r'PlayInviteDto', 'startsAt'),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'PlayInviteDto', 'expiresAt'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PlayInviteDto', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'from';
        from.build();
        _$failedField = 'to';
        to.build();
        _$failedField = 'game';
        game.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PlayInviteDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
