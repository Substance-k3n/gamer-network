//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'waitlist_count_dto.g.dart';

/// WaitlistCountDto
///
/// Properties:
/// * [topic] - \"groups\" for the Groups \"Notify me\" button.
/// * [count]
@BuiltValue()
abstract class WaitlistCountDto
    implements Built<WaitlistCountDto, WaitlistCountDtoBuilder> {
  /// \"groups\" for the Groups \"Notify me\" button.
  @BuiltValueField(wireName: r'topic')
  String get topic;

  @BuiltValueField(wireName: r'count')
  num get count;

  WaitlistCountDto._();

  factory WaitlistCountDto([void updates(WaitlistCountDtoBuilder b)]) =
      _$WaitlistCountDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WaitlistCountDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WaitlistCountDto> get serializer =>
      _$WaitlistCountDtoSerializer();
}

class _$WaitlistCountDtoSerializer
    implements PrimitiveSerializer<WaitlistCountDto> {
  @override
  final Iterable<Type> types = const [WaitlistCountDto, _$WaitlistCountDto];

  @override
  final String wireName = r'WaitlistCountDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WaitlistCountDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'topic';
    yield serializers.serialize(
      object.topic,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WaitlistCountDto object, {
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
    required WaitlistCountDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'topic':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.topic = valueDes;
          break;
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
  WaitlistCountDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WaitlistCountDtoBuilder();
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
