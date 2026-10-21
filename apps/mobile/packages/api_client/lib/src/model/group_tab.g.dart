// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_tab.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GroupTab _$discover = const GroupTab._('discover');
const GroupTab _$mine = const GroupTab._('mine');

GroupTab _$valueOf(String name) {
  switch (name) {
    case 'discover':
      return _$discover;
    case 'mine':
      return _$mine;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GroupTab> _$values = BuiltSet<GroupTab>(const <GroupTab>[
  _$discover,
  _$mine,
]);

class _$GroupTabMeta {
  const _$GroupTabMeta();
  GroupTab get discover => _$discover;
  GroupTab get mine => _$mine;
  GroupTab valueOf(String name) => _$valueOf(name);
  BuiltSet<GroupTab> get values => _$values;
}

abstract class _$GroupTabMixin {
  // ignore: non_constant_identifier_names
  _$GroupTabMeta get GroupTab => const _$GroupTabMeta();
}

Serializer<GroupTab> _$groupTabSerializer = _$GroupTabSerializer();

class _$GroupTabSerializer implements PrimitiveSerializer<GroupTab> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'discover': 'discover',
    'mine': 'mine',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'discover': 'discover',
    'mine': 'mine',
  };

  @override
  final Iterable<Type> types = const <Type>[GroupTab];
  @override
  final String wireName = 'GroupTab';

  @override
  Object serialize(Serializers serializers, GroupTab object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GroupTab deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupTab.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
