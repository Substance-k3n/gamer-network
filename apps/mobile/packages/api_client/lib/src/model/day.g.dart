// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Day _$mon = const Day._('mon');
const Day _$tue = const Day._('tue');
const Day _$wed = const Day._('wed');
const Day _$thu = const Day._('thu');
const Day _$fri = const Day._('fri');
const Day _$sat = const Day._('sat');
const Day _$sun = const Day._('sun');

Day _$valueOf(String name) {
  switch (name) {
    case 'mon':
      return _$mon;
    case 'tue':
      return _$tue;
    case 'wed':
      return _$wed;
    case 'thu':
      return _$thu;
    case 'fri':
      return _$fri;
    case 'sat':
      return _$sat;
    case 'sun':
      return _$sun;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<Day> _$values = BuiltSet<Day>(const <Day>[
  _$mon,
  _$tue,
  _$wed,
  _$thu,
  _$fri,
  _$sat,
  _$sun,
]);

class _$DayMeta {
  const _$DayMeta();
  Day get mon => _$mon;
  Day get tue => _$tue;
  Day get wed => _$wed;
  Day get thu => _$thu;
  Day get fri => _$fri;
  Day get sat => _$sat;
  Day get sun => _$sun;
  Day valueOf(String name) => _$valueOf(name);
  BuiltSet<Day> get values => _$values;
}

abstract class _$DayMixin {
  // ignore: non_constant_identifier_names
  _$DayMeta get Day => const _$DayMeta();
}

Serializer<Day> _$daySerializer = _$DaySerializer();

class _$DaySerializer implements PrimitiveSerializer<Day> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'mon': 'mon',
    'tue': 'tue',
    'wed': 'wed',
    'thu': 'thu',
    'fri': 'fri',
    'sat': 'sat',
    'sun': 'sun',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'mon': 'mon',
    'tue': 'tue',
    'wed': 'wed',
    'thu': 'thu',
    'fri': 'fri',
    'sat': 'sat',
    'sun': 'sun',
  };

  @override
  final Iterable<Type> types = const <Type>[Day];
  @override
  final String wireName = 'Day';

  @override
  Object serialize(Serializers serializers, Day object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  Day deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      Day.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
