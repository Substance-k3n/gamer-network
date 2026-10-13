// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_answer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckInAnswer _$played = const CheckInAnswer._('played');
const CheckInAnswer _$notYet = const CheckInAnswer._('notYet');
const CheckInAnswer _$no = const CheckInAnswer._('no');

CheckInAnswer _$valueOf(String name) {
  switch (name) {
    case 'played':
      return _$played;
    case 'notYet':
      return _$notYet;
    case 'no':
      return _$no;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckInAnswer> _$values =
    BuiltSet<CheckInAnswer>(const <CheckInAnswer>[
  _$played,
  _$notYet,
  _$no,
]);

class _$CheckInAnswerMeta {
  const _$CheckInAnswerMeta();
  CheckInAnswer get played => _$played;
  CheckInAnswer get notYet => _$notYet;
  CheckInAnswer get no => _$no;
  CheckInAnswer valueOf(String name) => _$valueOf(name);
  BuiltSet<CheckInAnswer> get values => _$values;
}

abstract class _$CheckInAnswerMixin {
  // ignore: non_constant_identifier_names
  _$CheckInAnswerMeta get CheckInAnswer => const _$CheckInAnswerMeta();
}

Serializer<CheckInAnswer> _$checkInAnswerSerializer =
    _$CheckInAnswerSerializer();

class _$CheckInAnswerSerializer implements PrimitiveSerializer<CheckInAnswer> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'played': 'played',
    'notYet': 'not_yet',
    'no': 'no',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'played': 'played',
    'not_yet': 'notYet',
    'no': 'no',
  };

  @override
  final Iterable<Type> types = const <Type>[CheckInAnswer];
  @override
  final String wireName = 'CheckInAnswer';

  @override
  Object serialize(Serializers serializers, CheckInAnswer object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckInAnswer deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckInAnswer.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
