// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingDtoDurationHoursEnum _$listingDtoDurationHoursEnum_number2 =
    const ListingDtoDurationHoursEnum._('number2');
const ListingDtoDurationHoursEnum _$listingDtoDurationHoursEnum_number6 =
    const ListingDtoDurationHoursEnum._('number6');
const ListingDtoDurationHoursEnum _$listingDtoDurationHoursEnum_number24 =
    const ListingDtoDurationHoursEnum._('number24');

ListingDtoDurationHoursEnum _$listingDtoDurationHoursEnumValueOf(String name) {
  switch (name) {
    case 'number2':
      return _$listingDtoDurationHoursEnum_number2;
    case 'number6':
      return _$listingDtoDurationHoursEnum_number6;
    case 'number24':
      return _$listingDtoDurationHoursEnum_number24;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingDtoDurationHoursEnum>
    _$listingDtoDurationHoursEnumValues =
    BuiltSet<ListingDtoDurationHoursEnum>(const <ListingDtoDurationHoursEnum>[
  _$listingDtoDurationHoursEnum_number2,
  _$listingDtoDurationHoursEnum_number6,
  _$listingDtoDurationHoursEnum_number24,
]);

Serializer<ListingDtoDurationHoursEnum>
    _$listingDtoDurationHoursEnumSerializer =
    _$ListingDtoDurationHoursEnumSerializer();

class _$ListingDtoDurationHoursEnumSerializer
    implements PrimitiveSerializer<ListingDtoDurationHoursEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number2': 2,
    'number6': 6,
    'number24': 24,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    2: 'number2',
    6: 'number6',
    24: 'number24',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingDtoDurationHoursEnum];
  @override
  final String wireName = 'ListingDtoDurationHoursEnum';

  @override
  Object serialize(Serializers serializers, ListingDtoDurationHoursEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingDtoDurationHoursEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingDtoDurationHoursEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingDto extends ListingDto {
  @override
  final Platform platform;
  @override
  final Voice voice;
  @override
  final PlayStyle style;
  @override
  final PlayWhen playWhen;
  @override
  final ListingDtoDurationHoursEnum durationHours;
  @override
  final ListingStatus status;
  @override
  final String id;
  @override
  final UserCardDto owner;
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
  @override
  final DateTime createdAt;
  @override
  final MyRequestDto? myRequest;
  @override
  final String shareUrl;

  factory _$ListingDto([void Function(ListingDtoBuilder)? updates]) =>
      (ListingDtoBuilder()..update(updates))._build();

  _$ListingDto._(
      {required this.platform,
      required this.voice,
      required this.style,
      required this.playWhen,
      required this.durationHours,
      required this.status,
      required this.id,
      required this.owner,
      required this.game,
      this.mode,
      this.rank,
      required this.partySize,
      required this.filled,
      required this.startsAt,
      required this.expiresAt,
      this.note,
      required this.createdAt,
      this.myRequest,
      required this.shareUrl})
      : super._();
  @override
  ListingDto rebuild(void Function(ListingDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingDtoBuilder toBuilder() => ListingDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingDto &&
        platform == other.platform &&
        voice == other.voice &&
        style == other.style &&
        playWhen == other.playWhen &&
        durationHours == other.durationHours &&
        status == other.status &&
        id == other.id &&
        owner == other.owner &&
        game == other.game &&
        mode == other.mode &&
        rank == other.rank &&
        partySize == other.partySize &&
        filled == other.filled &&
        startsAt == other.startsAt &&
        expiresAt == other.expiresAt &&
        note == other.note &&
        createdAt == other.createdAt &&
        myRequest == other.myRequest &&
        shareUrl == other.shareUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, voice.hashCode);
    _$hash = $jc(_$hash, style.hashCode);
    _$hash = $jc(_$hash, playWhen.hashCode);
    _$hash = $jc(_$hash, durationHours.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, rank.hashCode);
    _$hash = $jc(_$hash, partySize.hashCode);
    _$hash = $jc(_$hash, filled.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, myRequest.hashCode);
    _$hash = $jc(_$hash, shareUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingDto')
          ..add('platform', platform)
          ..add('voice', voice)
          ..add('style', style)
          ..add('playWhen', playWhen)
          ..add('durationHours', durationHours)
          ..add('status', status)
          ..add('id', id)
          ..add('owner', owner)
          ..add('game', game)
          ..add('mode', mode)
          ..add('rank', rank)
          ..add('partySize', partySize)
          ..add('filled', filled)
          ..add('startsAt', startsAt)
          ..add('expiresAt', expiresAt)
          ..add('note', note)
          ..add('createdAt', createdAt)
          ..add('myRequest', myRequest)
          ..add('shareUrl', shareUrl))
        .toString();
  }
}

class ListingDtoBuilder implements Builder<ListingDto, ListingDtoBuilder> {
  _$ListingDto? _$v;

  Platform? _platform;
  Platform? get platform => _$this._platform;
  set platform(Platform? platform) => _$this._platform = platform;

  Voice? _voice;
  Voice? get voice => _$this._voice;
  set voice(Voice? voice) => _$this._voice = voice;

  PlayStyle? _style;
  PlayStyle? get style => _$this._style;
  set style(PlayStyle? style) => _$this._style = style;

  PlayWhen? _playWhen;
  PlayWhen? get playWhen => _$this._playWhen;
  set playWhen(PlayWhen? playWhen) => _$this._playWhen = playWhen;

  ListingDtoDurationHoursEnum? _durationHours;
  ListingDtoDurationHoursEnum? get durationHours => _$this._durationHours;
  set durationHours(ListingDtoDurationHoursEnum? durationHours) =>
      _$this._durationHours = durationHours;

  ListingStatus? _status;
  ListingStatus? get status => _$this._status;
  set status(ListingStatus? status) => _$this._status = status;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  UserCardDtoBuilder? _owner;
  UserCardDtoBuilder get owner => _$this._owner ??= UserCardDtoBuilder();
  set owner(UserCardDtoBuilder? owner) => _$this._owner = owner;

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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MyRequestDtoBuilder? _myRequest;
  MyRequestDtoBuilder get myRequest =>
      _$this._myRequest ??= MyRequestDtoBuilder();
  set myRequest(MyRequestDtoBuilder? myRequest) =>
      _$this._myRequest = myRequest;

  String? _shareUrl;
  String? get shareUrl => _$this._shareUrl;
  set shareUrl(String? shareUrl) => _$this._shareUrl = shareUrl;

  ListingDtoBuilder() {
    ListingDto._defaults(this);
  }

  ListingDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platform = $v.platform;
      _voice = $v.voice;
      _style = $v.style;
      _playWhen = $v.playWhen;
      _durationHours = $v.durationHours;
      _status = $v.status;
      _id = $v.id;
      _owner = $v.owner.toBuilder();
      _game = $v.game.toBuilder();
      _mode = $v.mode?.toBuilder();
      _rank = $v.rank?.toBuilder();
      _partySize = $v.partySize;
      _filled = $v.filled;
      _startsAt = $v.startsAt;
      _expiresAt = $v.expiresAt;
      _note = $v.note;
      _createdAt = $v.createdAt;
      _myRequest = $v.myRequest?.toBuilder();
      _shareUrl = $v.shareUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingDto other) {
    _$v = other as _$ListingDto;
  }

  @override
  void update(void Function(ListingDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingDto build() => _build();

  _$ListingDto _build() {
    _$ListingDto _$result;
    try {
      _$result = _$v ??
          _$ListingDto._(
            platform: BuiltValueNullFieldError.checkNotNull(
                platform, r'ListingDto', 'platform'),
            voice: BuiltValueNullFieldError.checkNotNull(
                voice, r'ListingDto', 'voice'),
            style: BuiltValueNullFieldError.checkNotNull(
                style, r'ListingDto', 'style'),
            playWhen: BuiltValueNullFieldError.checkNotNull(
                playWhen, r'ListingDto', 'playWhen'),
            durationHours: BuiltValueNullFieldError.checkNotNull(
                durationHours, r'ListingDto', 'durationHours'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ListingDto', 'status'),
            id: BuiltValueNullFieldError.checkNotNull(id, r'ListingDto', 'id'),
            owner: owner.build(),
            game: game.build(),
            mode: _mode?.build(),
            rank: _rank?.build(),
            partySize: BuiltValueNullFieldError.checkNotNull(
                partySize, r'ListingDto', 'partySize'),
            filled: BuiltValueNullFieldError.checkNotNull(
                filled, r'ListingDto', 'filled'),
            startsAt: BuiltValueNullFieldError.checkNotNull(
                startsAt, r'ListingDto', 'startsAt'),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'ListingDto', 'expiresAt'),
            note: note,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ListingDto', 'createdAt'),
            myRequest: _myRequest?.build(),
            shareUrl: BuiltValueNullFieldError.checkNotNull(
                shareUrl, r'ListingDto', 'shareUrl'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'owner';
        owner.build();
        _$failedField = 'game';
        game.build();
        _$failedField = 'mode';
        _mode?.build();
        _$failedField = 'rank';
        _rank?.build();

        _$failedField = 'myRequest';
        _myRequest?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListingDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
