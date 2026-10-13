//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:api_client/src/model/listing_status.dart';
import 'package:api_client/src/model/my_request_dto.dart';
import 'package:api_client/src/model/voice.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/play_style.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:api_client/src/model/mode_ref_dto.dart';
import 'package:api_client/src/model/platform.dart';
import 'package:api_client/src/model/play_when.dart';
import 'package:api_client/src/model/rank_ref_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_dto.g.dart';

/// ListingDto
///
/// Properties:
/// * [platform]
/// * [voice]
/// * [style]
/// * [playWhen]
/// * [durationHours]
/// * [status] - expired as soon as expiresAt passes, even before the expiry job runs.
/// * [id]
/// * [owner]
/// * [game]
/// * [mode]
/// * [rank]
/// * [partySize] - Whole party including the owner: 2 = Duo … 5 = 5-stack.
/// * [filled] - Players accepted so far, owner not counted.
/// * [startsAt]
/// * [expiresAt] - Count down to this.
/// * [note]
/// * [createdAt]
/// * [myRequest] - Your latest request to join, for \"Requested…\" / \"Connected ✓\". Null on your own.
/// * [shareUrl] - Link for Telegram/WhatsApp.
@BuiltValue()
abstract class ListingDto implements Built<ListingDto, ListingDtoBuilder> {
  @BuiltValueField(wireName: r'platform')
  Platform get platform;
  // enum platformEnum {  pc,  playstation,  xbox,  mobile,  switch,  };

  @BuiltValueField(wireName: r'voice')
  Voice get voice;
  // enum voiceEnum {  required,  optional,  };

  @BuiltValueField(wireName: r'style')
  PlayStyle get style;
  // enum styleEnum {  competitive,  casual,  };

  @BuiltValueField(wireName: r'playWhen')
  PlayWhen get playWhen;
  // enum playWhenEnum {  now,  tonight,  weekend,  };

  @BuiltValueField(wireName: r'durationHours')
  ListingDtoDurationHoursEnum get durationHours;
  // enum durationHoursEnum {  2,  6,  24,  };

  /// expired as soon as expiresAt passes, even before the expiry job runs.
  @BuiltValueField(wireName: r'status')
  ListingStatus get status;
  // enum statusEnum {  open,  full,  closed,  expired,  removed,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'owner')
  UserCardDto get owner;

  @BuiltValueField(wireName: r'game')
  GameRefDto get game;

  @BuiltValueField(wireName: r'mode')
  ModeRefDto? get mode;

  @BuiltValueField(wireName: r'rank')
  RankRefDto? get rank;

  /// Whole party including the owner: 2 = Duo … 5 = 5-stack.
  @BuiltValueField(wireName: r'partySize')
  num get partySize;

  /// Players accepted so far, owner not counted.
  @BuiltValueField(wireName: r'filled')
  num get filled;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  /// Count down to this.
  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Your latest request to join, for \"Requested…\" / \"Connected ✓\". Null on your own.
  @BuiltValueField(wireName: r'myRequest')
  MyRequestDto? get myRequest;

  /// Link for Telegram/WhatsApp.
  @BuiltValueField(wireName: r'shareUrl')
  String get shareUrl;

  ListingDto._();

  factory ListingDto([void updates(ListingDtoBuilder b)]) = _$ListingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingDto> get serializer => _$ListingDtoSerializer();
}

class _$ListingDtoSerializer implements PrimitiveSerializer<ListingDto> {
  @override
  final Iterable<Type> types = const [ListingDto, _$ListingDto];

  @override
  final String wireName = r'ListingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingDto object, {
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
    yield r'style';
    yield serializers.serialize(
      object.style,
      specifiedType: const FullType(PlayStyle),
    );
    yield r'playWhen';
    yield serializers.serialize(
      object.playWhen,
      specifiedType: const FullType(PlayWhen),
    );
    yield r'durationHours';
    yield serializers.serialize(
      object.durationHours,
      specifiedType: const FullType(ListingDtoDurationHoursEnum),
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
    yield r'owner';
    yield serializers.serialize(
      object.owner,
      specifiedType: const FullType(UserCardDto),
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
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'myRequest';
    yield object.myRequest == null
        ? null
        : serializers.serialize(
            object.myRequest,
            specifiedType: const FullType.nullable(MyRequestDto),
          );
    yield r'shareUrl';
    yield serializers.serialize(
      object.shareUrl,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingDto object, {
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
    required ListingDtoBuilder result,
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
        case r'style':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlayStyle),
          ) as PlayStyle;
          result.style = valueDes;
          break;
        case r'playWhen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlayWhen),
          ) as PlayWhen;
          result.playWhen = valueDes;
          break;
        case r'durationHours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingDtoDurationHoursEnum),
          ) as ListingDtoDurationHoursEnum;
          result.durationHours = valueDes;
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
        case r'owner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserCardDto),
          ) as UserCardDto;
          result.owner.replace(valueDes);
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
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'myRequest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MyRequestDto),
          ) as MyRequestDto?;
          if (valueDes == null) continue;
          result.myRequest.replace(valueDes);
          break;
        case r'shareUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.shareUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingDtoBuilder();
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

class ListingDtoDurationHoursEnum extends EnumClass {
  @BuiltValueEnumConst(wireNumber: 2)
  static const ListingDtoDurationHoursEnum number2 =
      _$listingDtoDurationHoursEnum_number2;
  @BuiltValueEnumConst(wireNumber: 6)
  static const ListingDtoDurationHoursEnum number6 =
      _$listingDtoDurationHoursEnum_number6;
  @BuiltValueEnumConst(wireNumber: 24)
  static const ListingDtoDurationHoursEnum number24 =
      _$listingDtoDurationHoursEnum_number24;

  static Serializer<ListingDtoDurationHoursEnum> get serializer =>
      _$listingDtoDurationHoursEnumSerializer;

  const ListingDtoDurationHoursEnum._(String name) : super(name);

  static BuiltSet<ListingDtoDurationHoursEnum> get values =>
      _$listingDtoDurationHoursEnumValues;
  static ListingDtoDurationHoursEnum valueOf(String name) =>
      _$listingDtoDurationHoursEnumValueOf(name);
}
