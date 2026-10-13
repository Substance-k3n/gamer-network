//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'check_in_answer.g.dart';

class CheckInAnswer extends EnumClass {
  @BuiltValueEnumConst(wireName: r'played')
  static const CheckInAnswer played = _$played;
  @BuiltValueEnumConst(wireName: r'not_yet')
  static const CheckInAnswer notYet = _$notYet;
  @BuiltValueEnumConst(wireName: r'no')
  static const CheckInAnswer no = _$no;

  static Serializer<CheckInAnswer> get serializer => _$checkInAnswerSerializer;

  const CheckInAnswer._(String name) : super(name);

  static BuiltSet<CheckInAnswer> get values => _$values;
  static CheckInAnswer valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CheckInAnswerMixin = Object with _$CheckInAnswerMixin;
