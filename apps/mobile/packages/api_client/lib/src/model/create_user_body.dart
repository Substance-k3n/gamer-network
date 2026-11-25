//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_role.dart';
import 'package:api_client/src/model/age_range.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_user_body.g.dart';

/// CreateUserBody
///
/// Properties:
/// * [ageRange]
/// * [role]
/// * [email]
/// * [username]
/// * [displayName]
/// * [password] - They can change it after signing in.
@BuiltValue()
abstract class CreateUserBody
    implements Built<CreateUserBody, CreateUserBodyBuilder> {
  @BuiltValueField(wireName: r'ageRange')
  AgeRange get ageRange;
  // enum ageRangeEnum {  16_17,  18_24,  25_34,  35_plus,  };

  @BuiltValueField(wireName: r'role')
  UserRole? get role;
  // enum roleEnum {  player,  admin,  };

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  /// They can change it after signing in.
  @BuiltValueField(wireName: r'password')
  String get password;

  CreateUserBody._();

  factory CreateUserBody([void updates(CreateUserBodyBuilder b)]) =
      _$CreateUserBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateUserBodyBuilder b) => b..role = UserRole.player;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateUserBody> get serializer =>
      _$CreateUserBodySerializer();
}

class _$CreateUserBodySerializer
    implements PrimitiveSerializer<CreateUserBody> {
  @override
  final Iterable<Type> types = const [CreateUserBody, _$CreateUserBody];

  @override
  final String wireName = r'CreateUserBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateUserBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ageRange';
    yield serializers.serialize(
      object.ageRange,
      specifiedType: const FullType(AgeRange),
    );
    if (object.role != null) {
      yield r'role';
      yield serializers.serialize(
        object.role,
        specifiedType: const FullType(UserRole),
      );
    }
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateUserBody object, {
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
    required CreateUserBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ageRange':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AgeRange),
          ) as AgeRange;
          result.ageRange = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserRole),
          ) as UserRole?;
          if (valueDes == null) continue;
          result.role = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateUserBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateUserBodyBuilder();
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
