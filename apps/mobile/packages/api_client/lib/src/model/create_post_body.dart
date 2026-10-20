//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/post_type.dart';
import 'package:api_client/src/model/post_audience.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_post_body.g.dart';

/// CreatePostBody
///
/// Properties:
/// * [type]
/// * [audience]
/// * [text] - 1–2000 characters, trimmed.
/// * [gameId] - One of GET /v1/games. Null or left out: \"Any game\".
@BuiltValue()
abstract class CreatePostBody
    implements Built<CreatePostBody, CreatePostBodyBuilder> {
  @BuiltValueField(wireName: r'type')
  PostType get type;
  // enum typeEnum {  discussion,  gameplay,  recruitment,  poll,  milestone,  question,  looking_for_players,  tip_guide,  review,  event,  meme,  };

  @BuiltValueField(wireName: r'audience')
  PostAudience? get audience;
  // enum audienceEnum {  everyone,  connections,  };

  /// 1–2000 characters, trimmed.
  @BuiltValueField(wireName: r'text')
  String get text;

  /// One of GET /v1/games. Null or left out: \"Any game\".
  @BuiltValueField(wireName: r'gameId')
  String? get gameId;

  CreatePostBody._();

  factory CreatePostBody([void updates(CreatePostBodyBuilder b)]) =
      _$CreatePostBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatePostBodyBuilder b) =>
      b..audience = PostAudience.everyone;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatePostBody> get serializer =>
      _$CreatePostBodySerializer();
}

class _$CreatePostBodySerializer
    implements PrimitiveSerializer<CreatePostBody> {
  @override
  final Iterable<Type> types = const [CreatePostBody, _$CreatePostBody];

  @override
  final String wireName = r'CreatePostBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatePostBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PostType),
    );
    if (object.audience != null) {
      yield r'audience';
      yield serializers.serialize(
        object.audience,
        specifiedType: const FullType(PostAudience),
      );
    }
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    if (object.gameId != null) {
      yield r'gameId';
      yield serializers.serialize(
        object.gameId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatePostBody object, {
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
    required CreatePostBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PostType),
          ) as PostType;
          result.type = valueDes;
          break;
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PostAudience),
          ) as PostAudience?;
          if (valueDes == null) continue;
          result.audience = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'gameId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gameId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreatePostBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatePostBodyBuilder();
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
