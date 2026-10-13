//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:api_client/src/model/role_ref_dto.dart';
import 'package:api_client/src/model/rank_ref_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_game_dto.g.dart';

/// UserGameDto
///
/// Properties:
/// * [id]
/// * [game] - Null for a custom game.
/// * [customGameName] - Set only for a custom game.
/// * [rank]
/// * [rankText] - Free-text level, custom games only.
/// * [role]
@BuiltValue()
abstract class UserGameDto implements Built<UserGameDto, UserGameDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Null for a custom game.
  @BuiltValueField(wireName: r'game')
  GameRefDto? get game;

  /// Set only for a custom game.
  @BuiltValueField(wireName: r'customGameName')
  String? get customGameName;

  @BuiltValueField(wireName: r'rank')
  RankRefDto? get rank;

  /// Free-text level, custom games only.
  @BuiltValueField(wireName: r'rankText')
  String? get rankText;

  @BuiltValueField(wireName: r'role')
  RoleRefDto? get role;

  UserGameDto._();

  factory UserGameDto([void updates(UserGameDtoBuilder b)]) = _$UserGameDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserGameDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserGameDto> get serializer => _$UserGameDtoSerializer();
}

class _$UserGameDtoSerializer implements PrimitiveSerializer<UserGameDto> {
  @override
  final Iterable<Type> types = const [UserGameDto, _$UserGameDto];

  @override
  final String wireName = r'UserGameDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserGameDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'game';
    yield object.game == null
        ? null
        : serializers.serialize(
            object.game,
            specifiedType: const FullType.nullable(GameRefDto),
          );
    yield r'customGameName';
    yield object.customGameName == null
        ? null
        : serializers.serialize(
            object.customGameName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'rank';
    yield object.rank == null
        ? null
        : serializers.serialize(
            object.rank,
            specifiedType: const FullType.nullable(RankRefDto),
          );
    yield r'rankText';
    yield object.rankText == null
        ? null
        : serializers.serialize(
            object.rankText,
            specifiedType: const FullType.nullable(String),
          );
    yield r'role';
    yield object.role == null
        ? null
        : serializers.serialize(
            object.role,
            specifiedType: const FullType.nullable(RoleRefDto),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserGameDto object, {
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
    required UserGameDtoBuilder result,
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
        case r'game':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GameRefDto),
          ) as GameRefDto?;
          if (valueDes == null) continue;
          result.game.replace(valueDes);
          break;
        case r'customGameName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customGameName = valueDes;
          break;
        case r'rank':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RankRefDto),
          ) as RankRefDto?;
          if (valueDes == null) continue;
          result.rank.replace(valueDes);
          break;
        case r'rankText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rankText = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RoleRefDto),
          ) as RoleRefDto?;
          if (valueDes == null) continue;
          result.role.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserGameDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserGameDtoBuilder();
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
