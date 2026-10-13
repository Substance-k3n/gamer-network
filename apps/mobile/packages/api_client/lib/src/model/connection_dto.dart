//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'connection_dto.g.dart';

/// ConnectionDto
///
/// Properties:
/// * [user]
/// * [connectedAt]
@BuiltValue()
abstract class ConnectionDto
    implements Built<ConnectionDto, ConnectionDtoBuilder> {
  @BuiltValueField(wireName: r'user')
  UserCardDto get user;

  @BuiltValueField(wireName: r'connectedAt')
  DateTime get connectedAt;

  ConnectionDto._();

  factory ConnectionDto([void updates(ConnectionDtoBuilder b)]) =
      _$ConnectionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConnectionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConnectionDto> get serializer =>
      _$ConnectionDtoSerializer();
}

class _$ConnectionDtoSerializer implements PrimitiveSerializer<ConnectionDto> {
  @override
  final Iterable<Type> types = const [ConnectionDto, _$ConnectionDto];

  @override
  final String wireName = r'ConnectionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConnectionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserCardDto),
    );
    yield r'connectedAt';
    yield serializers.serialize(
      object.connectedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConnectionDto object, {
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
    required ConnectionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserCardDto),
          ) as UserCardDto;
          result.user.replace(valueDes);
          break;
        case r'connectedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.connectedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConnectionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConnectionDtoBuilder();
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
