// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AvatarType _$imageSlashJpeg = const AvatarType._('imageSlashJpeg');
const AvatarType _$imageSlashPng = const AvatarType._('imageSlashPng');
const AvatarType _$imageSlashWebp = const AvatarType._('imageSlashWebp');

AvatarType _$valueOf(String name) {
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

final BuiltSet<AvatarType> _$values = BuiltSet<AvatarType>(const <AvatarType>[
  _$imageSlashJpeg,
  _$imageSlashPng,
  _$imageSlashWebp,
]);

class _$AvatarTypeMeta {
  const _$AvatarTypeMeta();
  AvatarType get imageSlashJpeg => _$imageSlashJpeg;
  AvatarType get imageSlashPng => _$imageSlashPng;
  AvatarType get imageSlashWebp => _$imageSlashWebp;
  AvatarType valueOf(String name) => _$valueOf(name);
  BuiltSet<AvatarType> get values => _$values;
}

abstract class _$AvatarTypeMixin {
  // ignore: non_constant_identifier_names
  _$AvatarTypeMeta get AvatarType => const _$AvatarTypeMeta();
}

Serializer<AvatarType> _$avatarTypeSerializer = _$AvatarTypeSerializer();

class _$AvatarTypeSerializer implements PrimitiveSerializer<AvatarType> {
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
  final Iterable<Type> types = const <Type>[AvatarType];
  @override
  final String wireName = 'AvatarType';

  @override
  Object serialize(Serializers serializers, AvatarType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AvatarType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AvatarType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
