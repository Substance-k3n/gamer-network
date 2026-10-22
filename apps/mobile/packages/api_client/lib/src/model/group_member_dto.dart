//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:api_client/src/model/membership_status.dart';
import 'package:api_client/src/model/group_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_member_dto.g.dart';

/// GroupMemberDto
///
/// Properties:
/// * [role]
/// * [status]
/// * [user]
/// * [joinedAt] - Null while pending.
@BuiltValue()
abstract class GroupMemberDto
    implements Built<GroupMemberDto, GroupMemberDtoBuilder> {
  @BuiltValueField(wireName: r'role')
  GroupRole get role;
  // enum roleEnum {  admin,  member,  };

  @BuiltValueField(wireName: r'status')
  MembershipStatus get status;
  // enum statusEnum {  member,  pending,  };

  @BuiltValueField(wireName: r'user')
  UserCardDto get user;

  /// Null while pending.
  @BuiltValueField(wireName: r'joinedAt')
  DateTime? get joinedAt;

  GroupMemberDto._();

  factory GroupMemberDto([void updates(GroupMemberDtoBuilder b)]) =
      _$GroupMemberDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupMemberDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupMemberDto> get serializer =>
      _$GroupMemberDtoSerializer();
}

class _$GroupMemberDtoSerializer
    implements PrimitiveSerializer<GroupMemberDto> {
  @override
  final Iterable<Type> types = const [GroupMemberDto, _$GroupMemberDto];

  @override
  final String wireName = r'GroupMemberDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupMemberDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(GroupRole),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MembershipStatus),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserCardDto),
    );
    yield r'joinedAt';
    yield object.joinedAt == null
        ? null
        : serializers.serialize(
            object.joinedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupMemberDto object, {
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
    required GroupMemberDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GroupRole),
          ) as GroupRole;
          result.role = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MembershipStatus),
          ) as MembershipStatus;
          result.status = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserCardDto),
          ) as UserCardDto;
          result.user.replace(valueDes);
          break;
        case r'joinedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.joinedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GroupMemberDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupMemberDtoBuilder();
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
