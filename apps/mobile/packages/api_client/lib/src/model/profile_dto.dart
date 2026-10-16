//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/gaming_id_dto.dart';
import 'package:api_client/src/model/user_game_dto.dart';
import 'package:api_client/src/model/play_tag.dart';
import 'package:api_client/src/model/day.dart';
import 'package:api_client/src/model/player_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/relationship.dart';
import 'package:api_client/src/model/profile_stats_dto.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:api_client/src/model/age_range.dart';
import 'package:api_client/src/model/platform.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profile_dto.g.dart';

/// ProfileDto
///
/// Properties:
/// * [status] - Already reset to not_available once its time has passed.
/// * [ageRange]
/// * [availableDays]
/// * [platforms]
/// * [tags]
/// * [relationship]
/// * [bio]
/// * [statusUntil] - When available_tonight or playing clears itself.
/// * [games] - In profile order.
/// * [gamingIds] - Only the ones you may see.
/// * [stats]
/// * [incomingRequestId] - Set when relationship is incoming_request, to accept from the profile.
/// * [outgoingRequestId] - Set when relationship is outgoing_request, to withdraw from the profile.
/// * [id]
/// * [username]
/// * [displayName]
/// * [avatarUrl]
/// * [city]
/// * [statusGame] - The game behind \"Playing …\".
/// * [topGame] - First game on the profile.
@BuiltValue()
abstract class ProfileDto implements Built<ProfileDto, ProfileDtoBuilder> {
  /// Already reset to not_available once its time has passed.
  @BuiltValueField(wireName: r'status')
  PlayerStatus get status;
  // enum statusEnum {  looking,  playing,  available_tonight,  not_available,  };

  @BuiltValueField(wireName: r'ageRange')
  AgeRange get ageRange;
  // enum ageRangeEnum {  16_17,  18_24,  25_34,  35_plus,  };

  @BuiltValueField(wireName: r'availableDays')
  BuiltList<Day> get availableDays;

  @BuiltValueField(wireName: r'platforms')
  BuiltList<Platform> get platforms;

  @BuiltValueField(wireName: r'tags')
  BuiltList<PlayTag> get tags;

  @BuiltValueField(wireName: r'relationship')
  Relationship get relationship;
  // enum relationshipEnum {  self,  none,  outgoing_request,  incoming_request,  connected,  };

  @BuiltValueField(wireName: r'bio')
  String? get bio;

  /// When available_tonight or playing clears itself.
  @BuiltValueField(wireName: r'statusUntil')
  DateTime? get statusUntil;

  /// In profile order.
  @BuiltValueField(wireName: r'games')
  BuiltList<UserGameDto> get games;

  /// Only the ones you may see.
  @BuiltValueField(wireName: r'gamingIds')
  BuiltList<GamingIdDto> get gamingIds;

  @BuiltValueField(wireName: r'stats')
  ProfileStatsDto get stats;

  /// Set when relationship is incoming_request, to accept from the profile.
  @BuiltValueField(wireName: r'incomingRequestId')
  String? get incomingRequestId;

  /// Set when relationship is outgoing_request, to withdraw from the profile.
  @BuiltValueField(wireName: r'outgoingRequestId')
  String? get outgoingRequestId;

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

  ProfileDto._();

  factory ProfileDto([void updates(ProfileDtoBuilder b)]) = _$ProfileDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileDto> get serializer => _$ProfileDtoSerializer();
}

class _$ProfileDtoSerializer implements PrimitiveSerializer<ProfileDto> {
  @override
  final Iterable<Type> types = const [ProfileDto, _$ProfileDto];

  @override
  final String wireName = r'ProfileDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PlayerStatus),
    );
    yield r'ageRange';
    yield serializers.serialize(
      object.ageRange,
      specifiedType: const FullType(AgeRange),
    );
    yield r'availableDays';
    yield serializers.serialize(
      object.availableDays,
      specifiedType: const FullType(BuiltList, [FullType(Day)]),
    );
    yield r'platforms';
    yield serializers.serialize(
      object.platforms,
      specifiedType: const FullType(BuiltList, [FullType(Platform)]),
    );
    yield r'tags';
    yield serializers.serialize(
      object.tags,
      specifiedType: const FullType(BuiltList, [FullType(PlayTag)]),
    );
    yield r'relationship';
    yield serializers.serialize(
      object.relationship,
      specifiedType: const FullType(Relationship),
    );
    yield r'bio';
    yield object.bio == null
        ? null
        : serializers.serialize(
            object.bio,
            specifiedType: const FullType.nullable(String),
          );
    yield r'statusUntil';
    yield object.statusUntil == null
        ? null
        : serializers.serialize(
            object.statusUntil,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'games';
    yield serializers.serialize(
      object.games,
      specifiedType: const FullType(BuiltList, [FullType(UserGameDto)]),
    );
    yield r'gamingIds';
    yield serializers.serialize(
      object.gamingIds,
      specifiedType: const FullType(BuiltList, [FullType(GamingIdDto)]),
    );
    yield r'stats';
    yield serializers.serialize(
      object.stats,
      specifiedType: const FullType(ProfileStatsDto),
    );
    yield r'incomingRequestId';
    yield object.incomingRequestId == null
        ? null
        : serializers.serialize(
            object.incomingRequestId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'outgoingRequestId';
    yield object.outgoingRequestId == null
        ? null
        : serializers.serialize(
            object.outgoingRequestId,
            specifiedType: const FullType.nullable(String),
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
    ProfileDto object, {
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
    required ProfileDtoBuilder result,
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
        case r'ageRange':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AgeRange),
          ) as AgeRange;
          result.ageRange = valueDes;
          break;
        case r'availableDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Day)]),
          ) as BuiltList<Day>;
          result.availableDays.replace(valueDes);
          break;
        case r'platforms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Platform)]),
          ) as BuiltList<Platform>;
          result.platforms.replace(valueDes);
          break;
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PlayTag)]),
          ) as BuiltList<PlayTag>;
          result.tags.replace(valueDes);
          break;
        case r'relationship':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Relationship),
          ) as Relationship;
          result.relationship = valueDes;
          break;
        case r'bio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bio = valueDes;
          break;
        case r'statusUntil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.statusUntil = valueDes;
          break;
        case r'games':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UserGameDto)]),
          ) as BuiltList<UserGameDto>;
          result.games.replace(valueDes);
          break;
        case r'gamingIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GamingIdDto)]),
          ) as BuiltList<GamingIdDto>;
          result.gamingIds.replace(valueDes);
          break;
        case r'stats':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProfileStatsDto),
          ) as ProfileStatsDto;
          result.stats.replace(valueDes);
          break;
        case r'incomingRequestId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.incomingRequestId = valueDes;
          break;
        case r'outgoingRequestId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.outgoingRequestId = valueDes;
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
  ProfileDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileDtoBuilder();
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
