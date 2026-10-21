//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'membership_status.g.dart';

/// pending: you asked to join and wait for an admin. Null: not in it.
class MembershipStatus extends EnumClass {
  @BuiltValueEnumConst(wireName: r'member')
  static const MembershipStatus member = _$member;
  @BuiltValueEnumConst(wireName: r'pending')
  static const MembershipStatus pending = _$pending;

  static Serializer<MembershipStatus> get serializer =>
      _$membershipStatusSerializer;

  const MembershipStatus._(String name) : super(name);

  static BuiltSet<MembershipStatus> get values => _$values;
  static MembershipStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MembershipStatusMixin = Object with _$MembershipStatusMixin;
