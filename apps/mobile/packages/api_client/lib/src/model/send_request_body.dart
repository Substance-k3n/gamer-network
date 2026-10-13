//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'send_request_body.g.dart';

/// SendRequestBody
///
/// Properties:
/// * [toUserId]
/// * [listingId] - When sent from a listing card: one of their live listings.
/// * [message]
@BuiltValue()
abstract class SendRequestBody
    implements Built<SendRequestBody, SendRequestBodyBuilder> {
  @BuiltValueField(wireName: r'toUserId')
  String get toUserId;

  /// When sent from a listing card: one of their live listings.
  @BuiltValueField(wireName: r'listingId')
  String? get listingId;

  @BuiltValueField(wireName: r'message')
  String? get message;

  SendRequestBody._();

  factory SendRequestBody([void updates(SendRequestBodyBuilder b)]) =
      _$SendRequestBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SendRequestBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SendRequestBody> get serializer =>
      _$SendRequestBodySerializer();
}

class _$SendRequestBodySerializer
    implements PrimitiveSerializer<SendRequestBody> {
  @override
  final Iterable<Type> types = const [SendRequestBody, _$SendRequestBody];

  @override
  final String wireName = r'SendRequestBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SendRequestBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'toUserId';
    yield serializers.serialize(
      object.toUserId,
      specifiedType: const FullType(String),
    );
    if (object.listingId != null) {
      yield r'listingId';
      yield serializers.serialize(
        object.listingId,
        specifiedType: const FullType(String),
      );
    }
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SendRequestBody object, {
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
    required SendRequestBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'toUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.toUserId = valueDes;
          break;
        case r'listingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.listingId = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SendRequestBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SendRequestBodyBuilder();
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
