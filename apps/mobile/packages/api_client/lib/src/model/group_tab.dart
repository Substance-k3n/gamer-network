//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_tab.g.dart';

class GroupTab extends EnumClass {
  @BuiltValueEnumConst(wireName: r'discover')
  static const GroupTab discover = _$discover;
  @BuiltValueEnumConst(wireName: r'mine')
  static const GroupTab mine = _$mine;

  static Serializer<GroupTab> get serializer => _$groupTabSerializer;

  const GroupTab._(String name) : super(name);

  static BuiltSet<GroupTab> get values => _$values;
  static GroupTab valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class GroupTabMixin = Object with _$GroupTabMixin;
