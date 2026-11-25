//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_rank_body.g.dart';

/// CreateRankBody
///
/// Properties:
/// * [name]
/// * [tier] - Position on the ladder, 0 = lowest. Defaults to the top. A taken tier moves the ranks above it up.
@BuiltValue()
abstract class CreateRankBody
    implements Built<CreateRankBody, CreateRankBodyBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Position on the ladder, 0 = lowest. Defaults to the top. A taken tier moves the ranks above it up.
  @BuiltValueField(wireName: r'tier')
  num? get tier;

  CreateRankBody._();

  factory CreateRankBody([void updates(CreateRankBodyBuilder b)]) =
      _$CreateRankBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateRankBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateRankBody> get serializer =>
      _$CreateRankBodySerializer();
}

class _$CreateRankBodySerializer
    implements PrimitiveSerializer<CreateRankBody> {
  @override
  final Iterable<Type> types = const [CreateRankBody, _$CreateRankBody];

  @override
  final String wireName = r'CreateRankBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateRankBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
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
    CreateRankBody object, {
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
    required CreateRankBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  CreateRankBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateRankBodyBuilder();
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
