//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'game_popularity_dto.g.dart';

/// GamePopularityDto
///
/// Properties:
/// * [gameId]
/// * [name]
/// * [listings] - Listings for it in the range.
@BuiltValue()
abstract class GamePopularityDto
    implements Built<GamePopularityDto, GamePopularityDtoBuilder> {
  @BuiltValueField(wireName: r'gameId')
  String get gameId;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Listings for it in the range.
  @BuiltValueField(wireName: r'listings')
  num get listings;

  GamePopularityDto._();

  factory GamePopularityDto([void updates(GamePopularityDtoBuilder b)]) =
      _$GamePopularityDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GamePopularityDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GamePopularityDto> get serializer =>
      _$GamePopularityDtoSerializer();
}

class _$GamePopularityDtoSerializer
    implements PrimitiveSerializer<GamePopularityDto> {
  @override
  final Iterable<Type> types = const [GamePopularityDto, _$GamePopularityDto];

  @override
  final String wireName = r'GamePopularityDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GamePopularityDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'gameId';
    yield serializers.serialize(
      object.gameId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'listings';
    yield serializers.serialize(
      object.listings,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GamePopularityDto object, {
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
    required GamePopularityDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gameId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.gameId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'listings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.listings = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GamePopularityDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GamePopularityDtoBuilder();
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
