//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profile_stats_dto.g.dart';

/// ProfileStatsDto
///
/// Properties:
/// * [connections]
/// * [games]
/// * [playedWith] - Different people you checked in \"played\" with.
@BuiltValue()
abstract class ProfileStatsDto
    implements Built<ProfileStatsDto, ProfileStatsDtoBuilder> {
  @BuiltValueField(wireName: r'connections')
  num get connections;

  @BuiltValueField(wireName: r'games')
  num get games;

  /// Different people you checked in \"played\" with.
  @BuiltValueField(wireName: r'playedWith')
  num get playedWith;

  ProfileStatsDto._();

  factory ProfileStatsDto([void updates(ProfileStatsDtoBuilder b)]) =
      _$ProfileStatsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileStatsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileStatsDto> get serializer =>
      _$ProfileStatsDtoSerializer();
}

class _$ProfileStatsDtoSerializer
    implements PrimitiveSerializer<ProfileStatsDto> {
  @override
  final Iterable<Type> types = const [ProfileStatsDto, _$ProfileStatsDto];

  @override
  final String wireName = r'ProfileStatsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileStatsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'connections';
    yield serializers.serialize(
      object.connections,
      specifiedType: const FullType(num),
    );
    yield r'games';
    yield serializers.serialize(
      object.games,
      specifiedType: const FullType(num),
    );
    yield r'playedWith';
    yield serializers.serialize(
      object.playedWith,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProfileStatsDto object, {
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
    required ProfileStatsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'connections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.connections = valueDes;
          break;
        case r'games':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.games = valueDes;
          break;
        case r'playedWith':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.playedWith = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProfileStatsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileStatsDtoBuilder();
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
