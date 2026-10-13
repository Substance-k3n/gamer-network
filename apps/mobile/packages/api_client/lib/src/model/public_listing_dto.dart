//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/listing_status.dart';
import 'package:api_client/src/model/voice.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:api_client/src/model/mode_ref_dto.dart';
import 'package:api_client/src/model/platform.dart';
import 'package:api_client/src/model/play_when.dart';
import 'package:api_client/src/model/rank_ref_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_listing_dto.g.dart';

/// PublicListingDto
///
/// Properties:
/// * [platform]
/// * [voice]
/// * [playWhen]
/// * [status]
/// * [id]
/// * [ownerDisplayName]
/// * [ownerAvatarUrl]
/// * [game]
/// * [mode]
/// * [rank]
/// * [partySize]
/// * [filled]
/// * [startsAt]
/// * [expiresAt]
/// * [note]
@BuiltValue()
abstract class PublicListingDto
    implements Built<PublicListingDto, PublicListingDtoBuilder> {
  @BuiltValueField(wireName: r'platform')
  Platform get platform;
  // enum platformEnum {  pc,  playstation,  xbox,  mobile,  switch,  };

  @BuiltValueField(wireName: r'voice')
  Voice get voice;
  // enum voiceEnum {  required,  optional,  };

  @BuiltValueField(wireName: r'playWhen')
  PlayWhen get playWhen;
  // enum playWhenEnum {  now,  tonight,  weekend,  };

  @BuiltValueField(wireName: r'status')
  ListingStatus get status;
  // enum statusEnum {  open,  full,  closed,  expired,  removed,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'ownerDisplayName')
  String get ownerDisplayName;

  @BuiltValueField(wireName: r'ownerAvatarUrl')
  String? get ownerAvatarUrl;

  @BuiltValueField(wireName: r'game')
  GameRefDto get game;

  @BuiltValueField(wireName: r'mode')
  ModeRefDto? get mode;

  @BuiltValueField(wireName: r'rank')
  RankRefDto? get rank;

  @BuiltValueField(wireName: r'partySize')
  num get partySize;

  @BuiltValueField(wireName: r'filled')
  num get filled;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'note')
  String? get note;

  PublicListingDto._();

  factory PublicListingDto([void updates(PublicListingDtoBuilder b)]) =
      _$PublicListingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicListingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicListingDto> get serializer =>
      _$PublicListingDtoSerializer();
}

class _$PublicListingDtoSerializer
    implements PrimitiveSerializer<PublicListingDto> {
  @override
  final Iterable<Type> types = const [PublicListingDto, _$PublicListingDto];

  @override
  final String wireName = r'PublicListingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicListingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'platform';
    yield serializers.serialize(
      object.platform,
      specifiedType: const FullType(Platform),
    );
    yield r'voice';
    yield serializers.serialize(
      object.voice,
      specifiedType: const FullType(Voice),
    );
    yield r'playWhen';
    yield serializers.serialize(
      object.playWhen,
      specifiedType: const FullType(PlayWhen),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ListingStatus),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'ownerDisplayName';
    yield serializers.serialize(
      object.ownerDisplayName,
      specifiedType: const FullType(String),
    );
    yield r'ownerAvatarUrl';
    yield object.ownerAvatarUrl == null
        ? null
        : serializers.serialize(
            object.ownerAvatarUrl,
            specifiedType: const FullType.nullable(String),
          );
    yield r'game';
    yield serializers.serialize(
      object.game,
      specifiedType: const FullType(GameRefDto),
    );
    yield r'mode';
    yield object.mode == null
        ? null
        : serializers.serialize(
            object.mode,
            specifiedType: const FullType.nullable(ModeRefDto),
          );
    yield r'rank';
    yield object.rank == null
        ? null
        : serializers.serialize(
            object.rank,
            specifiedType: const FullType.nullable(RankRefDto),
          );
    yield r'partySize';
    yield serializers.serialize(
      object.partySize,
      specifiedType: const FullType(num),
    );
    yield r'filled';
    yield serializers.serialize(
      object.filled,
      specifiedType: const FullType(num),
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
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicListingDto object, {
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
    required PublicListingDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'platform':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Platform),
          ) as Platform;
          result.platform = valueDes;
          break;
        case r'voice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Voice),
          ) as Voice;
          result.voice = valueDes;
          break;
        case r'playWhen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlayWhen),
          ) as PlayWhen;
          result.playWhen = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingStatus),
          ) as ListingStatus;
          result.status = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'ownerDisplayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerDisplayName = valueDes;
          break;
        case r'ownerAvatarUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ownerAvatarUrl = valueDes;
          break;
        case r'game':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GameRefDto),
          ) as GameRefDto;
          result.game.replace(valueDes);
          break;
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ModeRefDto),
          ) as ModeRefDto?;
          if (valueDes == null) continue;
          result.mode.replace(valueDes);
          break;
        case r'rank':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RankRefDto),
          ) as RankRefDto?;
          if (valueDes == null) continue;
          result.rank.replace(valueDes);
          break;
        case r'partySize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.partySize = valueDes;
          break;
        case r'filled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.filled = valueDes;
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
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicListingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicListingDtoBuilder();
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
