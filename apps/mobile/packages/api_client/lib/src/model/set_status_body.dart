//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/day.dart';
import 'package:api_client/src/model/player_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_status_body.g.dart';

/// SetStatusBody
///
/// Properties:
/// * [status] - available_tonight clears at 04:00, playing after 4 hours.
/// * [availableDays] - The MO–SU row. Left as is when absent.
/// * [gameId] - The game for \"Playing …\" or \"Looking …\". Ignored for not_available.
@BuiltValue()
abstract class SetStatusBody
    implements Built<SetStatusBody, SetStatusBodyBuilder> {
  /// available_tonight clears at 04:00, playing after 4 hours.
  @BuiltValueField(wireName: r'status')
  PlayerStatus get status;
  // enum statusEnum {  looking,  playing,  available_tonight,  not_available,  };

  /// The MO–SU row. Left as is when absent.
  @BuiltValueField(wireName: r'availableDays')
  BuiltSet<Day>? get availableDays;

  /// The game for \"Playing …\" or \"Looking …\". Ignored for not_available.
  @BuiltValueField(wireName: r'gameId')
  String? get gameId;

  SetStatusBody._();

  factory SetStatusBody([void updates(SetStatusBodyBuilder b)]) =
      _$SetStatusBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetStatusBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetStatusBody> get serializer =>
      _$SetStatusBodySerializer();
}

class _$SetStatusBodySerializer implements PrimitiveSerializer<SetStatusBody> {
  @override
  final Iterable<Type> types = const [SetStatusBody, _$SetStatusBody];

  @override
  final String wireName = r'SetStatusBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetStatusBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PlayerStatus),
    );
    if (object.availableDays != null) {
      yield r'availableDays';
      yield serializers.serialize(
        object.availableDays,
        specifiedType: const FullType(BuiltSet, [FullType(Day)]),
      );
    }
    if (object.gameId != null) {
      yield r'gameId';
      yield serializers.serialize(
        object.gameId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SetStatusBody object, {
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
    required SetStatusBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlayerStatus),
          ) as PlayerStatus;
          result.status = valueDes;
          break;
        case r'availableDays':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltSet, [FullType(Day)]),
          ) as BuiltSet<Day>?;
          if (valueDes == null) continue;
          result.availableDays.replace(valueDes);
          break;
        case r'gameId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gameId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetStatusBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetStatusBodyBuilder();
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
