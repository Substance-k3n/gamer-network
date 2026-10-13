//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'player_status.g.dart';

/// Already reset to not_available once its time has passed.
class PlayerStatus extends EnumClass {
  @BuiltValueEnumConst(wireName: r'looking')
  static const PlayerStatus looking = _$looking;
  @BuiltValueEnumConst(wireName: r'playing')
  static const PlayerStatus playing = _$playing;
  @BuiltValueEnumConst(wireName: r'available_tonight')
  static const PlayerStatus availableTonight = _$availableTonight;
  @BuiltValueEnumConst(wireName: r'not_available')
  static const PlayerStatus notAvailable = _$notAvailable;

  static Serializer<PlayerStatus> get serializer => _$playerStatusSerializer;

  const PlayerStatus._(String name) : super(name);

  static BuiltSet<PlayerStatus> get values => _$values;
  static PlayerStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class PlayerStatusMixin = Object with _$PlayerStatusMixin;
