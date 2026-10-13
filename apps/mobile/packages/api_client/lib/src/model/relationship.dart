//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'relationship.g.dart';

class Relationship extends EnumClass {
  @BuiltValueEnumConst(wireName: r'self')
  static const Relationship self = _$self;
  @BuiltValueEnumConst(wireName: r'none')
  static const Relationship none = _$none;
  @BuiltValueEnumConst(wireName: r'outgoing_request')
  static const Relationship outgoingRequest = _$outgoingRequest;
  @BuiltValueEnumConst(wireName: r'incoming_request')
  static const Relationship incomingRequest = _$incomingRequest;
  @BuiltValueEnumConst(wireName: r'connected')
  static const Relationship connected = _$connected;

  static Serializer<Relationship> get serializer => _$relationshipSerializer;

  const Relationship._(String name) : super(name);

  static BuiltSet<Relationship> get values => _$values;
  static Relationship valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class RelationshipMixin = Object with _$RelationshipMixin;
