//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'totals_dto.g.dart';

/// TotalsDto
///
/// Properties:
/// * [players] - Live accounts (not banned or deleted).
/// * [banned]
/// * [games] - Games in the catalog players see.
/// * [openReports]
/// * [liveGroups]
@BuiltValue()
abstract class TotalsDto implements Built<TotalsDto, TotalsDtoBuilder> {
  /// Live accounts (not banned or deleted).
  @BuiltValueField(wireName: r'players')
  num get players;

  @BuiltValueField(wireName: r'banned')
  num get banned;

  /// Games in the catalog players see.
  @BuiltValueField(wireName: r'games')
  num get games;

  @BuiltValueField(wireName: r'openReports')
  num get openReports;

  @BuiltValueField(wireName: r'liveGroups')
  num get liveGroups;

  TotalsDto._();

  factory TotalsDto([void updates(TotalsDtoBuilder b)]) = _$TotalsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TotalsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TotalsDto> get serializer => _$TotalsDtoSerializer();
}

class _$TotalsDtoSerializer implements PrimitiveSerializer<TotalsDto> {
  @override
  final Iterable<Type> types = const [TotalsDto, _$TotalsDto];

  @override
  final String wireName = r'TotalsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TotalsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'players';
    yield serializers.serialize(
      object.players,
      specifiedType: const FullType(num),
    );
    yield r'banned';
    yield serializers.serialize(
      object.banned,
      specifiedType: const FullType(num),
    );
    yield r'games';
    yield serializers.serialize(
      object.games,
      specifiedType: const FullType(num),
    );
    yield r'openReports';
    yield serializers.serialize(
      object.openReports,
      specifiedType: const FullType(num),
    );
    yield r'liveGroups';
    yield serializers.serialize(
      object.liveGroups,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TotalsDto object, {
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
    required TotalsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'players':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.players = valueDes;
          break;
        case r'banned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.banned = valueDes;
          break;
        case r'games':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.games = valueDes;
          break;
        case r'openReports':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.openReports = valueDes;
          break;
        case r'liveGroups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.liveGroups = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TotalsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TotalsDtoBuilder();
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
