//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_game_dto.dart';
import 'package:api_client/src/model/player_status.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_card_dto.g.dart';

/// UserCardDto
///
/// Properties:
/// * [status] - Already reset to not_available once its time has passed.
/// * [id]
/// * [username]
/// * [displayName]
/// * [avatarUrl]
/// * [city]
/// * [statusGame] - The game behind \"Playing …\".
/// * [topGame] - First game on the profile.
@BuiltValue()
abstract class UserCardDto implements Built<UserCardDto, UserCardDtoBuilder> {
  /// Already reset to not_available once its time has passed.
  @BuiltValueField(wireName: r'status')
  PlayerStatus get status;
  // enum statusEnum {  looking,  playing,  available_tonight,  not_available,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'avatarUrl')
  String? get avatarUrl;

  @BuiltValueField(wireName: r'city')
  String get city;

  /// The game behind \"Playing …\".
  @BuiltValueField(wireName: r'statusGame')
  GameRefDto? get statusGame;

  /// First game on the profile.
  @BuiltValueField(wireName: r'topGame')
  UserGameDto? get topGame;

  UserCardDto._();

  factory UserCardDto([void updates(UserCardDtoBuilder b)]) = _$UserCardDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserCardDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserCardDto> get serializer => _$UserCardDtoSerializer();
}

class _$UserCardDtoSerializer implements PrimitiveSerializer<UserCardDto> {
  @override
  final Iterable<Type> types = const [UserCardDto, _$UserCardDto];

  @override
  final String wireName = r'UserCardDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserCardDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PlayerStatus),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'avatarUrl';
    yield object.avatarUrl == null
        ? null
        : serializers.serialize(
            object.avatarUrl,
            specifiedType: const FullType.nullable(String),
          );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'statusGame';
    yield object.statusGame == null
        ? null
        : serializers.serialize(
            object.statusGame,
            specifiedType: const FullType.nullable(GameRefDto),
          );
    yield r'topGame';
    yield object.topGame == null
        ? null
        : serializers.serialize(
            object.topGame,
            specifiedType: const FullType.nullable(UserGameDto),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserCardDto object, {
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
    required UserCardDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlayerStatus),
          ) as PlayerStatus;
          result.status = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'avatarUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarUrl = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'statusGame':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GameRefDto),
          ) as GameRefDto?;
          if (valueDes == null) continue;
          result.statusGame.replace(valueDes);
          break;
        case r'topGame':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserGameDto),
          ) as UserGameDto?;
          if (valueDes == null) continue;
          result.topGame.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserCardDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserCardDtoBuilder();
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
