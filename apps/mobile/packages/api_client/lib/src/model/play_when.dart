//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'play_when.g.dart';

class PlayWhen extends EnumClass {
  @BuiltValueEnumConst(wireName: r'now')
  static const PlayWhen now = _$now;
  @BuiltValueEnumConst(wireName: r'tonight')
  static const PlayWhen tonight = _$tonight;
  @BuiltValueEnumConst(wireName: r'weekend')
  static const PlayWhen weekend = _$weekend;

  static Serializer<PlayWhen> get serializer => _$playWhenSerializer;

  const PlayWhen._(String name) : super(name);

  static BuiltSet<PlayWhen> get values => _$values;
  static PlayWhen valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PlayWhenMixin = Object with _$PlayWhenMixin;
