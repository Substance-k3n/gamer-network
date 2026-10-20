// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_content_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MediaContentType _$imageSlashJpeg =
    const MediaContentType._('imageSlashJpeg');
const MediaContentType _$imageSlashPng =
    const MediaContentType._('imageSlashPng');
const MediaContentType _$imageSlashWebp =
    const MediaContentType._('imageSlashWebp');

MediaContentType _$valueOf(String name) {
  switch (name) {
    case 'imageSlashJpeg':
      return _$imageSlashJpeg;
    case 'imageSlashPng':
      return _$imageSlashPng;
    case 'imageSlashWebp':
      return _$imageSlashWebp;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MediaContentType> _$values =
    BuiltSet<MediaContentType>(const <MediaContentType>[
  _$imageSlashJpeg,
  _$imageSlashPng,
  _$imageSlashWebp,
]);

class _$MediaContentTypeMeta {
  const _$MediaContentTypeMeta();
  MediaContentType get imageSlashJpeg => _$imageSlashJpeg;
  MediaContentType get imageSlashPng => _$imageSlashPng;
  MediaContentType get imageSlashWebp => _$imageSlashWebp;
  MediaContentType valueOf(String name) => _$valueOf(name);
  BuiltSet<MediaContentType> get values => _$values;
}

abstract class _$MediaContentTypeMixin {
  // ignore: non_constant_identifier_names
  _$MediaContentTypeMeta get MediaContentType => const _$MediaContentTypeMeta();
}

Serializer<MediaContentType> _$mediaContentTypeSerializer =
    _$MediaContentTypeSerializer();

class _$MediaContentTypeSerializer
    implements PrimitiveSerializer<MediaContentType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'imageSlashJpeg': 'image/jpeg',
    'imageSlashPng': 'image/png',
    'imageSlashWebp': 'image/webp',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'image/jpeg': 'imageSlashJpeg',
    'image/png': 'imageSlashPng',
    'image/webp': 'imageSlashWebp',
  };

  @override
  final Iterable<Type> types = const <Type>[MediaContentType];
  @override
  final String wireName = 'MediaContentType';

  @override
  Object serialize(Serializers serializers, MediaContentType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MediaContentType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MediaContentType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
