// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Relationship _$self = const Relationship._('self');
const Relationship _$none = const Relationship._('none');
const Relationship _$outgoingRequest = const Relationship._('outgoingRequest');
const Relationship _$incomingRequest = const Relationship._('incomingRequest');
const Relationship _$connected = const Relationship._('connected');

Relationship _$valueOf(String name) {
  switch (name) {
    case 'self':
      return _$self;
    case 'none':
      return _$none;
    case 'outgoingRequest':
      return _$outgoingRequest;
    case 'incomingRequest':
      return _$incomingRequest;
    case 'connected':
      return _$connected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<Relationship> _$values =
    BuiltSet<Relationship>(const <Relationship>[
  _$self,
  _$none,
  _$outgoingRequest,
  _$incomingRequest,
  _$connected,
]);

class _$RelationshipMeta {
  const _$RelationshipMeta();
  Relationship get self => _$self;
  Relationship get none => _$none;
  Relationship get outgoingRequest => _$outgoingRequest;
  Relationship get incomingRequest => _$incomingRequest;
  Relationship get connected => _$connected;
  Relationship valueOf(String name) => _$valueOf(name);
  BuiltSet<Relationship> get values => _$values;
}

abstract class _$RelationshipMixin {
  // ignore: non_constant_identifier_names
  _$RelationshipMeta get Relationship => const _$RelationshipMeta();
}

Serializer<Relationship> _$relationshipSerializer = _$RelationshipSerializer();

class _$RelationshipSerializer implements PrimitiveSerializer<Relationship> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'self': 'self',
    'none': 'none',
    'outgoingRequest': 'outgoing_request',
    'incomingRequest': 'incoming_request',
    'connected': 'connected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'self': 'self',
    'none': 'none',
    'outgoing_request': 'outgoingRequest',
    'incoming_request': 'incomingRequest',
    'connected': 'connected',
  };

  @override
  final Iterable<Type> types = const <Type>[Relationship];
  @override
  final String wireName = 'Relationship';

  @override
  Object serialize(Serializers serializers, Relationship object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  Relationship deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      Relationship.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
