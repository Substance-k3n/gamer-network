// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_kind.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GroupKind _$game = const GroupKind._('game');
const GroupKind _$city = const GroupKind._('city');
const GroupKind _$campus = const GroupKind._('campus');
const GroupKind _$squad = const GroupKind._('squad');

GroupKind _$valueOf(String name) {
  switch (name) {
    case 'game':
      return _$game;
    case 'city':
      return _$city;
    case 'campus':
      return _$campus;
    case 'squad':
      return _$squad;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GroupKind> _$values = BuiltSet<GroupKind>(const <GroupKind>[
  _$game,
  _$city,
  _$campus,
  _$squad,
]);

class _$GroupKindMeta {
  const _$GroupKindMeta();
  GroupKind get game => _$game;
  GroupKind get city => _$city;
  GroupKind get campus => _$campus;
  GroupKind get squad => _$squad;
  GroupKind valueOf(String name) => _$valueOf(name);
  BuiltSet<GroupKind> get values => _$values;
}

abstract class _$GroupKindMixin {
  // ignore: non_constant_identifier_names
  _$GroupKindMeta get GroupKind => const _$GroupKindMeta();
}

Serializer<GroupKind> _$groupKindSerializer = _$GroupKindSerializer();

class _$GroupKindSerializer implements PrimitiveSerializer<GroupKind> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'game': 'game',
    'city': 'city',
    'campus': 'campus',
    'squad': 'squad',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'game': 'game',
    'city': 'city',
    'campus': 'campus',
    'squad': 'squad',
  };

  @override
  final Iterable<Type> types = const <Type>[GroupKind];
  @override
  final String wireName = 'GroupKind';

  @override
  Object serialize(Serializers serializers, GroupKind object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GroupKind deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupKind.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
