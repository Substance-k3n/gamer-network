//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'play_style.g.dart';

class PlayStyle extends EnumClass {
  @BuiltValueEnumConst(wireName: r'competitive')
  static const PlayStyle competitive = _$competitive;
  @BuiltValueEnumConst(wireName: r'casual')
  static const PlayStyle casual = _$casual;

  static Serializer<PlayStyle> get serializer => _$playStyleSerializer;

  const PlayStyle._(String name) : super(name);

  static BuiltSet<PlayStyle> get values => _$values;
  static PlayStyle valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PlayStyleMixin = Object with _$PlayStyleMixin;
