//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:api_client/src/model/post_type.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:api_client/src/model/post_kind.dart';
import 'package:api_client/src/model/comment_dto.dart';
import 'package:api_client/src/model/post_audience.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'post_dto.g.dart';

/// PostDto
///
/// Properties:
/// * [type]
/// * [kind] - Draw by this: follows from type.
/// * [audience]
/// * [id]
/// * [author] - topGame gives \"Diamond Valorant\" for the header.
/// * [game] - Null: \"Any game\".
/// * [text]
/// * [topComment] - Discussions: the most-GG'd answer. Null on other kinds.
/// * [ggCount]
/// * [commentCount] - Comments and replies you can see the count of (\"answers\" on discussions).
/// * [myGG]
/// * [saved]
/// * [mine]
/// * [shareUrl] - Link for Telegram/WhatsApp.
/// * [createdAt]
@BuiltValue()
abstract class PostDto implements Built<PostDto, PostDtoBuilder> {
  @BuiltValueField(wireName: r'type')
  PostType get type;
  // enum typeEnum {  discussion,  gameplay,  recruitment,  poll,  milestone,  question,  looking_for_players,  tip_guide,  review,  event,  meme,  };

  /// Draw by this: follows from type.
  @BuiltValueField(wireName: r'kind')
  PostKind get kind;
  // enum kindEnum {  text,  moment,  discussion,  poll,  recruit,  };

  @BuiltValueField(wireName: r'audience')
  PostAudience get audience;
  // enum audienceEnum {  everyone,  connections,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  /// topGame gives \"Diamond Valorant\" for the header.
  @BuiltValueField(wireName: r'author')
  UserCardDto get author;

  /// Null: \"Any game\".
  @BuiltValueField(wireName: r'game')
  GameRefDto? get game;

  @BuiltValueField(wireName: r'text')
  String get text;

  /// Discussions: the most-GG'd answer. Null on other kinds.
  @BuiltValueField(wireName: r'topComment')
  CommentDto? get topComment;

  @BuiltValueField(wireName: r'ggCount')
  num get ggCount;

  /// Comments and replies you can see the count of (\"answers\" on discussions).
  @BuiltValueField(wireName: r'commentCount')
  num get commentCount;

  @BuiltValueField(wireName: r'myGG')
  bool get myGG;

  @BuiltValueField(wireName: r'saved')
  bool get saved;

  @BuiltValueField(wireName: r'mine')
  bool get mine;

  /// Link for Telegram/WhatsApp.
  @BuiltValueField(wireName: r'shareUrl')
  String get shareUrl;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PostDto._();

  factory PostDto([void updates(PostDtoBuilder b)]) = _$PostDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PostDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PostDto> get serializer => _$PostDtoSerializer();
}

class _$PostDtoSerializer implements PrimitiveSerializer<PostDto> {
  @override
  final Iterable<Type> types = const [PostDto, _$PostDto];

  @override
  final String wireName = r'PostDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PostDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PostType),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(PostKind),
    );
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(PostAudience),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'author';
    yield serializers.serialize(
      object.author,
      specifiedType: const FullType(UserCardDto),
    );
    yield r'game';
    yield object.game == null
        ? null
        : serializers.serialize(
            object.game,
            specifiedType: const FullType.nullable(GameRefDto),
          );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'topComment';
    yield object.topComment == null
        ? null
        : serializers.serialize(
            object.topComment,
            specifiedType: const FullType.nullable(CommentDto),
          );
    yield r'ggCount';
    yield serializers.serialize(
      object.ggCount,
      specifiedType: const FullType(num),
    );
    yield r'commentCount';
    yield serializers.serialize(
      object.commentCount,
      specifiedType: const FullType(num),
    );
    yield r'myGG';
    yield serializers.serialize(
      object.myGG,
      specifiedType: const FullType(bool),
    );
    yield r'saved';
    yield serializers.serialize(
      object.saved,
      specifiedType: const FullType(bool),
    );
    yield r'mine';
    yield serializers.serialize(
      object.mine,
      specifiedType: const FullType(bool),
    );
    yield r'shareUrl';
    yield serializers.serialize(
      object.shareUrl,
      specifiedType: const FullType(String),
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
    PostDto object, {
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
    required PostDtoBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PostKind),
          ) as PostKind;
          result.kind = valueDes;
          break;
        case r'audience':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PostAudience),
          ) as PostAudience;
          result.audience = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'author':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserCardDto),
          ) as UserCardDto;
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
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'topComment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CommentDto),
          ) as CommentDto?;
          if (valueDes == null) continue;
          result.topComment.replace(valueDes);
          break;
        case r'ggCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.ggCount = valueDes;
          break;
        case r'commentCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.commentCount = valueDes;
          break;
        case r'myGG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.myGG = valueDes;
          break;
        case r'saved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.saved = valueDes;
          break;
        case r'mine':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mine = valueDes;
          break;
        case r'shareUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.shareUrl = valueDes;
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
  PostDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PostDtoBuilder();
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
