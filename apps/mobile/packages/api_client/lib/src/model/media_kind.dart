//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'media_kind.g.dart';

/// Only image for now; video comes later.
class MediaKind extends EnumClass {
  @BuiltValueEnumConst(wireName: r'image')
  static const MediaKind image = _$image;
  @BuiltValueEnumConst(wireName: r'video')
  static const MediaKind video = _$video;

  static Serializer<MediaKind> get serializer => _$mediaKindSerializer;

  const MediaKind._(String name) : super(name);

  static BuiltSet<MediaKind> get values => _$values;
  static MediaKind valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class MediaKindMixin = Object with _$MediaKindMixin;
