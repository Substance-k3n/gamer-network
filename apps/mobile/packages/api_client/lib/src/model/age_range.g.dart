// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'age_range.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AgeRange _$n1617 = const AgeRange._('n1617');
const AgeRange _$n1824 = const AgeRange._('n1824');
const AgeRange _$n2534 = const AgeRange._('n2534');
const AgeRange _$n35plus = const AgeRange._('n35plus');

AgeRange _$valueOf(String name) {
  switch (name) {
    case 'n1617':
      return _$n1617;
    case 'n1824':
      return _$n1824;
    case 'n2534':
      return _$n2534;
    case 'n35plus':
      return _$n35plus;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AgeRange> _$values = BuiltSet<AgeRange>(const <AgeRange>[
  _$n1617,
  _$n1824,
  _$n2534,
  _$n35plus,
]);

class _$AgeRangeMeta {
  const _$AgeRangeMeta();
  AgeRange get n1617 => _$n1617;
  AgeRange get n1824 => _$n1824;
  AgeRange get n2534 => _$n2534;
  AgeRange get n35plus => _$n35plus;
  AgeRange valueOf(String name) => _$valueOf(name);
  BuiltSet<AgeRange> get values => _$values;
}

abstract class _$AgeRangeMixin {
  // ignore: non_constant_identifier_names
  _$AgeRangeMeta get AgeRange => const _$AgeRangeMeta();
}

Serializer<AgeRange> _$ageRangeSerializer = _$AgeRangeSerializer();

class _$AgeRangeSerializer implements PrimitiveSerializer<AgeRange> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'n1617': '16_17',
    'n1824': '18_24',
    'n2534': '25_34',
    'n35plus': '35_plus',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    '16_17': 'n1617',
    '18_24': 'n1824',
    '25_34': 'n2534',
    '35_plus': 'n35plus',
  };

  @override
  final Iterable<Type> types = const <Type>[AgeRange];
  @override
  final String wireName = 'AgeRange';

  @override
  Object serialize(Serializers serializers, AgeRange object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AgeRange deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AgeRange.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
