//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform.g.dart';

class Platform extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pc')
  static const Platform pc = _$pc;
  @BuiltValueEnumConst(wireName: r'playstation')
  static const Platform playstation = _$playstation;
  @BuiltValueEnumConst(wireName: r'xbox')
  static const Platform xbox = _$xbox;
  @BuiltValueEnumConst(wireName: r'mobile')
  static const Platform mobile = _$mobile;
  @BuiltValueEnumConst(wireName: r'switch')
  static const Platform switch_ = _$switch_;

  static Serializer<Platform> get serializer => _$platformSerializer;

  const Platform._(String name) : super(name);

  static BuiltSet<Platform> get values => _$values;
  static Platform valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PlatformMixin = Object with _$PlatformMixin;
