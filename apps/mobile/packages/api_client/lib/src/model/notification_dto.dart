//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:api_client/src/model/notification_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_dto.g.dart';

/// NotificationDto
///
/// Properties:
/// * [type]
/// * [id]
/// * [actor] - Who caused it; for check_in_due, who you played with.
/// * [listingId]
/// * [connectionRequestId]
/// * [playInviteId]
/// * [checkInId]
/// * [title] - Push title.
/// * [text] - Ready to show, e.g. \"Hana wants to play PUBG Mobile with you\".
/// * [route] - In-app path to open on tap, same as the push's data.route.
/// * [readAt]
/// * [createdAt]
@BuiltValue()
abstract class NotificationDto
    implements Built<NotificationDto, NotificationDtoBuilder> {
  @BuiltValueField(wireName: r'type')
  NotificationType get type;
  // enum typeEnum {  connection_request,  connection_accepted,  play_invite,  play_invite_accepted,  check_in_due,  listing_expiring,  report_resolved,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  /// Who caused it; for check_in_due, who you played with.
  @BuiltValueField(wireName: r'actor')
  UserCardDto? get actor;

  @BuiltValueField(wireName: r'listingId')
  String? get listingId;

  @BuiltValueField(wireName: r'connectionRequestId')
  String? get connectionRequestId;

  @BuiltValueField(wireName: r'playInviteId')
  String? get playInviteId;

  @BuiltValueField(wireName: r'checkInId')
  String? get checkInId;

  /// Push title.
  @BuiltValueField(wireName: r'title')
  String get title;

  /// Ready to show, e.g. \"Hana wants to play PUBG Mobile with you\".
  @BuiltValueField(wireName: r'text')
  String get text;

  /// In-app path to open on tap, same as the push's data.route.
  @BuiltValueField(wireName: r'route')
  String get route;

  @BuiltValueField(wireName: r'readAt')
  DateTime? get readAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  NotificationDto._();

  factory NotificationDto([void updates(NotificationDtoBuilder b)]) =
      _$NotificationDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationDto> get serializer =>
      _$NotificationDtoSerializer();
}

class _$NotificationDtoSerializer
    implements PrimitiveSerializer<NotificationDto> {
  @override
  final Iterable<Type> types = const [NotificationDto, _$NotificationDto];

  @override
  final String wireName = r'NotificationDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(NotificationType),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'actor';
    yield object.actor == null
        ? null
        : serializers.serialize(
            object.actor,
            specifiedType: const FullType.nullable(UserCardDto),
          );
    yield r'listingId';
    yield object.listingId == null
        ? null
        : serializers.serialize(
            object.listingId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'connectionRequestId';
    yield object.connectionRequestId == null
        ? null
        : serializers.serialize(
            object.connectionRequestId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'playInviteId';
    yield object.playInviteId == null
        ? null
        : serializers.serialize(
            object.playInviteId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'checkInId';
    yield object.checkInId == null
        ? null
        : serializers.serialize(
            object.checkInId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'text';
    yield serializers.serialize(
      object.text,
      specifiedType: const FullType(String),
    );
    yield r'route';
    yield serializers.serialize(
      object.route,
      specifiedType: const FullType(String),
    );
    yield r'readAt';
    yield object.readAt == null
        ? null
        : serializers.serialize(
            object.readAt,
            specifiedType: const FullType.nullable(DateTime),
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
    NotificationDto object, {
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
    required NotificationDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NotificationType),
          ) as NotificationType;
          result.type = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserCardDto),
          ) as UserCardDto?;
          if (valueDes == null) continue;
          result.actor.replace(valueDes);
          break;
        case r'listingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.listingId = valueDes;
          break;
        case r'connectionRequestId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.connectionRequestId = valueDes;
          break;
        case r'playInviteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.playInviteId = valueDes;
          break;
        case r'checkInId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checkInId = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.text = valueDes;
          break;
        case r'route':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.route = valueDes;
          break;
        case r'readAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.readAt = valueDes;
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
  NotificationDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDtoBuilder();
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
