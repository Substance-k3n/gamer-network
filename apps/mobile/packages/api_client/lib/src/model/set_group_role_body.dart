//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/group_role.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_group_role_body.g.dart';

/// SetGroupRoleBody
///
/// Properties:
/// * [role]
@BuiltValue()
abstract class SetGroupRoleBody
    implements Built<SetGroupRoleBody, SetGroupRoleBodyBuilder> {
  @BuiltValueField(wireName: r'role')
  GroupRole get role;
  // enum roleEnum {  admin,  member,  };

  SetGroupRoleBody._();

  factory SetGroupRoleBody([void updates(SetGroupRoleBodyBuilder b)]) =
      _$SetGroupRoleBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetGroupRoleBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetGroupRoleBody> get serializer =>
      _$SetGroupRoleBodySerializer();
}

class _$SetGroupRoleBodySerializer
    implements PrimitiveSerializer<SetGroupRoleBody> {
  @override
  final Iterable<Type> types = const [SetGroupRoleBody, _$SetGroupRoleBody];

  @override
  final String wireName = r'SetGroupRoleBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetGroupRoleBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(GroupRole),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetGroupRoleBody object, {
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
    required SetGroupRoleBodyBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetGroupRoleBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetGroupRoleBodyBuilder();
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
