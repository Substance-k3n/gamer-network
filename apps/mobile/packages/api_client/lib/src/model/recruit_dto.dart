//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/application_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recruit_dto.g.dart';

/// RecruitDto
///
/// Properties:
/// * [myApplication] - Your application, or null.
/// * [slots] - 1–10 players wanted.
/// * [roles] - \"Sniper, Support\"; empty when not given.
/// * [applications] - How many applied, leaving out people hidden from you (blocked either way); the author sees the list.
@BuiltValue()
abstract class RecruitDto implements Built<RecruitDto, RecruitDtoBuilder> {
  /// Your application, or null.
  @BuiltValueField(wireName: r'myApplication')
  ApplicationStatus? get myApplication;
  // enum myApplicationEnum {  pending,  accepted,  declined,  };

  /// 1–10 players wanted.
  @BuiltValueField(wireName: r'slots')
  num get slots;

  /// \"Sniper, Support\"; empty when not given.
  @BuiltValueField(wireName: r'roles')
  String get roles;

  /// How many applied, leaving out people hidden from you (blocked either way); the author sees the list.
  @BuiltValueField(wireName: r'applications')
  num get applications;

  RecruitDto._();

  factory RecruitDto([void updates(RecruitDtoBuilder b)]) = _$RecruitDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecruitDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecruitDto> get serializer => _$RecruitDtoSerializer();
}

class _$RecruitDtoSerializer implements PrimitiveSerializer<RecruitDto> {
  @override
  final Iterable<Type> types = const [RecruitDto, _$RecruitDto];

  @override
  final String wireName = r'RecruitDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecruitDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'myApplication';
    yield object.myApplication == null
        ? null
        : serializers.serialize(
            object.myApplication,
            specifiedType: const FullType.nullable(ApplicationStatus),
          );
    yield r'slots';
    yield serializers.serialize(
      object.slots,
      specifiedType: const FullType(num),
    );
    yield r'roles';
    yield serializers.serialize(
      object.roles,
      specifiedType: const FullType(String),
    );
    yield r'applications';
    yield serializers.serialize(
      object.applications,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RecruitDto object, {
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
    required RecruitDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'myApplication':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ApplicationStatus),
          ) as ApplicationStatus?;
          if (valueDes == null) continue;
          result.myApplication = valueDes;
          break;
        case r'slots':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.slots = valueDes;
          break;
        case r'roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.roles = valueDes;
          break;
        case r'applications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.applications = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecruitDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecruitDtoBuilder();
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
