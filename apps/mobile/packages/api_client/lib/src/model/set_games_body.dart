//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/user_game_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_games_body.g.dart';

/// SetGamesBody
///
/// Properties:
/// * [games] - The full list, in profile order. Replaces what was there.
@BuiltValue()
abstract class SetGamesBody
    implements Built<SetGamesBody, SetGamesBodyBuilder> {
  /// The full list, in profile order. Replaces what was there.
  @BuiltValueField(wireName: r'games')
  BuiltList<UserGameInput> get games;

  SetGamesBody._();

  factory SetGamesBody([void updates(SetGamesBodyBuilder b)]) = _$SetGamesBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetGamesBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetGamesBody> get serializer => _$SetGamesBodySerializer();
}

class _$SetGamesBodySerializer implements PrimitiveSerializer<SetGamesBody> {
  @override
  final Iterable<Type> types = const [SetGamesBody, _$SetGamesBody];

  @override
  final String wireName = r'SetGamesBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetGamesBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'games';
    yield serializers.serialize(
      object.games,
      specifiedType: const FullType(BuiltList, [FullType(UserGameInput)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetGamesBody object, {
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
    required SetGamesBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'games':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UserGameInput)]),
          ) as BuiltList<UserGameInput>;
          result.games.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetGamesBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetGamesBodyBuilder();
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
