//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unread_count_dto.g.dart';

/// UnreadCountDto
///
/// Properties:
/// * [count]
@BuiltValue()
abstract class UnreadCountDto
    implements Built<UnreadCountDto, UnreadCountDtoBuilder> {
  @BuiltValueField(wireName: r'count')
  num get count;

  UnreadCountDto._();

  factory UnreadCountDto([void updates(UnreadCountDtoBuilder b)]) =
      _$UnreadCountDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnreadCountDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnreadCountDto> get serializer =>
      _$UnreadCountDtoSerializer();
}

class _$UnreadCountDtoSerializer
    implements PrimitiveSerializer<UnreadCountDto> {
  @override
  final Iterable<Type> types = const [UnreadCountDto, _$UnreadCountDto];

  @override
  final String wireName = r'UnreadCountDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnreadCountDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UnreadCountDto object, {
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
    required UnreadCountDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UnreadCountDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnreadCountDtoBuilder();
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
