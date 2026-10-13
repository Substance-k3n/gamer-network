//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'age_range.g.dart';

class AgeRange extends EnumClass {
  @BuiltValueEnumConst(wireName: r'16_17')
  static const AgeRange n1617 = _$n1617;
  @BuiltValueEnumConst(wireName: r'18_24')
  static const AgeRange n1824 = _$n1824;
  @BuiltValueEnumConst(wireName: r'25_34')
  static const AgeRange n2534 = _$n2534;
  @BuiltValueEnumConst(wireName: r'35_plus')
  static const AgeRange n35plus = _$n35plus;

  static Serializer<AgeRange> get serializer => _$ageRangeSerializer;

  const AgeRange._(String name) : super(name);

  static BuiltSet<AgeRange> get values => _$values;
  static AgeRange valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AgeRangeMixin = Object with _$AgeRangeMixin;
