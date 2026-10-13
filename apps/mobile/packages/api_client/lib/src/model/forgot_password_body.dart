//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'forgot_password_body.g.dart';

/// ForgotPasswordBody
///
/// Properties:
/// * [email]
@BuiltValue()
abstract class ForgotPasswordBody
    implements Built<ForgotPasswordBody, ForgotPasswordBodyBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  ForgotPasswordBody._();

  factory ForgotPasswordBody([void updates(ForgotPasswordBodyBuilder b)]) =
      _$ForgotPasswordBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ForgotPasswordBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ForgotPasswordBody> get serializer =>
      _$ForgotPasswordBodySerializer();
}

class _$ForgotPasswordBodySerializer
    implements PrimitiveSerializer<ForgotPasswordBody> {
  @override
  final Iterable<Type> types = const [ForgotPasswordBody, _$ForgotPasswordBody];

  @override
  final String wireName = r'ForgotPasswordBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ForgotPasswordBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ForgotPasswordBody object, {
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
    required ForgotPasswordBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ForgotPasswordBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ForgotPasswordBodyBuilder();
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
