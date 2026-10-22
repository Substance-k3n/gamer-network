//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/media_content_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'media_upload_body.g.dart';

/// MediaUploadBody
///
/// Properties:
/// * [contentType]
/// * [size] - The file's exact size in bytes, at most 10 MB. Resize on the phone first (longest side 1600 px).
@BuiltValue()
abstract class MediaUploadBody
    implements Built<MediaUploadBody, MediaUploadBodyBuilder> {
  @BuiltValueField(wireName: r'contentType')
  MediaContentType get contentType;
  // enum contentTypeEnum {  image/jpeg,  image/png,  image/webp,  };

  /// The file's exact size in bytes, at most 10 MB. Resize on the phone first (longest side 1600 px).
  @BuiltValueField(wireName: r'size')
  num get size;

  MediaUploadBody._();

  factory MediaUploadBody([void updates(MediaUploadBodyBuilder b)]) =
      _$MediaUploadBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MediaUploadBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MediaUploadBody> get serializer =>
      _$MediaUploadBodySerializer();
}

class _$MediaUploadBodySerializer
    implements PrimitiveSerializer<MediaUploadBody> {
  @override
  final Iterable<Type> types = const [MediaUploadBody, _$MediaUploadBody];

  @override
  final String wireName = r'MediaUploadBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MediaUploadBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contentType';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(MediaContentType),
    );
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MediaUploadBody object, {
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
    required MediaUploadBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contentType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MediaContentType),
          ) as MediaContentType;
          result.contentType = valueDes;
          break;
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.size = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MediaUploadBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MediaUploadBodyBuilder();
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
