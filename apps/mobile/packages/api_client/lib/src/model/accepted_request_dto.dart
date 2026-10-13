//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/connection_request_dto.dart';
import 'package:api_client/src/model/connection_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'accepted_request_dto.g.dart';

/// AcceptedRequestDto
///
/// Properties:
/// * [request]
/// * [connection]
@BuiltValue()
abstract class AcceptedRequestDto
    implements Built<AcceptedRequestDto, AcceptedRequestDtoBuilder> {
  @BuiltValueField(wireName: r'request')
  ConnectionRequestDto get request;

  @BuiltValueField(wireName: r'connection')
  ConnectionDto get connection;

  AcceptedRequestDto._();

  factory AcceptedRequestDto([void updates(AcceptedRequestDtoBuilder b)]) =
      _$AcceptedRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AcceptedRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AcceptedRequestDto> get serializer =>
      _$AcceptedRequestDtoSerializer();
}

class _$AcceptedRequestDtoSerializer
    implements PrimitiveSerializer<AcceptedRequestDto> {
  @override
  final Iterable<Type> types = const [AcceptedRequestDto, _$AcceptedRequestDto];

  @override
  final String wireName = r'AcceptedRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AcceptedRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'request';
    yield serializers.serialize(
      object.request,
      specifiedType: const FullType(ConnectionRequestDto),
    );
    yield r'connection';
    yield serializers.serialize(
      object.connection,
      specifiedType: const FullType(ConnectionDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AcceptedRequestDto object, {
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
    required AcceptedRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'request':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ConnectionRequestDto),
          ) as ConnectionRequestDto;
          result.request.replace(valueDes);
          break;
        case r'connection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ConnectionDto),
          ) as ConnectionDto;
          result.connection.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AcceptedRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AcceptedRequestDtoBuilder();
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
