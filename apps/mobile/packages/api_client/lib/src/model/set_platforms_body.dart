//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/platform.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_platforms_body.g.dart';

/// SetPlatformsBody
///
/// Properties:
/// * [platforms]
@BuiltValue()
abstract class SetPlatformsBody
    implements Built<SetPlatformsBody, SetPlatformsBodyBuilder> {
  @BuiltValueField(wireName: r'platforms')
  BuiltSet<Platform> get platforms;

  SetPlatformsBody._();

  factory SetPlatformsBody([void updates(SetPlatformsBodyBuilder b)]) =
      _$SetPlatformsBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetPlatformsBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetPlatformsBody> get serializer =>
      _$SetPlatformsBodySerializer();
}

class _$SetPlatformsBodySerializer
    implements PrimitiveSerializer<SetPlatformsBody> {
  @override
  final Iterable<Type> types = const [SetPlatformsBody, _$SetPlatformsBody];

  @override
  final String wireName = r'SetPlatformsBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetPlatformsBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'platforms';
    yield serializers.serialize(
      object.platforms,
      specifiedType: const FullType(BuiltSet, [FullType(Platform)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetPlatformsBody object, {
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
    required SetPlatformsBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'platforms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(Platform)]),
          ) as BuiltSet<Platform>;
          result.platforms.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetPlatformsBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetPlatformsBodyBuilder();
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
