// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_listing_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicListingDto extends PublicListingDto {
  @override
  final Platform platform;
  @override
  final Voice voice;
  @override
  final PlayWhen playWhen;
  @override
  final ListingStatus status;
  @override
  final String id;
  @override
  final String ownerDisplayName;
  @override
  final String? ownerAvatarUrl;
  @override
  final GameRefDto game;
  @override
  final ModeRefDto? mode;
  @override
  final RankRefDto? rank;
  @override
  final num partySize;
  @override
  final num filled;
  @override
  final DateTime startsAt;
  @override
  final DateTime expiresAt;
  @override
  final String? note;

  factory _$PublicListingDto(
          [void Function(PublicListingDtoBuilder)? updates]) =>
      (PublicListingDtoBuilder()..update(updates))._build();

  _$PublicListingDto._(
      {required this.platform,
      required this.voice,
      required this.playWhen,
      required this.status,
      required this.id,
      required this.ownerDisplayName,
      this.ownerAvatarUrl,
      required this.game,
      this.mode,
      this.rank,
      required this.partySize,
      required this.filled,
      required this.startsAt,
      required this.expiresAt,
      this.note})
      : super._();
  @override
  PublicListingDto rebuild(void Function(PublicListingDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicListingDtoBuilder toBuilder() =>
      PublicListingDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicListingDto &&
        platform == other.platform &&
        voice == other.voice &&
        playWhen == other.playWhen &&
        status == other.status &&
        id == other.id &&
        ownerDisplayName == other.ownerDisplayName &&
        ownerAvatarUrl == other.ownerAvatarUrl &&
        game == other.game &&
        mode == other.mode &&
        rank == other.rank &&
        partySize == other.partySize &&
        filled == other.filled &&
        startsAt == other.startsAt &&
        expiresAt == other.expiresAt &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, voice.hashCode);
    _$hash = $jc(_$hash, playWhen.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ownerDisplayName.hashCode);
    _$hash = $jc(_$hash, ownerAvatarUrl.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, rank.hashCode);
    _$hash = $jc(_$hash, partySize.hashCode);
    _$hash = $jc(_$hash, filled.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicListingDto')
          ..add('platform', platform)
          ..add('voice', voice)
          ..add('playWhen', playWhen)
          ..add('status', status)
          ..add('id', id)
          ..add('ownerDisplayName', ownerDisplayName)
          ..add('ownerAvatarUrl', ownerAvatarUrl)
          ..add('game', game)
          ..add('mode', mode)
          ..add('rank', rank)
          ..add('partySize', partySize)
          ..add('filled', filled)
          ..add('startsAt', startsAt)
          ..add('expiresAt', expiresAt)
          ..add('note', note))
        .toString();
  }
}

class PublicListingDtoBuilder
    implements Builder<PublicListingDto, PublicListingDtoBuilder> {
  _$PublicListingDto? _$v;

  Platform? _platform;
  Platform? get platform => _$this._platform;
  set platform(Platform? platform) => _$this._platform = platform;

  Voice? _voice;
  Voice? get voice => _$this._voice;
  set voice(Voice? voice) => _$this._voice = voice;

  PlayWhen? _playWhen;
  PlayWhen? get playWhen => _$this._playWhen;
  set playWhen(PlayWhen? playWhen) => _$this._playWhen = playWhen;

  ListingStatus? _status;
  ListingStatus? get status => _$this._status;
  set status(ListingStatus? status) => _$this._status = status;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _ownerDisplayName;
  String? get ownerDisplayName => _$this._ownerDisplayName;
  set ownerDisplayName(String? ownerDisplayName) =>
      _$this._ownerDisplayName = ownerDisplayName;

  String? _ownerAvatarUrl;
  String? get ownerAvatarUrl => _$this._ownerAvatarUrl;
  set ownerAvatarUrl(String? ownerAvatarUrl) =>
      _$this._ownerAvatarUrl = ownerAvatarUrl;

  GameRefDtoBuilder? _game;
  GameRefDtoBuilder get game => _$this._game ??= GameRefDtoBuilder();
  set game(GameRefDtoBuilder? game) => _$this._game = game;

  ModeRefDtoBuilder? _mode;
  ModeRefDtoBuilder get mode => _$this._mode ??= ModeRefDtoBuilder();
  set mode(ModeRefDtoBuilder? mode) => _$this._mode = mode;

  RankRefDtoBuilder? _rank;
  RankRefDtoBuilder get rank => _$this._rank ??= RankRefDtoBuilder();
  set rank(RankRefDtoBuilder? rank) => _$this._rank = rank;

  num? _partySize;
  num? get partySize => _$this._partySize;
  set partySize(num? partySize) => _$this._partySize = partySize;

  num? _filled;
  num? get filled => _$this._filled;
  set filled(num? filled) => _$this._filled = filled;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  PublicListingDtoBuilder() {
    PublicListingDto._defaults(this);
  }

  PublicListingDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platform = $v.platform;
      _voice = $v.voice;
      _playWhen = $v.playWhen;
      _status = $v.status;
      _id = $v.id;
      _ownerDisplayName = $v.ownerDisplayName;
      _ownerAvatarUrl = $v.ownerAvatarUrl;
      _game = $v.game.toBuilder();
      _mode = $v.mode?.toBuilder();
      _rank = $v.rank?.toBuilder();
      _partySize = $v.partySize;
      _filled = $v.filled;
      _startsAt = $v.startsAt;
      _expiresAt = $v.expiresAt;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicListingDto other) {
    _$v = other as _$PublicListingDto;
  }

  @override
  void update(void Function(PublicListingDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicListingDto build() => _build();

  _$PublicListingDto _build() {
    _$PublicListingDto _$result;
    try {
      _$result = _$v ??
          _$PublicListingDto._(
            platform: BuiltValueNullFieldError.checkNotNull(
                platform, r'PublicListingDto', 'platform'),
            voice: BuiltValueNullFieldError.checkNotNull(
                voice, r'PublicListingDto', 'voice'),
            playWhen: BuiltValueNullFieldError.checkNotNull(
                playWhen, r'PublicListingDto', 'playWhen'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PublicListingDto', 'status'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PublicListingDto', 'id'),
            ownerDisplayName: BuiltValueNullFieldError.checkNotNull(
                ownerDisplayName, r'PublicListingDto', 'ownerDisplayName'),
            ownerAvatarUrl: ownerAvatarUrl,
            game: game.build(),
            mode: _mode?.build(),
            rank: _rank?.build(),
            partySize: BuiltValueNullFieldError.checkNotNull(
                partySize, r'PublicListingDto', 'partySize'),
            filled: BuiltValueNullFieldError.checkNotNull(
                filled, r'PublicListingDto', 'filled'),
            startsAt: BuiltValueNullFieldError.checkNotNull(
                startsAt, r'PublicListingDto', 'startsAt'),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'PublicListingDto', 'expiresAt'),
            note: note,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'game';
        game.build();
        _$failedField = 'mode';
        _mode?.build();
        _$failedField = 'rank';
        _rank?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicListingDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
