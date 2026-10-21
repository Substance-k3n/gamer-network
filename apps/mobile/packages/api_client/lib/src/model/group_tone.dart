//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_tone.g.dart';

class GroupTone extends EnumClass {
  @BuiltValueEnumConst(wireName: r'accent')
  static const GroupTone accent = _$accent;
  @BuiltValueEnumConst(wireName: r'lav')
  static const GroupTone lav = _$lav;
  @BuiltValueEnumConst(wireName: r'soft')
  static const GroupTone soft = _$soft;
  @BuiltValueEnumConst(wireName: r'grey')
  static const GroupTone grey = _$grey;

  static Serializer<GroupTone> get serializer => _$groupToneSerializer;

  const GroupTone._(String name) : super(name);

  static BuiltSet<GroupTone> get values => _$values;
  static GroupTone valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class GroupToneMixin = Object with _$GroupToneMixin;
