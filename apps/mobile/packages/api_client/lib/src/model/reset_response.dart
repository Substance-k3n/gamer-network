//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/me_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reset_response.g.dart';

/// ResetResponse
///
/// Properties:
/// * [token]
/// * [user]
@BuiltValue()
abstract class ResetResponse
    implements Built<ResetResponse, ResetResponseBuilder> {
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'user')
  MeDto get user;

  ResetResponse._();

  factory ResetResponse([void updates(ResetResponseBuilder b)]) =
      _$ResetResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResetResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResetResponse> get serializer =>
      _$ResetResponseSerializer();
}

class _$ResetResponseSerializer implements PrimitiveSerializer<ResetResponse> {
  @override
  final Iterable<Type> types = const [ResetResponse, _$ResetResponse];

  @override
  final String wireName = r'ResetResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResetResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(MeDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResetResponse object, {
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
    required ResetResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MeDto),
          ) as MeDto;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResetResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResetResponseBuilder();
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
