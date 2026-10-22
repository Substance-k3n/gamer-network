// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_tone.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GroupTone _$accent = const GroupTone._('accent');
const GroupTone _$lav = const GroupTone._('lav');
const GroupTone _$soft = const GroupTone._('soft');
const GroupTone _$grey = const GroupTone._('grey');

GroupTone _$valueOf(String name) {
  switch (name) {
    case 'accent':
      return _$accent;
    case 'lav':
      return _$lav;
    case 'soft':
      return _$soft;
    case 'grey':
      return _$grey;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GroupTone> _$values = BuiltSet<GroupTone>(const <GroupTone>[
  _$accent,
  _$lav,
  _$soft,
  _$grey,
]);

class _$GroupToneMeta {
  const _$GroupToneMeta();
  GroupTone get accent => _$accent;
  GroupTone get lav => _$lav;
  GroupTone get soft => _$soft;
  GroupTone get grey => _$grey;
  GroupTone valueOf(String name) => _$valueOf(name);
  BuiltSet<GroupTone> get values => _$values;
}

abstract class _$GroupToneMixin {
  // ignore: non_constant_identifier_names
  _$GroupToneMeta get GroupTone => const _$GroupToneMeta();
}

Serializer<GroupTone> _$groupToneSerializer = _$GroupToneSerializer();

class _$GroupToneSerializer implements PrimitiveSerializer<GroupTone> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'accent': 'accent',
    'lav': 'lav',
    'soft': 'soft',
    'grey': 'grey',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'accent': 'accent',
    'lav': 'lav',
    'soft': 'soft',
    'grey': 'grey',
  };

  @override
  final Iterable<Type> types = const <Type>[GroupTone];
  @override
  final String wireName = 'GroupTone';

  @override
  Object serialize(Serializers serializers, GroupTone object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GroupTone deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupTone.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
