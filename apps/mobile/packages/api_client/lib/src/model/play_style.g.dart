// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_style.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlayStyle _$competitive = const PlayStyle._('competitive');
const PlayStyle _$casual = const PlayStyle._('casual');

PlayStyle _$valueOf(String name) {
  switch (name) {
    case 'competitive':
      return _$competitive;
    case 'casual':
      return _$casual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlayStyle> _$values = BuiltSet<PlayStyle>(const <PlayStyle>[
  _$competitive,
  _$casual,
]);

class _$PlayStyleMeta {
  const _$PlayStyleMeta();
  PlayStyle get competitive => _$competitive;
  PlayStyle get casual => _$casual;
  PlayStyle valueOf(String name) => _$valueOf(name);
  BuiltSet<PlayStyle> get values => _$values;
}

abstract class _$PlayStyleMixin {
  // ignore: non_constant_identifier_names
  _$PlayStyleMeta get PlayStyle => const _$PlayStyleMeta();
}

Serializer<PlayStyle> _$playStyleSerializer = _$PlayStyleSerializer();

class _$PlayStyleSerializer implements PrimitiveSerializer<PlayStyle> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'competitive': 'competitive',
    'casual': 'casual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'competitive': 'competitive',
    'casual': 'casual',
  };

  @override
  final Iterable<Type> types = const <Type>[PlayStyle];
  @override
  final String wireName = 'PlayStyle';

  @override
  Object serialize(Serializers serializers, PlayStyle object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PlayStyle deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PlayStyle.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
