//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'play_tag.g.dart';

class PlayTag extends EnumClass {
  @BuiltValueEnumConst(wireName: r'competitive')
  static const PlayTag competitive = _$competitive;
  @BuiltValueEnumConst(wireName: r'casual')
  static const PlayTag casual = _$casual;
  @BuiltValueEnumConst(wireName: r'fps')
  static const PlayTag fps = _$fps;
  @BuiltValueEnumConst(wireName: r'rpg')
  static const PlayTag rpg = _$rpg;
  @BuiltValueEnumConst(wireName: r'strategy')
  static const PlayTag strategy = _$strategy;
  @BuiltValueEnumConst(wireName: r'co_op')
  static const PlayTag coOp = _$coOp;
  @BuiltValueEnumConst(wireName: r'ranked')
  static const PlayTag ranked = _$ranked;
  @BuiltValueEnumConst(wireName: r'achievement_hunter')
  static const PlayTag achievementHunter = _$achievementHunter;
  @BuiltValueEnumConst(wireName: r'story')
  static const PlayTag story = _$story;

  static Serializer<PlayTag> get serializer => _$playTagSerializer;

  const PlayTag._(String name) : super(name);

  static BuiltSet<PlayTag> get values => _$values;
  static PlayTag valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PlayTagMixin = Object with _$PlayTagMixin;
