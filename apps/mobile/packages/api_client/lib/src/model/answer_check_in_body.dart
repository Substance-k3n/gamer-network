//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/check_in_answer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'answer_check_in_body.g.dart';

/// AnswerCheckInBody
///
/// Properties:
/// * [answer]
@BuiltValue()
abstract class AnswerCheckInBody
    implements Built<AnswerCheckInBody, AnswerCheckInBodyBuilder> {
  @BuiltValueField(wireName: r'answer')
  CheckInAnswer get answer;
  // enum answerEnum {  played,  not_yet,  no,  };

  AnswerCheckInBody._();

  factory AnswerCheckInBody([void updates(AnswerCheckInBodyBuilder b)]) =
      _$AnswerCheckInBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnswerCheckInBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnswerCheckInBody> get serializer =>
      _$AnswerCheckInBodySerializer();
}

class _$AnswerCheckInBodySerializer
    implements PrimitiveSerializer<AnswerCheckInBody> {
  @override
  final Iterable<Type> types = const [AnswerCheckInBody, _$AnswerCheckInBody];

  @override
  final String wireName = r'AnswerCheckInBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnswerCheckInBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'answer';
    yield serializers.serialize(
      object.answer,
      specifiedType: const FullType(CheckInAnswer),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnswerCheckInBody object, {
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
    required AnswerCheckInBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'answer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckInAnswer),
          ) as CheckInAnswer;
          result.answer = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnswerCheckInBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnswerCheckInBodyBuilder();
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
