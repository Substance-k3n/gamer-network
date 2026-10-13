//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ban_body.g.dart';

/// BanBody
///
/// Properties:
/// * [reason] - Shown to nobody but admins; keep it factual.
@BuiltValue()
abstract class BanBody implements Built<BanBody, BanBodyBuilder> {
  /// Shown to nobody but admins; keep it factual.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  BanBody._();

  factory BanBody([void updates(BanBodyBuilder b)]) = _$BanBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BanBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BanBody> get serializer => _$BanBodySerializer();
}

class _$BanBodySerializer implements PrimitiveSerializer<BanBody> {
  @override
  final Iterable<Type> types = const [BanBody, _$BanBody];

  @override
  final String wireName = r'BanBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BanBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BanBody object, {
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
    required BanBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BanBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BanBodyBuilder();
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
