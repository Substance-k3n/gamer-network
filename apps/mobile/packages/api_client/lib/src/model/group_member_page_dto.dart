//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/group_member_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_member_page_dto.g.dart';

/// GroupMemberPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class GroupMemberPageDto
    implements Built<GroupMemberPageDto, GroupMemberPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<GroupMemberDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  GroupMemberPageDto._();

  factory GroupMemberPageDto([void updates(GroupMemberPageDtoBuilder b)]) =
      _$GroupMemberPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupMemberPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupMemberPageDto> get serializer =>
      _$GroupMemberPageDtoSerializer();
}

class _$GroupMemberPageDtoSerializer
    implements PrimitiveSerializer<GroupMemberPageDto> {
  @override
  final Iterable<Type> types = const [GroupMemberPageDto, _$GroupMemberPageDto];

  @override
  final String wireName = r'GroupMemberPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupMemberPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(GroupMemberDto)]),
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
    GroupMemberPageDto object, {
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
    required GroupMemberPageDtoBuilder result,
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
                const FullType(BuiltList, [FullType(GroupMemberDto)]),
          ) as BuiltList<GroupMemberDto>;
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
  GroupMemberPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupMemberPageDtoBuilder();
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
