//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_launch_body.g.dart';

/// SetLaunchBody
///
/// Properties:
/// * [isLaunch] - Launch games are the ones Find Players offers.
@BuiltValue()
abstract class SetLaunchBody
    implements Built<SetLaunchBody, SetLaunchBodyBuilder> {
  /// Launch games are the ones Find Players offers.
  @BuiltValueField(wireName: r'isLaunch')
  bool get isLaunch;

  SetLaunchBody._();

  factory SetLaunchBody([void updates(SetLaunchBodyBuilder b)]) =
      _$SetLaunchBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetLaunchBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetLaunchBody> get serializer =>
      _$SetLaunchBodySerializer();
}

class _$SetLaunchBodySerializer implements PrimitiveSerializer<SetLaunchBody> {
  @override
  final Iterable<Type> types = const [SetLaunchBody, _$SetLaunchBody];

  @override
  final String wireName = r'SetLaunchBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetLaunchBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'isLaunch';
    yield serializers.serialize(
      object.isLaunch,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetLaunchBody object, {
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
    required SetLaunchBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'isLaunch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isLaunch = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetLaunchBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetLaunchBodyBuilder();
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
