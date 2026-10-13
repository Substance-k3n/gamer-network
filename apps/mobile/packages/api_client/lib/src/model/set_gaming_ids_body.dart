//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/gaming_id_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_gaming_ids_body.g.dart';

/// SetGamingIdsBody
///
/// Properties:
/// * [gamingIds] - The full list. Replaces what was there.
@BuiltValue()
abstract class SetGamingIdsBody
    implements Built<SetGamingIdsBody, SetGamingIdsBodyBuilder> {
  /// The full list. Replaces what was there.
  @BuiltValueField(wireName: r'gamingIds')
  BuiltList<GamingIdInput> get gamingIds;

  SetGamingIdsBody._();

  factory SetGamingIdsBody([void updates(SetGamingIdsBodyBuilder b)]) =
      _$SetGamingIdsBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetGamingIdsBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetGamingIdsBody> get serializer =>
      _$SetGamingIdsBodySerializer();
}

class _$SetGamingIdsBodySerializer
    implements PrimitiveSerializer<SetGamingIdsBody> {
  @override
  final Iterable<Type> types = const [SetGamingIdsBody, _$SetGamingIdsBody];

  @override
  final String wireName = r'SetGamingIdsBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetGamingIdsBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'gamingIds';
    yield serializers.serialize(
      object.gamingIds,
      specifiedType: const FullType(BuiltList, [FullType(GamingIdInput)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetGamingIdsBody object, {
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
    required SetGamingIdsBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gamingIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GamingIdInput)]),
          ) as BuiltList<GamingIdInput>;
          result.gamingIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetGamingIdsBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetGamingIdsBodyBuilder();
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
