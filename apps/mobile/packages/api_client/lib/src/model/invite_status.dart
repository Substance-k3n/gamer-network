//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invite_status.g.dart';

/// expired as soon as expiresAt passes while pending.
class InviteStatus extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const InviteStatus pending = _$pending;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const InviteStatus accepted = _$accepted;
  @BuiltValueEnumConst(wireName: r'declined')
  static const InviteStatus declined = _$declined;
  @BuiltValueEnumConst(wireName: r'expired')
  static const InviteStatus expired = _$expired;

  static Serializer<InviteStatus> get serializer => _$inviteStatusSerializer;

  const InviteStatus._(String name) : super(name);

  static BuiltSet<InviteStatus> get values => _$values;
  static InviteStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class InviteStatusMixin = Object with _$InviteStatusMixin;
