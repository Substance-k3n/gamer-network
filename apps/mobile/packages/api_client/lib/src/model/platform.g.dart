// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Platform _$pc = const Platform._('pc');
const Platform _$playstation = const Platform._('playstation');
const Platform _$xbox = const Platform._('xbox');
const Platform _$mobile = const Platform._('mobile');
const Platform _$switch_ = const Platform._('switch_');

Platform _$valueOf(String name) {
  switch (name) {
    case 'pc':
      return _$pc;
    case 'playstation':
      return _$playstation;
    case 'xbox':
      return _$xbox;
    case 'mobile':
      return _$mobile;
    case 'switch_':
      return _$switch_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<Platform> _$values = BuiltSet<Platform>(const <Platform>[
  _$pc,
  _$playstation,
  _$xbox,
  _$mobile,
  _$switch_,
]);

class _$PlatformMeta {
  const _$PlatformMeta();
  Platform get pc => _$pc;
  Platform get playstation => _$playstation;
  Platform get xbox => _$xbox;
  Platform get mobile => _$mobile;
  Platform get switch_ => _$switch_;
  Platform valueOf(String name) => _$valueOf(name);
  BuiltSet<Platform> get values => _$values;
}

abstract class _$PlatformMixin {
  // ignore: non_constant_identifier_names
  _$PlatformMeta get Platform => const _$PlatformMeta();
}

Serializer<Platform> _$platformSerializer = _$PlatformSerializer();

class _$PlatformSerializer implements PrimitiveSerializer<Platform> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pc': 'pc',
    'playstation': 'playstation',
    'xbox': 'xbox',
    'mobile': 'mobile',
    'switch_': 'switch',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pc': 'pc',
    'playstation': 'playstation',
    'xbox': 'xbox',
    'mobile': 'mobile',
    'switch': 'switch_',
  };

  @override
  final Iterable<Type> types = const <Type>[Platform];
  @override
  final String wireName = 'Platform';

  @override
  Object serialize(Serializers serializers, Platform object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  Platform deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      Platform.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
