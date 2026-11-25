//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'metrics_day_dto.g.dart';

/// MetricsDayDto
///
/// Properties:
/// * [day] - Addis Ababa date, YYYY-MM-DD.
/// * [signups]
/// * [listings]
/// * [posts]
/// * [played] - \"played\" check-ins answered that day.
@BuiltValue()
abstract class MetricsDayDto
    implements Built<MetricsDayDto, MetricsDayDtoBuilder> {
  /// Addis Ababa date, YYYY-MM-DD.
  @BuiltValueField(wireName: r'day')
  String get day;

  @BuiltValueField(wireName: r'signups')
  num get signups;

  @BuiltValueField(wireName: r'listings')
  num get listings;

  @BuiltValueField(wireName: r'posts')
  num get posts;

  /// \"played\" check-ins answered that day.
  @BuiltValueField(wireName: r'played')
  num get played;

  MetricsDayDto._();

  factory MetricsDayDto([void updates(MetricsDayDtoBuilder b)]) =
      _$MetricsDayDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MetricsDayDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MetricsDayDto> get serializer =>
      _$MetricsDayDtoSerializer();
}

class _$MetricsDayDtoSerializer implements PrimitiveSerializer<MetricsDayDto> {
  @override
  final Iterable<Type> types = const [MetricsDayDto, _$MetricsDayDto];

  @override
  final String wireName = r'MetricsDayDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MetricsDayDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'day';
    yield serializers.serialize(
      object.day,
      specifiedType: const FullType(String),
    );
    yield r'signups';
    yield serializers.serialize(
      object.signups,
      specifiedType: const FullType(num),
    );
    yield r'listings';
    yield serializers.serialize(
      object.listings,
      specifiedType: const FullType(num),
    );
    yield r'posts';
    yield serializers.serialize(
      object.posts,
      specifiedType: const FullType(num),
    );
    yield r'played';
    yield serializers.serialize(
      object.played,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MetricsDayDto object, {
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
    required MetricsDayDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'day':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.day = valueDes;
          break;
        case r'signups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.signups = valueDes;
          break;
        case r'listings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.listings = valueDes;
          break;
        case r'posts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.posts = valueDes;
          break;
        case r'played':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.played = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MetricsDayDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MetricsDayDtoBuilder();
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
