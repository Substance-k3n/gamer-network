//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/age_range.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_me_body.g.dart';

/// UpdateMeBody
///
/// Properties:
/// * [ageRange]
/// * [displayName]
/// * [username] - Stored lowercase.
/// * [bio] - Send \"\" or null to clear.
/// * [city]
@BuiltValue()
abstract class UpdateMeBody
    implements Built<UpdateMeBody, UpdateMeBodyBuilder> {
  @BuiltValueField(wireName: r'ageRange')
  AgeRange? get ageRange;
  // enum ageRangeEnum {  16_17,  18_24,  25_34,  35_plus,  };

  @BuiltValueField(wireName: r'displayName')
  String? get displayName;

  /// Stored lowercase.
  @BuiltValueField(wireName: r'username')
  String? get username;

  /// Send \"\" or null to clear.
  @BuiltValueField(wireName: r'bio')
  String? get bio;

  @BuiltValueField(wireName: r'city')
  String? get city;

  UpdateMeBody._();

  factory UpdateMeBody([void updates(UpdateMeBodyBuilder b)]) = _$UpdateMeBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateMeBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateMeBody> get serializer => _$UpdateMeBodySerializer();
}

class _$UpdateMeBodySerializer implements PrimitiveSerializer<UpdateMeBody> {
  @override
  final Iterable<Type> types = const [UpdateMeBody, _$UpdateMeBody];

  @override
  final String wireName = r'UpdateMeBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateMeBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.ageRange != null) {
      yield r'ageRange';
      yield serializers.serialize(
        object.ageRange,
        specifiedType: const FullType(AgeRange),
      );
    }
    if (object.displayName != null) {
      yield r'displayName';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
    if (object.username != null) {
      yield r'username';
      yield serializers.serialize(
        object.username,
        specifiedType: const FullType(String),
      );
    }
    if (object.bio != null) {
      yield r'bio';
      yield serializers.serialize(
        object.bio,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.city != null) {
      yield r'city';
      yield serializers.serialize(
        object.city,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateMeBody object, {
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
    required UpdateMeBodyBuilder result,
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
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.username = valueDes;
          break;
        case r'bio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bio = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.city = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateMeBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateMeBodyBuilder();
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
