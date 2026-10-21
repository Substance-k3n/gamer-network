// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_audience.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PostAudience _$everyone = const PostAudience._('everyone');
const PostAudience _$connections = const PostAudience._('connections');

PostAudience _$valueOf(String name) {
  switch (name) {
    case 'everyone':
      return _$everyone;
    case 'connections':
      return _$connections;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PostAudience> _$values =
    BuiltSet<PostAudience>(const <PostAudience>[
  _$everyone,
  _$connections,
]);

class _$PostAudienceMeta {
  const _$PostAudienceMeta();
  PostAudience get everyone => _$everyone;
  PostAudience get connections => _$connections;
  PostAudience valueOf(String name) => _$valueOf(name);
  BuiltSet<PostAudience> get values => _$values;
}

abstract class _$PostAudienceMixin {
  // ignore: non_constant_identifier_names
  _$PostAudienceMeta get PostAudience => const _$PostAudienceMeta();
}

Serializer<PostAudience> _$postAudienceSerializer = _$PostAudienceSerializer();

class _$PostAudienceSerializer implements PrimitiveSerializer<PostAudience> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'everyone': 'everyone',
    'connections': 'connections',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'everyone': 'everyone',
    'connections': 'connections',
  };

  @override
  final Iterable<Type> types = const <Type>[PostAudience];
  @override
  final String wireName = 'PostAudience';

  @override
  Object serialize(Serializers serializers, PostAudience object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PostAudience deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PostAudience.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
