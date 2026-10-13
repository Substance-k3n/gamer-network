//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invite_when.g.dart';

class InviteWhen extends EnumClass {
  @BuiltValueEnumConst(wireName: r'now')
  static const InviteWhen now = _$now;
  @BuiltValueEnumConst(wireName: r'in_30_min')
  static const InviteWhen in30Min = _$in30Min;
  @BuiltValueEnumConst(wireName: r'tonight')
  static const InviteWhen tonight = _$tonight;

  static Serializer<InviteWhen> get serializer => _$inviteWhenSerializer;

  const InviteWhen._(String name) : super(name);

  static BuiltSet<InviteWhen> get values => _$values;
  static InviteWhen valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class InviteWhenMixin = Object with _$InviteWhenMixin;
