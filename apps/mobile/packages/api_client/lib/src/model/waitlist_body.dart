//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'waitlist_body.g.dart';

/// WaitlistBody
///
/// Properties:
/// * [topic] - \"groups\" for the Groups \"Notify me\" button.
@BuiltValue()
abstract class WaitlistBody
    implements Built<WaitlistBody, WaitlistBodyBuilder> {
  /// \"groups\" for the Groups \"Notify me\" button.
  @BuiltValueField(wireName: r'topic')
  String get topic;

  WaitlistBody._();

  factory WaitlistBody([void updates(WaitlistBodyBuilder b)]) = _$WaitlistBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WaitlistBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WaitlistBody> get serializer => _$WaitlistBodySerializer();
}

class _$WaitlistBodySerializer implements PrimitiveSerializer<WaitlistBody> {
  @override
  final Iterable<Type> types = const [WaitlistBody, _$WaitlistBody];

  @override
  final String wireName = r'WaitlistBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WaitlistBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'topic';
    yield serializers.serialize(
      object.topic,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WaitlistBody object, {
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
    required WaitlistBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'topic':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.topic = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WaitlistBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WaitlistBodyBuilder();
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
