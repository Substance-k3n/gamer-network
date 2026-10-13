// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_reason.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReportReason _$harassment = const ReportReason._('harassment');
const ReportReason _$hate = const ReportReason._('hate');
const ReportReason _$sexualContent = const ReportReason._('sexualContent');
const ReportReason _$underage = const ReportReason._('underage');
const ReportReason _$spam = const ReportReason._('spam');
const ReportReason _$impersonation = const ReportReason._('impersonation');
const ReportReason _$cheatingOrScam = const ReportReason._('cheatingOrScam');
const ReportReason _$other = const ReportReason._('other');

ReportReason _$valueOf(String name) {
  switch (name) {
    case 'harassment':
      return _$harassment;
    case 'hate':
      return _$hate;
    case 'sexualContent':
      return _$sexualContent;
    case 'underage':
      return _$underage;
    case 'spam':
      return _$spam;
    case 'impersonation':
      return _$impersonation;
    case 'cheatingOrScam':
      return _$cheatingOrScam;
    case 'other':
      return _$other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReportReason> _$values =
    BuiltSet<ReportReason>(const <ReportReason>[
  _$harassment,
  _$hate,
  _$sexualContent,
  _$underage,
  _$spam,
  _$impersonation,
  _$cheatingOrScam,
  _$other,
]);

class _$ReportReasonMeta {
  const _$ReportReasonMeta();
  ReportReason get harassment => _$harassment;
  ReportReason get hate => _$hate;
  ReportReason get sexualContent => _$sexualContent;
  ReportReason get underage => _$underage;
  ReportReason get spam => _$spam;
  ReportReason get impersonation => _$impersonation;
  ReportReason get cheatingOrScam => _$cheatingOrScam;
  ReportReason get other => _$other;
  ReportReason valueOf(String name) => _$valueOf(name);
  BuiltSet<ReportReason> get values => _$values;
}

abstract class _$ReportReasonMixin {
  // ignore: non_constant_identifier_names
  _$ReportReasonMeta get ReportReason => const _$ReportReasonMeta();
}

Serializer<ReportReason> _$reportReasonSerializer = _$ReportReasonSerializer();

class _$ReportReasonSerializer implements PrimitiveSerializer<ReportReason> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'harassment': 'harassment',
    'hate': 'hate',
    'sexualContent': 'sexual_content',
    'underage': 'underage',
    'spam': 'spam',
    'impersonation': 'impersonation',
    'cheatingOrScam': 'cheating_or_scam',
    'other': 'other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'harassment': 'harassment',
    'hate': 'hate',
    'sexual_content': 'sexualContent',
    'underage': 'underage',
    'spam': 'spam',
    'impersonation': 'impersonation',
    'cheating_or_scam': 'cheatingOrScam',
    'other': 'other',
  };

  @override
  final Iterable<Type> types = const <Type>[ReportReason];
  @override
  final String wireName = 'ReportReason';

  @override
  Object serialize(Serializers serializers, ReportReason object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReportReason deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReportReason.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
