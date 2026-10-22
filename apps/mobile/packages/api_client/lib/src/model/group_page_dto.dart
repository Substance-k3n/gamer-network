//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/group_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_page_dto.g.dart';

/// GroupPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class GroupPageDto
    implements Built<GroupPageDto, GroupPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<GroupDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  GroupPageDto._();

  factory GroupPageDto([void updates(GroupPageDtoBuilder b)]) = _$GroupPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupPageDto> get serializer => _$GroupPageDtoSerializer();
}

class _$GroupPageDtoSerializer implements PrimitiveSerializer<GroupPageDto> {
  @override
  final Iterable<Type> types = const [GroupPageDto, _$GroupPageDto];

  @override
  final String wireName = r'GroupPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(GroupDto)]),
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
    GroupPageDto object, {
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
    required GroupPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GroupDto)]),
          ) as BuiltList<GroupDto>;
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
  GroupPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupPageDtoBuilder();
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
