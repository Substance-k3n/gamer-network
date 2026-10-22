// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_duration.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PollDuration _$n1d = const PollDuration._('n1d');
const PollDuration _$n3d = const PollDuration._('n3d');
const PollDuration _$n1w = const PollDuration._('n1w');

PollDuration _$valueOf(String name) {
  switch (name) {
    case 'n1d':
      return _$n1d;
    case 'n3d':
      return _$n3d;
    case 'n1w':
      return _$n1w;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PollDuration> _$values =
    BuiltSet<PollDuration>(const <PollDuration>[
  _$n1d,
  _$n3d,
  _$n1w,
]);

class _$PollDurationMeta {
  const _$PollDurationMeta();
  PollDuration get n1d => _$n1d;
  PollDuration get n3d => _$n3d;
  PollDuration get n1w => _$n1w;
  PollDuration valueOf(String name) => _$valueOf(name);
  BuiltSet<PollDuration> get values => _$values;
}

abstract class _$PollDurationMixin {
  // ignore: non_constant_identifier_names
  _$PollDurationMeta get PollDuration => const _$PollDurationMeta();
}

Serializer<PollDuration> _$pollDurationSerializer = _$PollDurationSerializer();

class _$PollDurationSerializer implements PrimitiveSerializer<PollDuration> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'n1d': '1d',
    'n3d': '3d',
    'n1w': '1w',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    '1d': 'n1d',
    '3d': 'n3d',
    '1w': 'n1w',
  };

  @override
  final Iterable<Type> types = const <Type>[PollDuration];
  @override
  final String wireName = 'PollDuration';

  @override
  Object serialize(Serializers serializers, PollDuration object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PollDuration deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PollDuration.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
