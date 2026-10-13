//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'resolve_action.g.dart';

/// dismiss: no action. warn, remove_listing (the reported listing), ban (the target).
class ResolveAction extends EnumClass {
  @BuiltValueEnumConst(wireName: r'dismiss')
  static const ResolveAction dismiss = _$dismiss;
  @BuiltValueEnumConst(wireName: r'warn')
  static const ResolveAction warn = _$warn;
  @BuiltValueEnumConst(wireName: r'remove_listing')
  static const ResolveAction removeListing = _$removeListing;
  @BuiltValueEnumConst(wireName: r'ban')
  static const ResolveAction ban = _$ban;

  static Serializer<ResolveAction> get serializer => _$resolveActionSerializer;

  const ResolveAction._(String name) : super(name);

  static BuiltSet<ResolveAction> get values => _$values;
  static ResolveAction valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ResolveActionMixin = Object with _$ResolveActionMixin;
