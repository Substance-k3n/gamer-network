// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckInDto extends CheckInDto {
  @override
  final String id;
  @override
  final UserCardDto other;
  @override
  final GameRefDto? game;
  @override
  final String? listingId;
  @override
  final String? playInviteId;
  @override
  final DateTime dueAt;

  factory _$CheckInDto([void Function(CheckInDtoBuilder)? updates]) =>
      (CheckInDtoBuilder()..update(updates))._build();

  _$CheckInDto._(
      {required this.id,
      required this.other,
      this.game,
      this.listingId,
      this.playInviteId,
      required this.dueAt})
      : super._();
  @override
  CheckInDto rebuild(void Function(CheckInDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckInDtoBuilder toBuilder() => CheckInDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckInDto &&
        id == other.id &&
        this.other == other.other &&
        game == other.game &&
        listingId == other.listingId &&
        playInviteId == other.playInviteId &&
        dueAt == other.dueAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, other.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, playInviteId.hashCode);
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckInDto')
          ..add('id', id)
          ..add('other', other)
          ..add('game', game)
          ..add('listingId', listingId)
          ..add('playInviteId', playInviteId)
          ..add('dueAt', dueAt))
        .toString();
  }
}

class CheckInDtoBuilder implements Builder<CheckInDto, CheckInDtoBuilder> {
  _$CheckInDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  UserCardDtoBuilder? _other;
  UserCardDtoBuilder get other => _$this._other ??= UserCardDtoBuilder();
  set other(UserCardDtoBuilder? other) => _$this._other = other;

  GameRefDtoBuilder? _game;
  GameRefDtoBuilder get game => _$this._game ??= GameRefDtoBuilder();
  set game(GameRefDtoBuilder? game) => _$this._game = game;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _playInviteId;
  String? get playInviteId => _$this._playInviteId;
  set playInviteId(String? playInviteId) => _$this._playInviteId = playInviteId;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(DateTime? dueAt) => _$this._dueAt = dueAt;

  CheckInDtoBuilder() {
    CheckInDto._defaults(this);
  }

  CheckInDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _other = $v.other.toBuilder();
      _game = $v.game?.toBuilder();
      _listingId = $v.listingId;
      _playInviteId = $v.playInviteId;
      _dueAt = $v.dueAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckInDto other) {
    _$v = other as _$CheckInDto;
  }

  @override
  void update(void Function(CheckInDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckInDto build() => _build();

  _$CheckInDto _build() {
    _$CheckInDto _$result;
    try {
      _$result = _$v ??
          _$CheckInDto._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'CheckInDto', 'id'),
            other: other.build(),
            game: _game?.build(),
            listingId: listingId,
            playInviteId: playInviteId,
            dueAt: BuiltValueNullFieldError.checkNotNull(
                dueAt, r'CheckInDto', 'dueAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'other';
        other.build();
        _$failedField = 'game';
        _game?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CheckInDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
