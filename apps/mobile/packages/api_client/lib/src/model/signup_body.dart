//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/age_range.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'signup_body.g.dart';

/// SignupBody
///
/// Properties:
/// * [ageRange]
/// * [email]
/// * [displayName]
/// * [username] - Stored lowercase.
/// * [password] - 8–72 characters.
@BuiltValue()
abstract class SignupBody implements Built<SignupBody, SignupBodyBuilder> {
  @BuiltValueField(wireName: r'ageRange')
  AgeRange get ageRange;
  // enum ageRangeEnum {  16_17,  18_24,  25_34,  35_plus,  };

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  /// Stored lowercase.
  @BuiltValueField(wireName: r'username')
  String get username;

  /// 8–72 characters.
  @BuiltValueField(wireName: r'password')
  String get password;

  SignupBody._();

  factory SignupBody([void updates(SignupBodyBuilder b)]) = _$SignupBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SignupBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SignupBody> get serializer => _$SignupBodySerializer();
}

class _$SignupBodySerializer implements PrimitiveSerializer<SignupBody> {
  @override
  final Iterable<Type> types = const [SignupBody, _$SignupBody];

  @override
  final String wireName = r'SignupBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SignupBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ageRange';
    yield serializers.serialize(
      object.ageRange,
      specifiedType: const FullType(AgeRange),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
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
    SignupBody object, {
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
    required SignupBodyBuilder result,
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
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
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
  SignupBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SignupBodyBuilder();
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
