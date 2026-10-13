// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlayerStatus _$looking = const PlayerStatus._('looking');
const PlayerStatus _$playing = const PlayerStatus._('playing');
const PlayerStatus _$availableTonight =
    const PlayerStatus._('availableTonight');
const PlayerStatus _$notAvailable = const PlayerStatus._('notAvailable');

PlayerStatus _$valueOf(String name) {
  switch (name) {
    case 'looking':
      return _$looking;
    case 'playing':
      return _$playing;
    case 'availableTonight':
      return _$availableTonight;
    case 'notAvailable':
      return _$notAvailable;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlayerStatus> _$values =
    BuiltSet<PlayerStatus>(const <PlayerStatus>[
  _$looking,
  _$playing,
  _$availableTonight,
  _$notAvailable,
]);

class _$PlayerStatusMeta {
  const _$PlayerStatusMeta();
  PlayerStatus get looking => _$looking;
  PlayerStatus get playing => _$playing;
  PlayerStatus get availableTonight => _$availableTonight;
  PlayerStatus get notAvailable => _$notAvailable;
  PlayerStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<PlayerStatus> get values => _$values;
}

abstract class _$PlayerStatusMixin {
  // ignore: non_constant_identifier_names
  _$PlayerStatusMeta get PlayerStatus => const _$PlayerStatusMeta();
}

Serializer<PlayerStatus> _$playerStatusSerializer = _$PlayerStatusSerializer();

class _$PlayerStatusSerializer implements PrimitiveSerializer<PlayerStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'looking': 'looking',
    'playing': 'playing',
    'availableTonight': 'available_tonight',
    'notAvailable': 'not_available',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'looking': 'looking',
    'playing': 'playing',
    'available_tonight': 'availableTonight',
    'not_available': 'notAvailable',
  };

  @override
  final Iterable<Type> types = const <Type>[PlayerStatus];
  @override
  final String wireName = 'PlayerStatus';

  @override
  Object serialize(Serializers serializers, PlayerStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PlayerStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PlayerStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
