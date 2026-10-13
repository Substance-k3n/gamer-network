// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_visibility.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const IdVisibility _$public = const IdVisibility._('public');
const IdVisibility _$connections = const IdVisibility._('connections');

IdVisibility _$valueOf(String name) {
  switch (name) {
    case 'public':
      return _$public;
    case 'connections':
      return _$connections;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<IdVisibility> _$values =
    BuiltSet<IdVisibility>(const <IdVisibility>[
  _$public,
  _$connections,
]);

class _$IdVisibilityMeta {
  const _$IdVisibilityMeta();
  IdVisibility get public => _$public;
  IdVisibility get connections => _$connections;
  IdVisibility valueOf(String name) => _$valueOf(name);
  BuiltSet<IdVisibility> get values => _$values;
}

abstract class _$IdVisibilityMixin {
  // ignore: non_constant_identifier_names
  _$IdVisibilityMeta get IdVisibility => const _$IdVisibilityMeta();
}

Serializer<IdVisibility> _$idVisibilitySerializer = _$IdVisibilitySerializer();

class _$IdVisibilitySerializer implements PrimitiveSerializer<IdVisibility> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'public': 'public',
    'connections': 'connections',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'public': 'public',
    'connections': 'connections',
  };

  @override
  final Iterable<Type> types = const <Type>[IdVisibility];
  @override
  final String wireName = 'IdVisibility';

  @override
  Object serialize(Serializers serializers, IdVisibility object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  IdVisibility deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      IdVisibility.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
