//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/listing_dto.dart';
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:api_client/src/model/request_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'connection_request_dto.g.dart';

/// ConnectionRequestDto
///
/// Properties:
/// * [status]
/// * [id]
/// * [from]
/// * [to]
/// * [listing] - Set when sent from a listing card (\"wants to play · Div 2 EA FC 25\").
/// * [message]
/// * [createdAt]
@BuiltValue()
abstract class ConnectionRequestDto
    implements Built<ConnectionRequestDto, ConnectionRequestDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  RequestStatus get status;
  // enum statusEnum {  pending,  accepted,  declined,  cancelled,  expired,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'from')
  UserCardDto get from;

  @BuiltValueField(wireName: r'to')
  UserCardDto get to;

  /// Set when sent from a listing card (\"wants to play · Div 2 EA FC 25\").
  @BuiltValueField(wireName: r'listing')
  ListingDto? get listing;

  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  ConnectionRequestDto._();

  factory ConnectionRequestDto([void updates(ConnectionRequestDtoBuilder b)]) =
      _$ConnectionRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConnectionRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConnectionRequestDto> get serializer =>
      _$ConnectionRequestDtoSerializer();
}

class _$ConnectionRequestDtoSerializer
    implements PrimitiveSerializer<ConnectionRequestDto> {
  @override
  final Iterable<Type> types = const [
    ConnectionRequestDto,
    _$ConnectionRequestDto
  ];

  @override
  final String wireName = r'ConnectionRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConnectionRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(RequestStatus),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(UserCardDto),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(UserCardDto),
    );
    yield r'listing';
    yield object.listing == null
        ? null
        : serializers.serialize(
            object.listing,
            specifiedType: const FullType.nullable(ListingDto),
          );
    yield r'message';
    yield object.message == null
        ? null
        : serializers.serialize(
            object.message,
            specifiedType: const FullType.nullable(String),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConnectionRequestDto object, {
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
    required ConnectionRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RequestStatus),
          ) as RequestStatus;
          result.status = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserCardDto),
          ) as UserCardDto;
          result.from.replace(valueDes);
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserCardDto),
          ) as UserCardDto;
          result.to.replace(valueDes);
          break;
        case r'listing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingDto),
          ) as ListingDto?;
          if (valueDes == null) continue;
          result.listing.replace(valueDes);
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConnectionRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConnectionRequestDtoBuilder();
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
