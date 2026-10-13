//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/age_range.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_body.g.dart';

/// GoogleBody
///
/// Properties:
/// * [ageRange]
/// * [idToken] - From Google Sign-In on the device, or Google Identity Services on the web.
/// * [username] - Only for a new account: send after a 422 signup_details_required.
/// * [displayName] - Defaults to the name on the Google account.
@BuiltValue()
abstract class GoogleBody implements Built<GoogleBody, GoogleBodyBuilder> {
  @BuiltValueField(wireName: r'ageRange')
  AgeRange? get ageRange;
  // enum ageRangeEnum {  16_17,  18_24,  25_34,  35_plus,  };

  /// From Google Sign-In on the device, or Google Identity Services on the web.
  @BuiltValueField(wireName: r'idToken')
  String get idToken;

  /// Only for a new account: send after a 422 signup_details_required.
  @BuiltValueField(wireName: r'username')
  String? get username;

  /// Defaults to the name on the Google account.
  @BuiltValueField(wireName: r'displayName')
  String? get displayName;

  GoogleBody._();

  factory GoogleBody([void updates(GoogleBodyBuilder b)]) = _$GoogleBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoogleBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoogleBody> get serializer => _$GoogleBodySerializer();
}

class _$GoogleBodySerializer implements PrimitiveSerializer<GoogleBody> {
  @override
  final Iterable<Type> types = const [GoogleBody, _$GoogleBody];

  @override
  final String wireName = r'GoogleBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoogleBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.ageRange != null) {
      yield r'ageRange';
      yield serializers.serialize(
        object.ageRange,
        specifiedType: const FullType(AgeRange),
      );
    }
    yield r'idToken';
    yield serializers.serialize(
      object.idToken,
      specifiedType: const FullType(String),
    );
    if (object.username != null) {
      yield r'username';
      yield serializers.serialize(
        object.username,
        specifiedType: const FullType(String),
      );
    }
    if (object.displayName != null) {
      yield r'displayName';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GoogleBody object, {
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
    required GoogleBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ageRange':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AgeRange),
          ) as AgeRange?;
          if (valueDes == null) continue;
          result.ageRange = valueDes;
          break;
        case r'idToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idToken = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.username = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoogleBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoogleBodyBuilder();
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
