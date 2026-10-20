//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/public_post_author_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/post_type.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:api_client/src/model/media_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_post_dto.g.dart';

/// PublicPostDto
///
/// Properties:
/// * [type]
/// * [id]
/// * [text] - The first 300 characters.
/// * [author]
/// * [game]
/// * [media] - The first image only, for the preview; empty when it has none.
/// * [createdAt]
@BuiltValue()
abstract class PublicPostDto
    implements Built<PublicPostDto, PublicPostDtoBuilder> {
  @BuiltValueField(wireName: r'type')
  PostType get type;
  // enum typeEnum {  discussion,  gameplay,  recruitment,  poll,  milestone,  question,  looking_for_players,  tip_guide,  review,  event,  meme,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  /// The first 300 characters.
  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'author')
  PublicPostAuthorDto get author;

  @BuiltValueField(wireName: r'game')
  GameRefDto? get game;

  /// The first image only, for the preview; empty when it has none.
  @BuiltValueField(wireName: r'media')
  BuiltList<MediaDto> get media;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PublicPostDto._();

  factory PublicPostDto([void updates(PublicPostDtoBuilder b)]) =
      _$PublicPostDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicPostDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicPostDto> get serializer =>
      _$PublicPostDtoSerializer();
}

class _$PublicPostDtoSerializer implements PrimitiveSerializer<PublicPostDto> {
  @override
  final Iterable<Type> types = const [PublicPostDto, _$PublicPostDto];

  @override
  final String wireName = r'PublicPostDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicPostDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PostType),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'author';
    yield serializers.serialize(
      object.author,
      specifiedType: const FullType(PublicPostAuthorDto),
    );
    yield r'game';
    yield object.game == null
        ? null
        : serializers.serialize(
            object.game,
            specifiedType: const FullType.nullable(GameRefDto),
          );
    yield r'media';
    yield serializers.serialize(
      object.media,
      specifiedType: const FullType(BuiltList, [FullType(MediaDto)]),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicPostDto object, {
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
    required PublicPostDtoBuilder result,
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
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'author':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicPostAuthorDto),
          ) as PublicPostAuthorDto;
          result.author.replace(valueDes);
          break;
        case r'game':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GameRefDto),
          ) as GameRefDto?;
          if (valueDes == null) continue;
          result.game.replace(valueDes);
          break;
        case r'media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MediaDto)]),
          ) as BuiltList<MediaDto>;
          result.media.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicPostDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicPostDtoBuilder();
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
