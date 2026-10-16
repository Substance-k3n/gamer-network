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
import 'package:api_client/src/model/user_role.dart';
import 'package:api_client/src/model/profile_stats_dto.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:api_client/src/model/age_range.dart';
import 'package:api_client/src/model/platform.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'me_dto.g.dart';

/// MeDto
///
/// Properties:
/// * [status] - Already reset to not_available once its time has passed.
/// * [ageRange]
/// * [availableDays]
/// * [platforms]
/// * [tags]
/// * [relationship]
/// * [role]
/// * [email]
/// * [emailVerified]
/// * [hasPassword] - False for Google-only accounts, so Settings can offer \"Set a password\".
/// * [country]
/// * [onboardedAt] - Null until \"Go live\"; route to onboarding while null.
/// * [createdAt]
/// * [waitlist] - Waitlist topics joined (POST /v1/waitlist), e.g. \"groups\".
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
abstract class MeDto implements Built<MeDto, MeDtoBuilder> {
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

  @BuiltValueField(wireName: r'role')
  UserRole get role;
  // enum roleEnum {  player,  admin,  };

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'emailVerified')
  bool get emailVerified;

  /// False for Google-only accounts, so Settings can offer \"Set a password\".
  @BuiltValueField(wireName: r'hasPassword')
  bool get hasPassword;

  @BuiltValueField(wireName: r'country')
  String get country;

  /// Null until \"Go live\"; route to onboarding while null.
  @BuiltValueField(wireName: r'onboardedAt')
  DateTime? get onboardedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Waitlist topics joined (POST /v1/waitlist), e.g. \"groups\".
  @BuiltValueField(wireName: r'waitlist')
  BuiltList<String> get waitlist;

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

  MeDto._();

  factory MeDto([void updates(MeDtoBuilder b)]) = _$MeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MeDto> get serializer => _$MeDtoSerializer();
}

class _$MeDtoSerializer implements PrimitiveSerializer<MeDto> {
  @override
  final Iterable<Type> types = const [MeDto, _$MeDto];

  @override
  final String wireName = r'MeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MeDto object, {
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
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(UserRole),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'emailVerified';
    yield serializers.serialize(
      object.emailVerified,
      specifiedType: const FullType(bool),
    );
    yield r'hasPassword';
    yield serializers.serialize(
      object.hasPassword,
      specifiedType: const FullType(bool),
    );
    yield r'country';
    yield serializers.serialize(
      object.country,
      specifiedType: const FullType(String),
    );
    yield r'onboardedAt';
    yield object.onboardedAt == null
        ? null
        : serializers.serialize(
            object.onboardedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'waitlist';
    yield serializers.serialize(
      object.waitlist,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
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
    MeDto object, {
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
    required MeDtoBuilder result,
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
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserRole),
          ) as UserRole;
          result.role = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'emailVerified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.emailVerified = valueDes;
          break;
        case r'hasPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasPassword = valueDes;
          break;
        case r'country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.country = valueDes;
          break;
        case r'onboardedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.onboardedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'waitlist':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.waitlist.replace(valueDes);
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
  MeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MeDtoBuilder();
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
