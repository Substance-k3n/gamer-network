// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_listing_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateListingBodyDurationHoursEnum
    _$createListingBodyDurationHoursEnum_number2 =
    const CreateListingBodyDurationHoursEnum._('number2');
const CreateListingBodyDurationHoursEnum
    _$createListingBodyDurationHoursEnum_number6 =
    const CreateListingBodyDurationHoursEnum._('number6');
const CreateListingBodyDurationHoursEnum
    _$createListingBodyDurationHoursEnum_number24 =
    const CreateListingBodyDurationHoursEnum._('number24');

CreateListingBodyDurationHoursEnum _$createListingBodyDurationHoursEnumValueOf(
    String name) {
  switch (name) {
    case 'number2':
      return _$createListingBodyDurationHoursEnum_number2;
    case 'number6':
      return _$createListingBodyDurationHoursEnum_number6;
    case 'number24':
      return _$createListingBodyDurationHoursEnum_number24;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateListingBodyDurationHoursEnum>
    _$createListingBodyDurationHoursEnumValues = BuiltSet<
        CreateListingBodyDurationHoursEnum>(const <CreateListingBodyDurationHoursEnum>[
  _$createListingBodyDurationHoursEnum_number2,
  _$createListingBodyDurationHoursEnum_number6,
  _$createListingBodyDurationHoursEnum_number24,
]);

Serializer<CreateListingBodyDurationHoursEnum>
    _$createListingBodyDurationHoursEnumSerializer =
    _$CreateListingBodyDurationHoursEnumSerializer();

class _$CreateListingBodyDurationHoursEnumSerializer
    implements PrimitiveSerializer<CreateListingBodyDurationHoursEnum> {
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
  final Iterable<Type> types = const <Type>[CreateListingBodyDurationHoursEnum];
  @override
  final String wireName = 'CreateListingBodyDurationHoursEnum';

  @override
  Object serialize(
          Serializers serializers, CreateListingBodyDurationHoursEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateListingBodyDurationHoursEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateListingBodyDurationHoursEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateListingBody extends CreateListingBody {
  @override
  final Platform platform;
  @override
  final Voice voice;
  @override
  final PlayStyle style;
  @override
  final PlayWhen playWhen;
  @override
  final CreateListingBodyDurationHoursEnum durationHours;
  @override
  final String gameId;
  @override
  final String? modeId;
  @override
  final String? rankId;
  @override
  final num partySize;
  @override
  final String? note;

  factory _$CreateListingBody(
          [void Function(CreateListingBodyBuilder)? updates]) =>
      (CreateListingBodyBuilder()..update(updates))._build();

  _$CreateListingBody._(
      {required this.platform,
      required this.voice,
      required this.style,
      required this.playWhen,
      required this.durationHours,
      required this.gameId,
      this.modeId,
      this.rankId,
      required this.partySize,
      this.note})
      : super._();
  @override
  CreateListingBody rebuild(void Function(CreateListingBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateListingBodyBuilder toBuilder() =>
      CreateListingBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateListingBody &&
        platform == other.platform &&
        voice == other.voice &&
        style == other.style &&
        playWhen == other.playWhen &&
        durationHours == other.durationHours &&
        gameId == other.gameId &&
        modeId == other.modeId &&
        rankId == other.rankId &&
        partySize == other.partySize &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, voice.hashCode);
    _$hash = $jc(_$hash, style.hashCode);
    _$hash = $jc(_$hash, playWhen.hashCode);
    _$hash = $jc(_$hash, durationHours.hashCode);
    _$hash = $jc(_$hash, gameId.hashCode);
    _$hash = $jc(_$hash, modeId.hashCode);
    _$hash = $jc(_$hash, rankId.hashCode);
    _$hash = $jc(_$hash, partySize.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateListingBody')
          ..add('platform', platform)
          ..add('voice', voice)
          ..add('style', style)
          ..add('playWhen', playWhen)
          ..add('durationHours', durationHours)
          ..add('gameId', gameId)
          ..add('modeId', modeId)
          ..add('rankId', rankId)
          ..add('partySize', partySize)
          ..add('note', note))
        .toString();
  }
}

class CreateListingBodyBuilder
    implements Builder<CreateListingBody, CreateListingBodyBuilder> {
  _$CreateListingBody? _$v;

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

  CreateListingBodyDurationHoursEnum? _durationHours;
  CreateListingBodyDurationHoursEnum? get durationHours =>
      _$this._durationHours;
  set durationHours(CreateListingBodyDurationHoursEnum? durationHours) =>
      _$this._durationHours = durationHours;

  String? _gameId;
  String? get gameId => _$this._gameId;
  set gameId(String? gameId) => _$this._gameId = gameId;

  String? _modeId;
  String? get modeId => _$this._modeId;
  set modeId(String? modeId) => _$this._modeId = modeId;

  String? _rankId;
  String? get rankId => _$this._rankId;
  set rankId(String? rankId) => _$this._rankId = rankId;

  num? _partySize;
  num? get partySize => _$this._partySize;
  set partySize(num? partySize) => _$this._partySize = partySize;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CreateListingBodyBuilder() {
    CreateListingBody._defaults(this);
  }

  CreateListingBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platform = $v.platform;
      _voice = $v.voice;
      _style = $v.style;
      _playWhen = $v.playWhen;
      _durationHours = $v.durationHours;
      _gameId = $v.gameId;
      _modeId = $v.modeId;
      _rankId = $v.rankId;
      _partySize = $v.partySize;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateListingBody other) {
    _$v = other as _$CreateListingBody;
  }

  @override
  void update(void Function(CreateListingBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateListingBody build() => _build();

  _$CreateListingBody _build() {
    final _$result = _$v ??
        _$CreateListingBody._(
          platform: BuiltValueNullFieldError.checkNotNull(
              platform, r'CreateListingBody', 'platform'),
          voice: BuiltValueNullFieldError.checkNotNull(
              voice, r'CreateListingBody', 'voice'),
          style: BuiltValueNullFieldError.checkNotNull(
              style, r'CreateListingBody', 'style'),
          playWhen: BuiltValueNullFieldError.checkNotNull(
              playWhen, r'CreateListingBody', 'playWhen'),
          durationHours: BuiltValueNullFieldError.checkNotNull(
              durationHours, r'CreateListingBody', 'durationHours'),
          gameId: BuiltValueNullFieldError.checkNotNull(
              gameId, r'CreateListingBody', 'gameId'),
          modeId: modeId,
          rankId: rankId,
          partySize: BuiltValueNullFieldError.checkNotNull(
              partySize, r'CreateListingBody', 'partySize'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
