//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:api_client/src/model/invite_when.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:api_client/src/model/invite_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'play_invite_dto.g.dart';

/// PlayInviteDto
///
/// Properties:
/// * [playWhen]
/// * [status] - expired as soon as expiresAt passes while pending.
/// * [id]
/// * [from]
/// * [to]
/// * [game]
/// * [startsAt]
/// * [expiresAt] - Count down to this; unanswered by then, it is expired.
/// * [createdAt]
@BuiltValue()
abstract class PlayInviteDto
    implements Built<PlayInviteDto, PlayInviteDtoBuilder> {
  @BuiltValueField(wireName: r'playWhen')
  InviteWhen get playWhen;
  // enum playWhenEnum {  now,  in_30_min,  tonight,  };

  /// expired as soon as expiresAt passes while pending.
  @BuiltValueField(wireName: r'status')
  InviteStatus get status;
  // enum statusEnum {  pending,  accepted,  declined,  expired,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'from')
  UserCardDto get from;

  @BuiltValueField(wireName: r'to')
  UserCardDto get to;

  @BuiltValueField(wireName: r'game')
  GameRefDto get game;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  /// Count down to this; unanswered by then, it is expired.
  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PlayInviteDto._();

  factory PlayInviteDto([void updates(PlayInviteDtoBuilder b)]) =
      _$PlayInviteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlayInviteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlayInviteDto> get serializer =>
      _$PlayInviteDtoSerializer();
}

class _$PlayInviteDtoSerializer implements PrimitiveSerializer<PlayInviteDto> {
  @override
  final Iterable<Type> types = const [PlayInviteDto, _$PlayInviteDto];

  @override
  final String wireName = r'PlayInviteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlayInviteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'playWhen';
    yield serializers.serialize(
      object.playWhen,
      specifiedType: const FullType(InviteWhen),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(InviteStatus),
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
    yield r'game';
    yield serializers.serialize(
      object.game,
      specifiedType: const FullType(GameRefDto),
    );
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
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
    PlayInviteDto object, {
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
    required PlayInviteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'playWhen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InviteWhen),
          ) as InviteWhen;
          result.playWhen = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InviteStatus),
          ) as InviteStatus;
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
        case r'game':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GameRefDto),
          ) as GameRefDto;
          result.game.replace(valueDes);
          break;
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
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
  PlayInviteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlayInviteDtoBuilder();
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
