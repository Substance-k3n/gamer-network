//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'id_visibility.g.dart';

class IdVisibility extends EnumClass {
  @BuiltValueEnumConst(wireName: r'public')
  static const IdVisibility public = _$public;
  @BuiltValueEnumConst(wireName: r'connections')
  static const IdVisibility connections = _$connections;

  static Serializer<IdVisibility> get serializer => _$idVisibilitySerializer;

  const IdVisibility._(String name) : super(name);

  static BuiltSet<IdVisibility> get values => _$values;
  static IdVisibility valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class IdVisibilityMixin = Object with _$IdVisibilityMixin;
