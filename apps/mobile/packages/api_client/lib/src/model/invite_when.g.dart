// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_when.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InviteWhen _$now = const InviteWhen._('now');
const InviteWhen _$in30Min = const InviteWhen._('in30Min');
const InviteWhen _$tonight = const InviteWhen._('tonight');

InviteWhen _$valueOf(String name) {
  switch (name) {
    case 'now':
      return _$now;
    case 'in30Min':
      return _$in30Min;
    case 'tonight':
      return _$tonight;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InviteWhen> _$values = BuiltSet<InviteWhen>(const <InviteWhen>[
  _$now,
  _$in30Min,
  _$tonight,
]);

class _$InviteWhenMeta {
  const _$InviteWhenMeta();
  InviteWhen get now => _$now;
  InviteWhen get in30Min => _$in30Min;
  InviteWhen get tonight => _$tonight;
  InviteWhen valueOf(String name) => _$valueOf(name);
  BuiltSet<InviteWhen> get values => _$values;
}

abstract class _$InviteWhenMixin {
  // ignore: non_constant_identifier_names
  _$InviteWhenMeta get InviteWhen => const _$InviteWhenMeta();
}

Serializer<InviteWhen> _$inviteWhenSerializer = _$InviteWhenSerializer();

class _$InviteWhenSerializer implements PrimitiveSerializer<InviteWhen> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'now': 'now',
    'in30Min': 'in_30_min',
    'tonight': 'tonight',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'now': 'now',
    'in_30_min': 'in30Min',
    'tonight': 'tonight',
  };

  @override
  final Iterable<Type> types = const <Type>[InviteWhen];
  @override
  final String wireName = 'InviteWhen';

  @override
  Object serialize(Serializers serializers, InviteWhen object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InviteWhen deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InviteWhen.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
