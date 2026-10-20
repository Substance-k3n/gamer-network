//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vote_body.g.dart';

/// VoteBody
///
/// Properties:
/// * [position] - The option's position (0–3).
@BuiltValue()
abstract class VoteBody implements Built<VoteBody, VoteBodyBuilder> {
  /// The option's position (0–3).
  @BuiltValueField(wireName: r'position')
  num get position;

  VoteBody._();

  factory VoteBody([void updates(VoteBodyBuilder b)]) = _$VoteBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VoteBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VoteBody> get serializer => _$VoteBodySerializer();
}

class _$VoteBodySerializer implements PrimitiveSerializer<VoteBody> {
  @override
  final Iterable<Type> types = const [VoteBody, _$VoteBody];

  @override
  final String wireName = r'VoteBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VoteBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VoteBody object, {
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
    required VoteBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.position = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VoteBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VoteBodyBuilder();
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
