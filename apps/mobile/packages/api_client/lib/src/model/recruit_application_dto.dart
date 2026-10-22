//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/application_status.dart';
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recruit_application_dto.g.dart';

/// RecruitApplicationDto
///
/// Properties:
/// * [status]
/// * [id]
/// * [user]
/// * [createdAt]
@BuiltValue()
abstract class RecruitApplicationDto
    implements Built<RecruitApplicationDto, RecruitApplicationDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  ApplicationStatus get status;
  // enum statusEnum {  pending,  accepted,  declined,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'user')
  UserCardDto get user;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  RecruitApplicationDto._();

  factory RecruitApplicationDto(
      [void updates(RecruitApplicationDtoBuilder b)]) = _$RecruitApplicationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecruitApplicationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecruitApplicationDto> get serializer =>
      _$RecruitApplicationDtoSerializer();
}

class _$RecruitApplicationDtoSerializer
    implements PrimitiveSerializer<RecruitApplicationDto> {
  @override
  final Iterable<Type> types = const [
    RecruitApplicationDto,
    _$RecruitApplicationDto
  ];

  @override
  final String wireName = r'RecruitApplicationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecruitApplicationDto object, {
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
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserCardDto),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecruitApplicationDto object, {
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
    required RecruitApplicationDtoBuilder result,
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
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserCardDto),
          ) as UserCardDto;
          result.user.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecruitApplicationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecruitApplicationDtoBuilder();
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
