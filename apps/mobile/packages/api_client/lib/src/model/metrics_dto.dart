//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'metrics_dto.g.dart';

/// MetricsDto
///
/// Properties:
/// * [from]
/// * [to]
/// * [listings]
/// * [listingsWithRequest] - Got at least one connection request.
/// * [listingsPlayed] - At least one \"played\" check-in points at them.
/// * [playedRate] - listingsPlayed / listings: the number that decides the MVP.
/// * [weeklyActive] - People active in the 7 days before `to`.
@BuiltValue()
abstract class MetricsDto implements Built<MetricsDto, MetricsDtoBuilder> {
  @BuiltValueField(wireName: r'from')
  DateTime get from;

  @BuiltValueField(wireName: r'to')
  DateTime get to;

  @BuiltValueField(wireName: r'listings')
  num get listings;

  /// Got at least one connection request.
  @BuiltValueField(wireName: r'listingsWithRequest')
  num get listingsWithRequest;

  /// At least one \"played\" check-in points at them.
  @BuiltValueField(wireName: r'listingsPlayed')
  num get listingsPlayed;

  /// listingsPlayed / listings: the number that decides the MVP.
  @BuiltValueField(wireName: r'playedRate')
  num get playedRate;

  /// People active in the 7 days before `to`.
  @BuiltValueField(wireName: r'weeklyActive')
  num get weeklyActive;

  MetricsDto._();

  factory MetricsDto([void updates(MetricsDtoBuilder b)]) = _$MetricsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MetricsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MetricsDto> get serializer => _$MetricsDtoSerializer();
}

class _$MetricsDtoSerializer implements PrimitiveSerializer<MetricsDto> {
  @override
  final Iterable<Type> types = const [MetricsDto, _$MetricsDto];

  @override
  final String wireName = r'MetricsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MetricsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(DateTime),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(DateTime),
    );
    yield r'listings';
    yield serializers.serialize(
      object.listings,
      specifiedType: const FullType(num),
    );
    yield r'listingsWithRequest';
    yield serializers.serialize(
      object.listingsWithRequest,
      specifiedType: const FullType(num),
    );
    yield r'listingsPlayed';
    yield serializers.serialize(
      object.listingsPlayed,
      specifiedType: const FullType(num),
    );
    yield r'playedRate';
    yield serializers.serialize(
      object.playedRate,
      specifiedType: const FullType(num),
    );
    yield r'weeklyActive';
    yield serializers.serialize(
      object.weeklyActive,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MetricsDto object, {
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
    required MetricsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.to = valueDes;
          break;
        case r'listings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.listings = valueDes;
          break;
        case r'listingsWithRequest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.listingsWithRequest = valueDes;
          break;
        case r'listingsPlayed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.listingsPlayed = valueDes;
          break;
        case r'playedRate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.playedRate = valueDes;
          break;
        case r'weeklyActive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.weeklyActive = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MetricsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MetricsDtoBuilder();
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
