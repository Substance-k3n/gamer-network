//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/application_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recruit_decision_dto.g.dart';

/// RecruitDecisionDto
///
/// Properties:
/// * [status]
/// * [id]
@BuiltValue()
abstract class RecruitDecisionDto
    implements Built<RecruitDecisionDto, RecruitDecisionDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  ApplicationStatus get status;
  // enum statusEnum {  pending,  accepted,  declined,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  RecruitDecisionDto._();

  factory RecruitDecisionDto([void updates(RecruitDecisionDtoBuilder b)]) =
      _$RecruitDecisionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecruitDecisionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecruitDecisionDto> get serializer =>
      _$RecruitDecisionDtoSerializer();
}

class _$RecruitDecisionDtoSerializer
    implements PrimitiveSerializer<RecruitDecisionDto> {
  @override
  final Iterable<Type> types = const [RecruitDecisionDto, _$RecruitDecisionDto];

  @override
  final String wireName = r'RecruitDecisionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecruitDecisionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ApplicationStatus),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecruitDecisionDto object, {
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
    required RecruitDecisionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApplicationStatus),
          ) as ApplicationStatus;
          result.status = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecruitDecisionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecruitDecisionDtoBuilder();
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
