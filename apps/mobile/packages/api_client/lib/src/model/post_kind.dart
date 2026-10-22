//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'post_kind.g.dart';

/// Draw by this: follows from type.
class PostKind extends EnumClass {
  @BuiltValueEnumConst(wireName: r'text')
  static const PostKind text = _$text;
  @BuiltValueEnumConst(wireName: r'moment')
  static const PostKind moment = _$moment;
  @BuiltValueEnumConst(wireName: r'discussion')
  static const PostKind discussion = _$discussion;
  @BuiltValueEnumConst(wireName: r'poll')
  static const PostKind poll = _$poll;
  @BuiltValueEnumConst(wireName: r'recruit')
  static const PostKind recruit = _$recruit;

  static Serializer<PostKind> get serializer => _$postKindSerializer;

  const PostKind._(String name) : super(name);

  static BuiltSet<PostKind> get values => _$values;
  static PostKind valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PostKindMixin = Object with _$PostKindMixin;
