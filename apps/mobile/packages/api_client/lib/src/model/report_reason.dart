//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'report_reason.g.dart';

class ReportReason extends EnumClass {
  @BuiltValueEnumConst(wireName: r'harassment')
  static const ReportReason harassment = _$harassment;
  @BuiltValueEnumConst(wireName: r'hate')
  static const ReportReason hate = _$hate;
  @BuiltValueEnumConst(wireName: r'sexual_content')
  static const ReportReason sexualContent = _$sexualContent;
  @BuiltValueEnumConst(wireName: r'underage')
  static const ReportReason underage = _$underage;
  @BuiltValueEnumConst(wireName: r'spam')
  static const ReportReason spam = _$spam;
  @BuiltValueEnumConst(wireName: r'impersonation')
  static const ReportReason impersonation = _$impersonation;
  @BuiltValueEnumConst(wireName: r'cheating_or_scam')
  static const ReportReason cheatingOrScam = _$cheatingOrScam;
  @BuiltValueEnumConst(wireName: r'other')
  static const ReportReason other = _$other;

  static Serializer<ReportReason> get serializer => _$reportReasonSerializer;

  const ReportReason._(String name) : super(name);

  static BuiltSet<ReportReason> get values => _$values;
  static ReportReason valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ReportReasonMixin = Object with _$ReportReasonMixin;
