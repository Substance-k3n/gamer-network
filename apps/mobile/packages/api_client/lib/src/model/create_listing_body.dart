//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/voice.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/play_style.dart';
import 'package:api_client/src/model/platform.dart';
import 'package:api_client/src/model/play_when.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_listing_body.g.dart';

/// CreateListingBody
///
/// Properties:
/// * [platform] - One of the game's platforms.
/// * [voice]
/// * [style]
/// * [playWhen]
/// * [durationHours] - How long it stays up once play starts.
/// * [gameId] - A launch game (isLaunch in GET /v1/games).
/// * [modeId]
/// * [rankId] - The rank this group plays at. Defaults to your rank in this game.
/// * [partySize] - Whole party including you, up to the game's maxParty.
/// * [note]
@BuiltValue()
abstract class CreateListingBody
    implements Built<CreateListingBody, CreateListingBodyBuilder> {
  /// One of the game's platforms.
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

  /// How long it stays up once play starts.
  @BuiltValueField(wireName: r'durationHours')
  CreateListingBodyDurationHoursEnum get durationHours;
  // enum durationHoursEnum {  2,  6,  24,  };

  /// A launch game (isLaunch in GET /v1/games).
  @BuiltValueField(wireName: r'gameId')
  String get gameId;

  @BuiltValueField(wireName: r'modeId')
  String? get modeId;

  /// The rank this group plays at. Defaults to your rank in this game.
  @BuiltValueField(wireName: r'rankId')
  String? get rankId;

  /// Whole party including you, up to the game's maxParty.
  @BuiltValueField(wireName: r'partySize')
  num get partySize;

  @BuiltValueField(wireName: r'note')
  String? get note;

  CreateListingBody._();

  factory CreateListingBody([void updates(CreateListingBodyBuilder b)]) =
      _$CreateListingBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateListingBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateListingBody> get serializer =>
      _$CreateListingBodySerializer();
}

class _$CreateListingBodySerializer
    implements PrimitiveSerializer<CreateListingBody> {
  @override
  final Iterable<Type> types = const [CreateListingBody, _$CreateListingBody];

  @override
  final String wireName = r'CreateListingBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateListingBody object, {
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
      specifiedType: const FullType(CreateListingBodyDurationHoursEnum),
    );
    yield r'gameId';
    yield serializers.serialize(
      object.gameId,
      specifiedType: const FullType(String),
    );
    if (object.modeId != null) {
      yield r'modeId';
      yield serializers.serialize(
        object.modeId,
        specifiedType: const FullType(String),
      );
    }
    if (object.rankId != null) {
      yield r'rankId';
      yield serializers.serialize(
        object.rankId,
        specifiedType: const FullType(String),
      );
    }
    yield r'partySize';
    yield serializers.serialize(
      object.partySize,
      specifiedType: const FullType(num),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateListingBody object, {
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
    required CreateListingBodyBuilder result,
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
            specifiedType: const FullType(CreateListingBodyDurationHoursEnum),
          ) as CreateListingBodyDurationHoursEnum;
          result.durationHours = valueDes;
          break;
        case r'gameId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.gameId = valueDes;
          break;
        case r'modeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.modeId = valueDes;
          break;
        case r'rankId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rankId = valueDes;
          break;
        case r'partySize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.partySize = valueDes;
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
  CreateListingBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateListingBodyBuilder();
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

/// How long it stays up once play starts.
class CreateListingBodyDurationHoursEnum extends EnumClass {
  @BuiltValueEnumConst(wireNumber: 2)
  static const CreateListingBodyDurationHoursEnum number2 =
      _$createListingBodyDurationHoursEnum_number2;
  @BuiltValueEnumConst(wireNumber: 6)
  static const CreateListingBodyDurationHoursEnum number6 =
      _$createListingBodyDurationHoursEnum_number6;
  @BuiltValueEnumConst(wireNumber: 24)
  static const CreateListingBodyDurationHoursEnum number24 =
      _$createListingBodyDurationHoursEnum_number24;

  static Serializer<CreateListingBodyDurationHoursEnum> get serializer =>
      _$createListingBodyDurationHoursEnumSerializer;

  const CreateListingBodyDurationHoursEnum._(String name) : super(name);

  static BuiltSet<CreateListingBodyDurationHoursEnum> get values =>
      _$createListingBodyDurationHoursEnumValues;
  static CreateListingBodyDurationHoursEnum valueOf(String name) =>
      _$createListingBodyDurationHoursEnumValueOf(name);
}
