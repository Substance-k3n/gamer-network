//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'poll_duration.g.dart';

/// How long it stays open: 1 day, 3 days or 1 week.
class PollDuration extends EnumClass {
  @BuiltValueEnumConst(wireName: r'1d')
  static const PollDuration n1d = _$n1d;
  @BuiltValueEnumConst(wireName: r'3d')
  static const PollDuration n3d = _$n3d;
  @BuiltValueEnumConst(wireName: r'1w')
  static const PollDuration n1w = _$n1w;

  static Serializer<PollDuration> get serializer => _$pollDurationSerializer;

  const PollDuration._(String name) : super(name);

  static BuiltSet<PollDuration> get values => _$values;
  static PollDuration valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PollDurationMixin = Object with _$PollDurationMixin;
