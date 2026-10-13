// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Voice _$required_ = const Voice._('required_');
const Voice _$optional = const Voice._('optional');

Voice _$valueOf(String name) {
  switch (name) {
    case 'required_':
      return _$required_;
    case 'optional':
      return _$optional;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<Voice> _$values = BuiltSet<Voice>(const <Voice>[
  _$required_,
  _$optional,
]);

class _$VoiceMeta {
  const _$VoiceMeta();
  Voice get required_ => _$required_;
  Voice get optional => _$optional;
  Voice valueOf(String name) => _$valueOf(name);
  BuiltSet<Voice> get values => _$values;
}

abstract class _$VoiceMixin {
  // ignore: non_constant_identifier_names
  _$VoiceMeta get Voice => const _$VoiceMeta();
}

Serializer<Voice> _$voiceSerializer = _$VoiceSerializer();

class _$VoiceSerializer implements PrimitiveSerializer<Voice> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'required_': 'required',
    'optional': 'optional',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'required': 'required_',
    'optional': 'optional',
  };

  @override
  final Iterable<Type> types = const <Type>[Voice];
  @override
  final String wireName = 'Voice';

  @override
  Object serialize(Serializers serializers, Voice object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  Voice deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      Voice.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
