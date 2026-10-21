//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'post_audience.g.dart';

class PostAudience extends EnumClass {
  @BuiltValueEnumConst(wireName: r'everyone')
  static const PostAudience everyone = _$everyone;
  @BuiltValueEnumConst(wireName: r'connections')
  static const PostAudience connections = _$connections;

  static Serializer<PostAudience> get serializer => _$postAudienceSerializer;

  const PostAudience._(String name) : super(name);

  static BuiltSet<PostAudience> get values => _$values;
  static PostAudience valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PostAudienceMixin = Object with _$PostAudienceMixin;
