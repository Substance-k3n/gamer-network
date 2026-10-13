// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaming_id_kind.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GamingIdKind _$riot = const GamingIdKind._('riot');
const GamingIdKind _$steam = const GamingIdKind._('steam');
const GamingIdKind _$discord = const GamingIdKind._('discord');
const GamingIdKind _$playstation = const GamingIdKind._('playstation');
const GamingIdKind _$xbox = const GamingIdKind._('xbox');
const GamingIdKind _$epic = const GamingIdKind._('epic');
const GamingIdKind _$ea = const GamingIdKind._('ea');
const GamingIdKind _$activision = const GamingIdKind._('activision');
const GamingIdKind _$inGame = const GamingIdKind._('inGame');

GamingIdKind _$valueOf(String name) {
  switch (name) {
    case 'riot':
      return _$riot;
    case 'steam':
      return _$steam;
    case 'discord':
      return _$discord;
    case 'playstation':
      return _$playstation;
    case 'xbox':
      return _$xbox;
    case 'epic':
      return _$epic;
    case 'ea':
      return _$ea;
    case 'activision':
      return _$activision;
    case 'inGame':
      return _$inGame;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GamingIdKind> _$values =
    BuiltSet<GamingIdKind>(const <GamingIdKind>[
  _$riot,
  _$steam,
  _$discord,
  _$playstation,
  _$xbox,
  _$epic,
  _$ea,
  _$activision,
  _$inGame,
]);

class _$GamingIdKindMeta {
  const _$GamingIdKindMeta();
  GamingIdKind get riot => _$riot;
  GamingIdKind get steam => _$steam;
  GamingIdKind get discord => _$discord;
  GamingIdKind get playstation => _$playstation;
  GamingIdKind get xbox => _$xbox;
  GamingIdKind get epic => _$epic;
  GamingIdKind get ea => _$ea;
  GamingIdKind get activision => _$activision;
  GamingIdKind get inGame => _$inGame;
  GamingIdKind valueOf(String name) => _$valueOf(name);
  BuiltSet<GamingIdKind> get values => _$values;
}

abstract class _$GamingIdKindMixin {
  // ignore: non_constant_identifier_names
  _$GamingIdKindMeta get GamingIdKind => const _$GamingIdKindMeta();
}

Serializer<GamingIdKind> _$gamingIdKindSerializer = _$GamingIdKindSerializer();

class _$GamingIdKindSerializer implements PrimitiveSerializer<GamingIdKind> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'riot': 'riot',
    'steam': 'steam',
    'discord': 'discord',
    'playstation': 'playstation',
    'xbox': 'xbox',
    'epic': 'epic',
    'ea': 'ea',
    'activision': 'activision',
    'inGame': 'in_game',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'riot': 'riot',
    'steam': 'steam',
    'discord': 'discord',
    'playstation': 'playstation',
    'xbox': 'xbox',
    'epic': 'epic',
    'ea': 'ea',
    'activision': 'activision',
    'in_game': 'inGame',
  };

  @override
  final Iterable<Type> types = const <Type>[GamingIdKind];
  @override
  final String wireName = 'GamingIdKind';

  @override
  Object serialize(Serializers serializers, GamingIdKind object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GamingIdKind deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GamingIdKind.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
