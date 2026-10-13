//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'voice.g.dart';

class Voice extends EnumClass {
  @BuiltValueEnumConst(wireName: r'required')
  static const Voice required_ = _$required_;
  @BuiltValueEnumConst(wireName: r'optional')
  static const Voice optional = _$optional;

  static Serializer<Voice> get serializer => _$voiceSerializer;

  const Voice._(String name) : super(name);

  static BuiltSet<Voice> get values => _$values;
  static Voice valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class VoiceMixin = Object with _$VoiceMixin;
