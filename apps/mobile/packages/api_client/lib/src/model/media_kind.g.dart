// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_kind.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MediaKind _$image = const MediaKind._('image');
const MediaKind _$video = const MediaKind._('video');

MediaKind _$valueOf(String name) {
  switch (name) {
    case 'image':
      return _$image;
    case 'video':
      return _$video;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MediaKind> _$values = BuiltSet<MediaKind>(const <MediaKind>[
  _$image,
  _$video,
]);

class _$MediaKindMeta {
  const _$MediaKindMeta();
  MediaKind get image => _$image;
  MediaKind get video => _$video;
  MediaKind valueOf(String name) => _$valueOf(name);
  BuiltSet<MediaKind> get values => _$values;
}

abstract class _$MediaKindMixin {
  // ignore: non_constant_identifier_names
  _$MediaKindMeta get MediaKind => const _$MediaKindMeta();
}

Serializer<MediaKind> _$mediaKindSerializer = _$MediaKindSerializer();

class _$MediaKindSerializer implements PrimitiveSerializer<MediaKind> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'image': 'image',
    'video': 'video',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'image': 'image',
    'video': 'video',
  };

  @override
  final Iterable<Type> types = const <Type>[MediaKind];
  @override
  final String wireName = 'MediaKind';

  @override
  Object serialize(Serializers serializers, MediaKind object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MediaKind deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MediaKind.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
