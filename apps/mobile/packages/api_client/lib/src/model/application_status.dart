//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'application_status.g.dart';

/// Your application, or null.
class ApplicationStatus extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const ApplicationStatus pending = _$pending;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const ApplicationStatus accepted = _$accepted;
  @BuiltValueEnumConst(wireName: r'declined')
  static const ApplicationStatus declined = _$declined;

  static Serializer<ApplicationStatus> get serializer =>
      _$applicationStatusSerializer;

  const ApplicationStatus._(String name) : super(name);

  static BuiltSet<ApplicationStatus> get values => _$values;
  static ApplicationStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ApplicationStatusMixin = Object with _$ApplicationStatusMixin;
