//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_kind.g.dart';

class GroupKind extends EnumClass {
  @BuiltValueEnumConst(wireName: r'game')
  static const GroupKind game = _$game;
  @BuiltValueEnumConst(wireName: r'city')
  static const GroupKind city = _$city;
  @BuiltValueEnumConst(wireName: r'campus')
  static const GroupKind campus = _$campus;
  @BuiltValueEnumConst(wireName: r'squad')
  static const GroupKind squad = _$squad;

  static Serializer<GroupKind> get serializer => _$groupKindSerializer;

  const GroupKind._(String name) : super(name);

  static BuiltSet<GroupKind> get values => _$values;
  static GroupKind valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class GroupKindMixin = Object with _$GroupKindMixin;
