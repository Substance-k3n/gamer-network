//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_comment_body.g.dart';

/// CreateCommentBody
///
/// Properties:
/// * [text] - 1–500 characters, trimmed.
/// * [parentId] - The comment you're replying to. A reply to a reply goes under the same top-level comment.
@BuiltValue()
abstract class CreateCommentBody
    implements Built<CreateCommentBody, CreateCommentBodyBuilder> {
  /// 1–500 characters, trimmed.
  @BuiltValueField(wireName: r'text')
  String get text;

  /// The comment you're replying to. A reply to a reply goes under the same top-level comment.
  @BuiltValueField(wireName: r'parentId')
  String? get parentId;

  CreateCommentBody._();

  factory CreateCommentBody([void updates(CreateCommentBodyBuilder b)]) =
      _$CreateCommentBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateCommentBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateCommentBody> get serializer =>
      _$CreateCommentBodySerializer();
}

class _$CreateCommentBodySerializer
    implements PrimitiveSerializer<CreateCommentBody> {
  @override
  final Iterable<Type> types = const [CreateCommentBody, _$CreateCommentBody];

  @override
  final String wireName = r'CreateCommentBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateCommentBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    if (object.parentId != null) {
      yield r'parentId';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateCommentBody object, {
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
    required CreateCommentBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.parentId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateCommentBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateCommentBodyBuilder();
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
