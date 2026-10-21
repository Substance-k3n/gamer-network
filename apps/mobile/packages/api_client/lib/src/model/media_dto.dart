//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/media_kind.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'media_dto.g.dart';

/// MediaDto
///
/// Properties:
/// * [kind] - Only image for now; video comes later.
/// * [id]
/// * [url] - Signed when the bucket is private: use as given (ADR-0009).
/// * [posterUrl] - A video's still frame; null for images.
/// * [width] - Null when not known: size the image from the file.
/// * [height]
/// * [durationMs] - Videos only.
@BuiltValue()
abstract class MediaDto implements Built<MediaDto, MediaDtoBuilder> {
  /// Only image for now; video comes later.
  @BuiltValueField(wireName: r'kind')
  MediaKind get kind;
  // enum kindEnum {  image,  video,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  /// Signed when the bucket is private: use as given (ADR-0009).
  @BuiltValueField(wireName: r'url')
  String get url;

  /// A video's still frame; null for images.
  @BuiltValueField(wireName: r'posterUrl')
  String? get posterUrl;

  /// Null when not known: size the image from the file.
  @BuiltValueField(wireName: r'width')
  num? get width;

  @BuiltValueField(wireName: r'height')
  num? get height;

  /// Videos only.
  @BuiltValueField(wireName: r'durationMs')
  num? get durationMs;

  MediaDto._();

  factory MediaDto([void updates(MediaDtoBuilder b)]) = _$MediaDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MediaDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MediaDto> get serializer => _$MediaDtoSerializer();
}

class _$MediaDtoSerializer implements PrimitiveSerializer<MediaDto> {
  @override
  final Iterable<Type> types = const [MediaDto, _$MediaDto];

  @override
  final String wireName = r'MediaDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MediaDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(MediaKind),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'posterUrl';
    yield object.posterUrl == null
        ? null
        : serializers.serialize(
            object.posterUrl,
            specifiedType: const FullType.nullable(String),
          );
    yield r'width';
    yield object.width == null
        ? null
        : serializers.serialize(
            object.width,
            specifiedType: const FullType.nullable(num),
          );
    yield r'height';
    yield object.height == null
        ? null
        : serializers.serialize(
            object.height,
            specifiedType: const FullType.nullable(num),
          );
    yield r'durationMs';
    yield object.durationMs == null
        ? null
        : serializers.serialize(
            object.durationMs,
            specifiedType: const FullType.nullable(num),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MediaDto object, {
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
    required MediaDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MediaKind),
          ) as MediaKind;
          result.kind = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'posterUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.posterUrl = valueDes;
          break;
        case r'width':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.width = valueDes;
          break;
        case r'height':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.height = valueDes;
          break;
        case r'durationMs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.durationMs = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MediaDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MediaDtoBuilder();
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
