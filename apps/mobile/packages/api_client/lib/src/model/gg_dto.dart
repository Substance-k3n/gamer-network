//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gg_dto.g.dart';

/// GgDto
///
/// Properties:
/// * [ggCount]
/// * [myGG]
@BuiltValue()
abstract class GgDto implements Built<GgDto, GgDtoBuilder> {
  @BuiltValueField(wireName: r'ggCount')
  num get ggCount;

  @BuiltValueField(wireName: r'myGG')
  bool get myGG;

  GgDto._();

  factory GgDto([void updates(GgDtoBuilder b)]) = _$GgDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GgDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GgDto> get serializer => _$GgDtoSerializer();
}

class _$GgDtoSerializer implements PrimitiveSerializer<GgDto> {
  @override
  final Iterable<Type> types = const [GgDto, _$GgDto];

  @override
  final String wireName = r'GgDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GgDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    GgDto object, {
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
    required GgDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GgDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GgDtoBuilder();
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
