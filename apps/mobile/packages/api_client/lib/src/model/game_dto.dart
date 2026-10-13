//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/role_dto.dart';
import 'package:api_client/src/model/mode_dto.dart';
import 'package:api_client/src/model/platform.dart';
import 'package:api_client/src/model/rank_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'game_dto.g.dart';

/// GameDto
///
/// Properties:
/// * [platforms]
/// * [id] - Short id shared with the app's catalog, e.g. \"val\".
/// * [name]
/// * [shortCode] - Tile label, e.g. \"VAL\".
/// * [hasRanks] - False when the ladder is play-style levels rather than ranks.
/// * [maxParty] - Largest party a listing can ask for: 2 = Duo … 5 = 5-stack.
/// * [isLaunch] - Launch games are the ones Find Players offers.
/// * [ranks] - Lowest first.
/// * [roles]
/// * [modes]
@BuiltValue()
abstract class GameDto implements Built<GameDto, GameDtoBuilder> {
  @BuiltValueField(wireName: r'platforms')
  BuiltList<Platform> get platforms;

  /// Short id shared with the app's catalog, e.g. \"val\".
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Tile label, e.g. \"VAL\".
  @BuiltValueField(wireName: r'shortCode')
  String get shortCode;

  /// False when the ladder is play-style levels rather than ranks.
  @BuiltValueField(wireName: r'hasRanks')
  bool get hasRanks;

  /// Largest party a listing can ask for: 2 = Duo … 5 = 5-stack.
  @BuiltValueField(wireName: r'maxParty')
  num get maxParty;

  /// Launch games are the ones Find Players offers.
  @BuiltValueField(wireName: r'isLaunch')
  bool get isLaunch;

  /// Lowest first.
  @BuiltValueField(wireName: r'ranks')
  BuiltList<RankDto> get ranks;

  @BuiltValueField(wireName: r'roles')
  BuiltList<RoleDto> get roles;

  @BuiltValueField(wireName: r'modes')
  BuiltList<ModeDto> get modes;

  GameDto._();

  factory GameDto([void updates(GameDtoBuilder b)]) = _$GameDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GameDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GameDto> get serializer => _$GameDtoSerializer();
}

class _$GameDtoSerializer implements PrimitiveSerializer<GameDto> {
  @override
  final Iterable<Type> types = const [GameDto, _$GameDto];

  @override
  final String wireName = r'GameDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GameDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'platforms';
    yield serializers.serialize(
      object.platforms,
      specifiedType: const FullType(BuiltList, [FullType(Platform)]),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'shortCode';
    yield serializers.serialize(
      object.shortCode,
      specifiedType: const FullType(String),
    );
    yield r'hasRanks';
    yield serializers.serialize(
      object.hasRanks,
      specifiedType: const FullType(bool),
    );
    yield r'maxParty';
    yield serializers.serialize(
      object.maxParty,
      specifiedType: const FullType(num),
    );
    yield r'isLaunch';
    yield serializers.serialize(
      object.isLaunch,
      specifiedType: const FullType(bool),
    );
    yield r'ranks';
    yield serializers.serialize(
      object.ranks,
      specifiedType: const FullType(BuiltList, [FullType(RankDto)]),
    );
    yield r'roles';
    yield serializers.serialize(
      object.roles,
      specifiedType: const FullType(BuiltList, [FullType(RoleDto)]),
    );
    yield r'modes';
    yield serializers.serialize(
      object.modes,
      specifiedType: const FullType(BuiltList, [FullType(ModeDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GameDto object, {
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
    required GameDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'platforms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Platform)]),
          ) as BuiltList<Platform>;
          result.platforms.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'shortCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.shortCode = valueDes;
          break;
        case r'hasRanks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasRanks = valueDes;
          break;
        case r'maxParty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.maxParty = valueDes;
          break;
        case r'isLaunch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isLaunch = valueDes;
          break;
        case r'ranks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RankDto)]),
          ) as BuiltList<RankDto>;
          result.ranks.replace(valueDes);
          break;
        case r'roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RoleDto)]),
          ) as BuiltList<RoleDto>;
          result.roles.replace(valueDes);
          break;
        case r'modes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ModeDto)]),
          ) as BuiltList<ModeDto>;
          result.modes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GameDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GameDtoBuilder();
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
