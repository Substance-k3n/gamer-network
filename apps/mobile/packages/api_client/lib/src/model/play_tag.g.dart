// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_tag.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlayTag _$competitive = const PlayTag._('competitive');
const PlayTag _$casual = const PlayTag._('casual');
const PlayTag _$fps = const PlayTag._('fps');
const PlayTag _$rpg = const PlayTag._('rpg');
const PlayTag _$strategy = const PlayTag._('strategy');
const PlayTag _$coOp = const PlayTag._('coOp');
const PlayTag _$ranked = const PlayTag._('ranked');
const PlayTag _$achievementHunter = const PlayTag._('achievementHunter');
const PlayTag _$story = const PlayTag._('story');

PlayTag _$valueOf(String name) {
  switch (name) {
    case 'competitive':
      return _$competitive;
    case 'casual':
      return _$casual;
    case 'fps':
      return _$fps;
    case 'rpg':
      return _$rpg;
    case 'strategy':
      return _$strategy;
    case 'coOp':
      return _$coOp;
    case 'ranked':
      return _$ranked;
    case 'achievementHunter':
      return _$achievementHunter;
    case 'story':
      return _$story;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlayTag> _$values = BuiltSet<PlayTag>(const <PlayTag>[
  _$competitive,
  _$casual,
  _$fps,
  _$rpg,
  _$strategy,
  _$coOp,
  _$ranked,
  _$achievementHunter,
  _$story,
]);

class _$PlayTagMeta {
  const _$PlayTagMeta();
  PlayTag get competitive => _$competitive;
  PlayTag get casual => _$casual;
  PlayTag get fps => _$fps;
  PlayTag get rpg => _$rpg;
  PlayTag get strategy => _$strategy;
  PlayTag get coOp => _$coOp;
  PlayTag get ranked => _$ranked;
  PlayTag get achievementHunter => _$achievementHunter;
  PlayTag get story => _$story;
  PlayTag valueOf(String name) => _$valueOf(name);
  BuiltSet<PlayTag> get values => _$values;
}

abstract class _$PlayTagMixin {
  // ignore: non_constant_identifier_names
  _$PlayTagMeta get PlayTag => const _$PlayTagMeta();
}

Serializer<PlayTag> _$playTagSerializer = _$PlayTagSerializer();

class _$PlayTagSerializer implements PrimitiveSerializer<PlayTag> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'competitive': 'competitive',
    'casual': 'casual',
    'fps': 'fps',
    'rpg': 'rpg',
    'strategy': 'strategy',
    'coOp': 'co_op',
    'ranked': 'ranked',
    'achievementHunter': 'achievement_hunter',
    'story': 'story',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'competitive': 'competitive',
    'casual': 'casual',
    'fps': 'fps',
    'rpg': 'rpg',
    'strategy': 'strategy',
    'co_op': 'coOp',
    'ranked': 'ranked',
    'achievement_hunter': 'achievementHunter',
    'story': 'story',
  };

  @override
  final Iterable<Type> types = const <Type>[PlayTag];
  @override
  final String wireName = 'PlayTag';

  @override
  Object serialize(Serializers serializers, PlayTag object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PlayTag deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PlayTag.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
