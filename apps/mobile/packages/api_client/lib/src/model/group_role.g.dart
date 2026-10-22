// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_role.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GroupRole _$admin = const GroupRole._('admin');
const GroupRole _$member = const GroupRole._('member');

GroupRole _$valueOf(String name) {
  switch (name) {
    case 'admin':
      return _$admin;
    case 'member':
      return _$member;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GroupRole> _$values = BuiltSet<GroupRole>(const <GroupRole>[
  _$admin,
  _$member,
]);

class _$GroupRoleMeta {
  const _$GroupRoleMeta();
  GroupRole get admin => _$admin;
  GroupRole get member => _$member;
  GroupRole valueOf(String name) => _$valueOf(name);
  BuiltSet<GroupRole> get values => _$values;
}

abstract class _$GroupRoleMixin {
  // ignore: non_constant_identifier_names
  _$GroupRoleMeta get GroupRole => const _$GroupRoleMeta();
}

Serializer<GroupRole> _$groupRoleSerializer = _$GroupRoleSerializer();

class _$GroupRoleSerializer implements PrimitiveSerializer<GroupRole> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'admin': 'admin',
    'member': 'member',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'admin': 'admin',
    'member': 'member',
  };

  @override
  final Iterable<Type> types = const <Type>[GroupRole];
  @override
  final String wireName = 'GroupRole';

  @override
  Object serialize(Serializers serializers, GroupRole object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GroupRole deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupRole.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
