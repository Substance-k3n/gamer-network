//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/recruit_application_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recruit_application_page_dto.g.dart';

/// RecruitApplicationPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class RecruitApplicationPageDto
    implements
        Built<RecruitApplicationPageDto, RecruitApplicationPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<RecruitApplicationDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  RecruitApplicationPageDto._();

  factory RecruitApplicationPageDto(
          [void updates(RecruitApplicationPageDtoBuilder b)]) =
      _$RecruitApplicationPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecruitApplicationPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecruitApplicationPageDto> get serializer =>
      _$RecruitApplicationPageDtoSerializer();
}

class _$RecruitApplicationPageDtoSerializer
    implements PrimitiveSerializer<RecruitApplicationPageDto> {
  @override
  final Iterable<Type> types = const [
    RecruitApplicationPageDto,
    _$RecruitApplicationPageDto
  ];

  @override
  final String wireName = r'RecruitApplicationPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecruitApplicationPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType:
          const FullType(BuiltList, [FullType(RecruitApplicationDto)]),
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
    RecruitApplicationPageDto object, {
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
    required RecruitApplicationPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(RecruitApplicationDto)]),
          ) as BuiltList<RecruitApplicationDto>;
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
  RecruitApplicationPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecruitApplicationPageDtoBuilder();
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
