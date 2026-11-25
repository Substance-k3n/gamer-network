//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/platform.dart';
import 'package:api_client/src/model/rank_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_game_dto.g.dart';

/// AdminGameDto
///
/// Properties:
/// * [platforms]
/// * [id]
/// * [name]
/// * [shortCode]
/// * [hasRanks]
/// * [maxParty]
/// * [isLaunch]
/// * [sort] - Catalog order, lowest first.
/// * [ranks] - Lowest first.
/// * [players] - Players with it on their profile.
/// * [liveListings] - Open or full listings for it right now.
/// * [deletedAt] - Set when an admin deleted it.
@BuiltValue()
abstract class AdminGameDto
    implements Built<AdminGameDto, AdminGameDtoBuilder> {
  @BuiltValueField(wireName: r'platforms')
  BuiltList<Platform> get platforms;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'shortCode')
  String get shortCode;

  @BuiltValueField(wireName: r'hasRanks')
  bool get hasRanks;

  @BuiltValueField(wireName: r'maxParty')
  num get maxParty;

  @BuiltValueField(wireName: r'isLaunch')
  bool get isLaunch;

  /// Catalog order, lowest first.
  @BuiltValueField(wireName: r'sort')
  num get sort;

  /// Lowest first.
  @BuiltValueField(wireName: r'ranks')
  BuiltList<RankDto> get ranks;

  /// Players with it on their profile.
  @BuiltValueField(wireName: r'players')
  num get players;

  /// Open or full listings for it right now.
  @BuiltValueField(wireName: r'liveListings')
  num get liveListings;

  /// Set when an admin deleted it.
  @BuiltValueField(wireName: r'deletedAt')
  DateTime? get deletedAt;

  AdminGameDto._();

  factory AdminGameDto([void updates(AdminGameDtoBuilder b)]) = _$AdminGameDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminGameDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminGameDto> get serializer => _$AdminGameDtoSerializer();
}

class _$AdminGameDtoSerializer implements PrimitiveSerializer<AdminGameDto> {
  @override
  final Iterable<Type> types = const [AdminGameDto, _$AdminGameDto];

  @override
  final String wireName = r'AdminGameDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminGameDto object, {
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
    yield r'sort';
    yield serializers.serialize(
      object.sort,
      specifiedType: const FullType(num),
    );
    yield r'ranks';
    yield serializers.serialize(
      object.ranks,
      specifiedType: const FullType(BuiltList, [FullType(RankDto)]),
    );
    yield r'players';
    yield serializers.serialize(
      object.players,
      specifiedType: const FullType(num),
    );
    yield r'liveListings';
    yield serializers.serialize(
      object.liveListings,
      specifiedType: const FullType(num),
    );
    yield r'deletedAt';
    yield object.deletedAt == null
        ? null
        : serializers.serialize(
            object.deletedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminGameDto object, {
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
    required AdminGameDtoBuilder result,
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
        case r'sort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.sort = valueDes;
          break;
        case r'ranks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RankDto)]),
          ) as BuiltList<RankDto>;
          result.ranks.replace(valueDes);
          break;
        case r'players':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.players = valueDes;
          break;
        case r'liveListings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.liveListings = valueDes;
          break;
        case r'deletedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.deletedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminGameDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminGameDtoBuilder();
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
