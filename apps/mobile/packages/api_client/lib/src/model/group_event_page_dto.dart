//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/group_event_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_event_page_dto.g.dart';

/// GroupEventPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class GroupEventPageDto
    implements Built<GroupEventPageDto, GroupEventPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<GroupEventDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  GroupEventPageDto._();

  factory GroupEventPageDto([void updates(GroupEventPageDtoBuilder b)]) =
      _$GroupEventPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupEventPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupEventPageDto> get serializer =>
      _$GroupEventPageDtoSerializer();
}

class _$GroupEventPageDtoSerializer
    implements PrimitiveSerializer<GroupEventPageDto> {
  @override
  final Iterable<Type> types = const [GroupEventPageDto, _$GroupEventPageDto];

  @override
  final String wireName = r'GroupEventPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupEventPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(GroupEventDto)]),
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
    GroupEventPageDto object, {
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
    required GroupEventPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GroupEventDto)]),
          ) as BuiltList<GroupEventDto>;
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
  GroupEventPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupEventPageDtoBuilder();
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
