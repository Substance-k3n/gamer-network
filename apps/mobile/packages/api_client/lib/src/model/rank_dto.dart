//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rank_dto.g.dart';

/// RankDto
///
/// Properties:
/// * [id]
/// * [name] - e.g. \"Diamond\", \"Div 3\"
/// * [tier] - Position on the ladder, 0 = lowest.
@BuiltValue()
abstract class RankDto implements Built<RankDto, RankDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// e.g. \"Diamond\", \"Div 3\"
  @BuiltValueField(wireName: r'name')
  String get name;

  /// Position on the ladder, 0 = lowest.
  @BuiltValueField(wireName: r'tier')
  num get tier;

  RankDto._();

  factory RankDto([void updates(RankDtoBuilder b)]) = _$RankDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RankDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RankDto> get serializer => _$RankDtoSerializer();
}

class _$RankDtoSerializer implements PrimitiveSerializer<RankDto> {
  @override
  final Iterable<Type> types = const [RankDto, _$RankDto];

  @override
  final String wireName = r'RankDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RankDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RankDto object, {
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
    required RankDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
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
            specifiedType: const FullType(num),
          ) as num;
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
  RankDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RankDtoBuilder();
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
