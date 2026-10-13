//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/device_platform.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_device_body.g.dart';

/// RegisterDeviceBody
///
/// Properties:
/// * [platform]
/// * [appVersion]
/// * [fcmToken] - From FirebaseMessaging.getToken().
@BuiltValue()
abstract class RegisterDeviceBody
    implements Built<RegisterDeviceBody, RegisterDeviceBodyBuilder> {
  @BuiltValueField(wireName: r'platform')
  DevicePlatform get platform;
  // enum platformEnum {  android,  ios,  web,  };

  @BuiltValueField(wireName: r'appVersion')
  String? get appVersion;

  /// From FirebaseMessaging.getToken().
  @BuiltValueField(wireName: r'fcmToken')
  String get fcmToken;

  RegisterDeviceBody._();

  factory RegisterDeviceBody([void updates(RegisterDeviceBodyBuilder b)]) =
      _$RegisterDeviceBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterDeviceBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterDeviceBody> get serializer =>
      _$RegisterDeviceBodySerializer();
}

class _$RegisterDeviceBodySerializer
    implements PrimitiveSerializer<RegisterDeviceBody> {
  @override
  final Iterable<Type> types = const [RegisterDeviceBody, _$RegisterDeviceBody];

  @override
  final String wireName = r'RegisterDeviceBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterDeviceBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(DevicePlatform),
    );
    if (object.appVersion != null) {
      yield r'appVersion';
      yield serializers.serialize(
        object.appVersion,
        specifiedType: const FullType(String),
      );
    }
    yield r'fcmToken';
    yield serializers.serialize(
      object.fcmToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterDeviceBody object, {
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
    required RegisterDeviceBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DevicePlatform),
          ) as DevicePlatform;
          result.platform = valueDes;
          break;
        case r'appVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.appVersion = valueDes;
          break;
        case r'fcmToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fcmToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterDeviceBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterDeviceBodyBuilder();
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
