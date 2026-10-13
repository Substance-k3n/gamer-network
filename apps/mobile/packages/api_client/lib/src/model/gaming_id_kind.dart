//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gaming_id_kind.g.dart';

class GamingIdKind extends EnumClass {
  @BuiltValueEnumConst(wireName: r'riot')
  static const GamingIdKind riot = _$riot;
  @BuiltValueEnumConst(wireName: r'steam')
  static const GamingIdKind steam = _$steam;
  @BuiltValueEnumConst(wireName: r'discord')
  static const GamingIdKind discord = _$discord;
  @BuiltValueEnumConst(wireName: r'playstation')
  static const GamingIdKind playstation = _$playstation;
  @BuiltValueEnumConst(wireName: r'xbox')
  static const GamingIdKind xbox = _$xbox;
  @BuiltValueEnumConst(wireName: r'epic')
  static const GamingIdKind epic = _$epic;
  @BuiltValueEnumConst(wireName: r'ea')
  static const GamingIdKind ea = _$ea;
  @BuiltValueEnumConst(wireName: r'activision')
  static const GamingIdKind activision = _$activision;
  @BuiltValueEnumConst(wireName: r'in_game')
  static const GamingIdKind inGame = _$inGame;

  static Serializer<GamingIdKind> get serializer => _$gamingIdKindSerializer;

  const GamingIdKind._(String name) : super(name);

  static BuiltSet<GamingIdKind> get values => _$values;
  static GamingIdKind valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class GamingIdKindMixin = Object with _$GamingIdKindMixin;
