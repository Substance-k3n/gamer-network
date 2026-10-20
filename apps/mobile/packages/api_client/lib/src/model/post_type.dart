//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'post_type.g.dart';

class PostType extends EnumClass {
  @BuiltValueEnumConst(wireName: r'discussion')
  static const PostType discussion = _$discussion;
  @BuiltValueEnumConst(wireName: r'gameplay')
  static const PostType gameplay = _$gameplay;
  @BuiltValueEnumConst(wireName: r'recruitment')
  static const PostType recruitment = _$recruitment;
  @BuiltValueEnumConst(wireName: r'poll')
  static const PostType poll = _$poll;
  @BuiltValueEnumConst(wireName: r'milestone')
  static const PostType milestone = _$milestone;
  @BuiltValueEnumConst(wireName: r'question')
  static const PostType question = _$question;
  @BuiltValueEnumConst(wireName: r'looking_for_players')
  static const PostType lookingForPlayers = _$lookingForPlayers;
  @BuiltValueEnumConst(wireName: r'tip_guide')
  static const PostType tipGuide = _$tipGuide;
  @BuiltValueEnumConst(wireName: r'review')
  static const PostType review = _$review;
  @BuiltValueEnumConst(wireName: r'event')
  static const PostType event = _$event;
  @BuiltValueEnumConst(wireName: r'meme')
  static const PostType meme = _$meme;

  static Serializer<PostType> get serializer => _$postTypeSerializer;

  const PostType._(String name) : super(name);

  static BuiltSet<PostType> get values => _$values;
  static PostType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PostTypeMixin = Object with _$PostTypeMixin;
