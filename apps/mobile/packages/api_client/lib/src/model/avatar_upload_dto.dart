//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'avatar_upload_dto.g.dart';

/// AvatarUploadDto
///
/// Properties:
/// * [uploadUrl] - PUT the file here before `expiresAt`, with `headers`. The body must be exactly the `size` you asked for (the URL is signed for it); let the HTTP client set Content-Length.
/// * [headers] - Send these with the upload (Content-Type).
/// * [key] - Send to PUT /v1/me/avatar once the upload succeeds.
/// * [expiresAt]
@BuiltValue()
abstract class AvatarUploadDto
    implements Built<AvatarUploadDto, AvatarUploadDtoBuilder> {
  /// PUT the file here before `expiresAt`, with `headers`. The body must be exactly the `size` you asked for (the URL is signed for it); let the HTTP client set Content-Length.
  @BuiltValueField(wireName: r'uploadUrl')
  String get uploadUrl;

  /// Send these with the upload (Content-Type).
  @BuiltValueField(wireName: r'headers')
  BuiltMap<String, String> get headers;

  /// Send to PUT /v1/me/avatar once the upload succeeds.
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  AvatarUploadDto._();

  factory AvatarUploadDto([void updates(AvatarUploadDtoBuilder b)]) =
      _$AvatarUploadDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AvatarUploadDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AvatarUploadDto> get serializer =>
      _$AvatarUploadDtoSerializer();
}

class _$AvatarUploadDtoSerializer
    implements PrimitiveSerializer<AvatarUploadDto> {
  @override
  final Iterable<Type> types = const [AvatarUploadDto, _$AvatarUploadDto];

  @override
  final String wireName = r'AvatarUploadDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AvatarUploadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'uploadUrl';
    yield serializers.serialize(
      object.uploadUrl,
      specifiedType: const FullType(String),
    );
    yield r'headers';
    yield serializers.serialize(
      object.headers,
      specifiedType:
          const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AvatarUploadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AvatarUploadDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'uploadUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadUrl = valueDes;
          break;
        case r'headers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.headers.replace(valueDes);
          break;
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AvatarUploadDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AvatarUploadDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
