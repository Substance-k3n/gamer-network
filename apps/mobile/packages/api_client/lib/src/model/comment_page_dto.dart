//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/comment_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'comment_page_dto.g.dart';

/// CommentPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class CommentPageDto
    implements Built<CommentPageDto, CommentPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<CommentDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  CommentPageDto._();

  factory CommentPageDto([void updates(CommentPageDtoBuilder b)]) =
      _$CommentPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommentPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommentPageDto> get serializer =>
      _$CommentPageDtoSerializer();
}

class _$CommentPageDtoSerializer
    implements PrimitiveSerializer<CommentPageDto> {
  @override
  final Iterable<Type> types = const [CommentPageDto, _$CommentPageDto];

  @override
  final String wireName = r'CommentPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommentPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CommentDto)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null
        ? null
        : serializers.serialize(
            object.nextCursor,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommentPageDto object, {
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
    required CommentPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CommentDto)]),
          ) as BuiltList<CommentDto>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommentPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommentPageDtoBuilder();
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
