//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/post_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'post_page_dto.g.dart';

/// PostPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class PostPageDto implements Built<PostPageDto, PostPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<PostDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  PostPageDto._();

  factory PostPageDto([void updates(PostPageDtoBuilder b)]) = _$PostPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PostPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PostPageDto> get serializer => _$PostPageDtoSerializer();
}

class _$PostPageDtoSerializer implements PrimitiveSerializer<PostPageDto> {
  @override
  final Iterable<Type> types = const [PostPageDto, _$PostPageDto];

  @override
  final String wireName = r'PostPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PostPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PostDto)]),
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
    PostPageDto object, {
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
    required PostPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PostDto)]),
          ) as BuiltList<PostDto>;
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
  PostPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PostPageDtoBuilder();
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
