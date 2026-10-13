//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'check_in_dto.g.dart';

/// CheckInDto
///
/// Properties:
/// * [id]
/// * [other] - Who you were matched with.
/// * [game] - The game of the listing or invite that led here.
/// * [listingId]
/// * [playInviteId]
/// * [dueAt]
@BuiltValue()
abstract class CheckInDto implements Built<CheckInDto, CheckInDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Who you were matched with.
  @BuiltValueField(wireName: r'other')
  UserCardDto get other;

  /// The game of the listing or invite that led here.
  @BuiltValueField(wireName: r'game')
  GameRefDto? get game;

  @BuiltValueField(wireName: r'listingId')
  String? get listingId;

  @BuiltValueField(wireName: r'playInviteId')
  String? get playInviteId;

  @BuiltValueField(wireName: r'dueAt')
  DateTime get dueAt;

  CheckInDto._();

  factory CheckInDto([void updates(CheckInDtoBuilder b)]) = _$CheckInDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckInDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckInDto> get serializer => _$CheckInDtoSerializer();
}

class _$CheckInDtoSerializer implements PrimitiveSerializer<CheckInDto> {
  @override
  final Iterable<Type> types = const [CheckInDto, _$CheckInDto];

  @override
  final String wireName = r'CheckInDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckInDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'other';
    yield serializers.serialize(
      object.other,
      specifiedType: const FullType(UserCardDto),
    );
    yield r'game';
    yield object.game == null
        ? null
        : serializers.serialize(
            object.game,
            specifiedType: const FullType.nullable(GameRefDto),
          );
    yield r'listingId';
    yield object.listingId == null
        ? null
        : serializers.serialize(
            object.listingId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'playInviteId';
    yield object.playInviteId == null
        ? null
        : serializers.serialize(
            object.playInviteId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'dueAt';
    yield serializers.serialize(
      object.dueAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckInDto object, {
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
    required CheckInDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'other':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserCardDto),
          ) as UserCardDto;
          result.other.replace(valueDes);
          break;
        case r'game':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GameRefDto),
          ) as GameRefDto?;
          if (valueDes == null) continue;
          result.game.replace(valueDes);
          break;
        case r'listingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.listingId = valueDes;
          break;
        case r'playInviteId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.playInviteId = valueDes;
          break;
        case r'dueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.dueAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckInDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckInDtoBuilder();
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
