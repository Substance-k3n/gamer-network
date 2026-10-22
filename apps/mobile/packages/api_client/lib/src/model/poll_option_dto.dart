//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'poll_option_dto.g.dart';

/// PollOptionDto
///
/// Properties:
/// * [position] - 0–3, in the order the author wrote them.
/// * [label]
/// * [votes]
@BuiltValue()
abstract class PollOptionDto
    implements Built<PollOptionDto, PollOptionDtoBuilder> {
  /// 0–3, in the order the author wrote them.
  @BuiltValueField(wireName: r'position')
  num get position;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'votes')
  num get votes;

  PollOptionDto._();

  factory PollOptionDto([void updates(PollOptionDtoBuilder b)]) =
      _$PollOptionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PollOptionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PollOptionDto> get serializer =>
      _$PollOptionDtoSerializer();
}

class _$PollOptionDtoSerializer implements PrimitiveSerializer<PollOptionDto> {
  @override
  final Iterable<Type> types = const [PollOptionDto, _$PollOptionDto];

  @override
  final String wireName = r'PollOptionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PollOptionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(num),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'votes';
    yield serializers.serialize(
      object.votes,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PollOptionDto object, {
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
    required PollOptionDtoBuilder result,
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
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'votes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.votes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PollOptionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PollOptionDtoBuilder();
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
