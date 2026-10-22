//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comment_dto.g.dart';

/// CommentDto
///
/// Properties:
/// * [id]
/// * [postId]
/// * [parentId] - The top-level comment this replies to, or null.
/// * [author]
/// * [text]
/// * [ggCount]
/// * [myGG]
/// * [mine]
/// * [replies] - Replies under it; 0 on replies.
/// * [createdAt]
@BuiltValue()
abstract class CommentDto implements Built<CommentDto, CommentDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'postId')
  String get postId;

  /// The top-level comment this replies to, or null.
  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  @BuiltValueField(wireName: r'author')
  UserCardDto get author;

  @BuiltValueField(wireName: r'text')
  String get text;

  @BuiltValueField(wireName: r'ggCount')
  num get ggCount;

  @BuiltValueField(wireName: r'myGG')
  bool get myGG;

  @BuiltValueField(wireName: r'mine')
  bool get mine;

  /// Replies under it; 0 on replies.
  @BuiltValueField(wireName: r'replies')
  num get replies;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  CommentDto._();

  factory CommentDto([void updates(CommentDtoBuilder b)]) = _$CommentDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommentDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommentDto> get serializer => _$CommentDtoSerializer();
}

class _$CommentDtoSerializer implements PrimitiveSerializer<CommentDto> {
  @override
  final Iterable<Type> types = const [CommentDto, _$CommentDto];

  @override
  final String wireName = r'CommentDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'postId';
    yield serializers.serialize(
      object.postId,
      specifiedType: const FullType(String),
    );
    yield r'parentId';
    yield object.parentId == null
        ? null
        : serializers.serialize(
            object.parentId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'author';
    yield serializers.serialize(
      object.author,
      specifiedType: const FullType(UserCardDto),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'ggCount';
    yield serializers.serialize(
      object.ggCount,
      specifiedType: const FullType(num),
    );
    yield r'myGG';
    yield serializers.serialize(
      object.myGG,
      specifiedType: const FullType(bool),
    );
    yield r'mine';
    yield serializers.serialize(
      object.mine,
      specifiedType: const FullType(bool),
    );
    yield r'replies';
    yield serializers.serialize(
      object.replies,
      specifiedType: const FullType(num),
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
    CommentDto object, {
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
    required CommentDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'postId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.postId = valueDes;
          break;
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        case r'author':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserCardDto),
          ) as UserCardDto;
          result.author.replace(valueDes);
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'ggCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.ggCount = valueDes;
          break;
        case r'myGG':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.myGG = valueDes;
          break;
        case r'mine':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mine = valueDes;
          break;
        case r'replies':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.replies = valueDes;
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
  CommentDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommentDtoBuilder();
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
