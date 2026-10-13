//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mode_dto.g.dart';

/// ModeDto
///
/// Properties:
/// * [id]
/// * [name] - Ranked, Unrated or Casual
/// * [isRanked]
@BuiltValue()
abstract class ModeDto implements Built<ModeDto, ModeDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Ranked, Unrated or Casual
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'isRanked')
  bool get isRanked;

  ModeDto._();

  factory ModeDto([void updates(ModeDtoBuilder b)]) = _$ModeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ModeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ModeDto> get serializer => _$ModeDtoSerializer();
}

class _$ModeDtoSerializer implements PrimitiveSerializer<ModeDto> {
  @override
  final Iterable<Type> types = const [ModeDto, _$ModeDto];

  @override
  final String wireName = r'ModeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ModeDto object, {
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
    yield r'isRanked';
    yield serializers.serialize(
      object.isRanked,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ModeDto object, {
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
    required ModeDtoBuilder result,
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
        case r'isRanked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isRanked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ModeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ModeDtoBuilder();
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
