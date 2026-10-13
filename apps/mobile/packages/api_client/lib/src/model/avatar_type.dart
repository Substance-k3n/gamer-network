//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'avatar_type.g.dart';

class AvatarType extends EnumClass {
  @BuiltValueEnumConst(wireName: r'image/jpeg')
  static const AvatarType imageSlashJpeg = _$imageSlashJpeg;
  @BuiltValueEnumConst(wireName: r'image/png')
  static const AvatarType imageSlashPng = _$imageSlashPng;
  @BuiltValueEnumConst(wireName: r'image/webp')
  static const AvatarType imageSlashWebp = _$imageSlashWebp;

  static Serializer<AvatarType> get serializer => _$avatarTypeSerializer;

  const AvatarType._(String name) : super(name);

  static BuiltSet<AvatarType> get values => _$values;
  static AvatarType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AvatarTypeMixin = Object with _$AvatarTypeMixin;
