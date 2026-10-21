//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_role.g.dart';

/// Null when you aren't a member (or are still pending).
class GroupRole extends EnumClass {
  @BuiltValueEnumConst(wireName: r'admin')
  static const GroupRole admin = _$admin;
  @BuiltValueEnumConst(wireName: r'member')
  static const GroupRole member = _$member;

  static Serializer<GroupRole> get serializer => _$groupRoleSerializer;

  const GroupRole._(String name) : super(name);

  static BuiltSet<GroupRole> get values => _$values;
  static GroupRole valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class GroupRoleMixin = Object with _$GroupRoleMixin;
