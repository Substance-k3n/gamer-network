//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_avatar_body.g.dart';

/// SetAvatarBody
///
/// Properties:
/// * [key] - The key from POST /v1/me/avatar/upload-url, after the upload finished.
@BuiltValue()
abstract class SetAvatarBody
    implements Built<SetAvatarBody, SetAvatarBodyBuilder> {
  /// The key from POST /v1/me/avatar/upload-url, after the upload finished.
  @BuiltValueField(wireName: r'key')
  String get key;

  SetAvatarBody._();

  factory SetAvatarBody([void updates(SetAvatarBodyBuilder b)]) =
      _$SetAvatarBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetAvatarBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetAvatarBody> get serializer =>
      _$SetAvatarBodySerializer();
}

class _$SetAvatarBodySerializer implements PrimitiveSerializer<SetAvatarBody> {
  @override
  final Iterable<Type> types = const [SetAvatarBody, _$SetAvatarBody];

  @override
  final String wireName = r'SetAvatarBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetAvatarBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetAvatarBody object, {
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
    required SetAvatarBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.key = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetAvatarBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetAvatarBodyBuilder();
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
