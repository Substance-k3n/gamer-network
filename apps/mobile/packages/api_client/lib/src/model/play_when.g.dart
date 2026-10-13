// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_when.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlayWhen _$now = const PlayWhen._('now');
const PlayWhen _$tonight = const PlayWhen._('tonight');
const PlayWhen _$weekend = const PlayWhen._('weekend');

PlayWhen _$valueOf(String name) {
  switch (name) {
    case 'now':
      return _$now;
    case 'tonight':
      return _$tonight;
    case 'weekend':
      return _$weekend;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlayWhen> _$values = BuiltSet<PlayWhen>(const <PlayWhen>[
  _$now,
  _$tonight,
  _$weekend,
]);

class _$PlayWhenMeta {
  const _$PlayWhenMeta();
  PlayWhen get now => _$now;
  PlayWhen get tonight => _$tonight;
  PlayWhen get weekend => _$weekend;
  PlayWhen valueOf(String name) => _$valueOf(name);
  BuiltSet<PlayWhen> get values => _$values;
}

abstract class _$PlayWhenMixin {
  // ignore: non_constant_identifier_names
  _$PlayWhenMeta get PlayWhen => const _$PlayWhenMeta();
}

Serializer<PlayWhen> _$playWhenSerializer = _$PlayWhenSerializer();

class _$PlayWhenSerializer implements PrimitiveSerializer<PlayWhen> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'now': 'now',
    'tonight': 'tonight',
    'weekend': 'weekend',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'now': 'now',
    'tonight': 'tonight',
    'weekend': 'weekend',
  };

  @override
  final Iterable<Type> types = const <Type>[PlayWhen];
  @override
  final String wireName = 'PlayWhen';

  @override
  Object serialize(Serializers serializers, PlayWhen object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PlayWhen deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PlayWhen.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
