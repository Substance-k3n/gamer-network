//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/poll_body.dart';
import 'package:api_client/src/model/post_type.dart';
import 'package:api_client/src/model/recruit_body.dart';
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
/// * [groupId] - Post in this group instead of Home: members only (403 not_member). Group posts are for everyone in the group, so audience=connections is refused.
/// * [media] - Up to 4 keys from POST /v1/media/upload-url, uploaded by you and not used yet. Required on gameplay.
/// * [poll] - Required on poll posts, refused on others.
/// * [recruit] - Required on recruitment posts, refused on others.
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

  /// Post in this group instead of Home: members only (403 not_member). Group posts are for everyone in the group, so audience=connections is refused.
  @BuiltValueField(wireName: r'groupId')
  String? get groupId;

  /// Up to 4 keys from POST /v1/media/upload-url, uploaded by you and not used yet. Required on gameplay.
  @BuiltValueField(wireName: r'media')
  BuiltSet<String>? get media;

  /// Required on poll posts, refused on others.
  @BuiltValueField(wireName: r'poll')
  PollBody? get poll;

  /// Required on recruitment posts, refused on others.
  @BuiltValueField(wireName: r'recruit')
  RecruitBody? get recruit;

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
    if (object.groupId != null) {
      yield r'groupId';
      yield serializers.serialize(
        object.groupId,
        specifiedType: const FullType(String),
      );
    }
    if (object.media != null) {
      yield r'media';
      yield serializers.serialize(
        object.media,
        specifiedType: const FullType(BuiltSet, [FullType(String)]),
      );
    }
    if (object.poll != null) {
      yield r'poll';
      yield serializers.serialize(
        object.poll,
        specifiedType: const FullType(PollBody),
      );
    }
    if (object.recruit != null) {
      yield r'recruit';
      yield serializers.serialize(
        object.recruit,
        specifiedType: const FullType(RecruitBody),
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
        case r'groupId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.groupId = valueDes;
          break;
        case r'media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>?;
          if (valueDes == null) continue;
          result.media.replace(valueDes);
          break;
        case r'poll':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PollBody),
          ) as PollBody?;
          if (valueDes == null) continue;
          result.poll.replace(valueDes);
          break;
        case r'recruit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RecruitBody),
          ) as RecruitBody?;
          if (valueDes == null) continue;
          result.recruit.replace(valueDes);
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
