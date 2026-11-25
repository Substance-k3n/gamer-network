//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_rank_body.g.dart';

/// UpdateRankBody
///
/// Properties:
/// * [name]
/// * [tier]
@BuiltValue()
abstract class UpdateRankBody
    implements Built<UpdateRankBody, UpdateRankBodyBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'tier')
  num? get tier;

  UpdateRankBody._();

  factory UpdateRankBody([void updates(UpdateRankBodyBuilder b)]) =
      _$UpdateRankBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateRankBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateRankBody> get serializer =>
      _$UpdateRankBodySerializer();
}

class _$UpdateRankBodySerializer
    implements PrimitiveSerializer<UpdateRankBody> {
  @override
  final Iterable<Type> types = const [UpdateRankBody, _$UpdateRankBody];

  @override
  final String wireName = r'UpdateRankBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateRankBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.tier != null) {
      yield r'tier';
      yield serializers.serialize(
        object.tier,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateRankBody object, {
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
    required UpdateRankBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.tier = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateRankBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateRankBodyBuilder();
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
