//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_stats_dto.g.dart';

/// ListingStatsDto
///
/// Properties:
/// * [lookingNow] - Distinct people in your city with an open listing or a \"looking\" status.
@BuiltValue()
abstract class ListingStatsDto
    implements Built<ListingStatsDto, ListingStatsDtoBuilder> {
  /// Distinct people in your city with an open listing or a \"looking\" status.
  @BuiltValueField(wireName: r'lookingNow')
  num get lookingNow;

  ListingStatsDto._();

  factory ListingStatsDto([void updates(ListingStatsDtoBuilder b)]) =
      _$ListingStatsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingStatsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingStatsDto> get serializer =>
      _$ListingStatsDtoSerializer();
}

class _$ListingStatsDtoSerializer
    implements PrimitiveSerializer<ListingStatsDto> {
  @override
  final Iterable<Type> types = const [ListingStatsDto, _$ListingStatsDto];

  @override
  final String wireName = r'ListingStatsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingStatsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lookingNow';
    yield serializers.serialize(
      object.lookingNow,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingStatsDto object, {
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
    required ListingStatsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lookingNow':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lookingNow = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingStatsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingStatsDtoBuilder();
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
