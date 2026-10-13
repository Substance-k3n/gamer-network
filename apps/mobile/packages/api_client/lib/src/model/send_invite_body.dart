//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/invite_when.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'send_invite_body.g.dart';

/// SendInviteBody
///
/// Properties:
/// * [playWhen]
/// * [toUserId] - One of your connections.
/// * [gameId] - Any catalog game.
@BuiltValue()
abstract class SendInviteBody
    implements Built<SendInviteBody, SendInviteBodyBuilder> {
  @BuiltValueField(wireName: r'playWhen')
  InviteWhen get playWhen;
  // enum playWhenEnum {  now,  in_30_min,  tonight,  };

  /// One of your connections.
  @BuiltValueField(wireName: r'toUserId')
  String get toUserId;

  /// Any catalog game.
  @BuiltValueField(wireName: r'gameId')
  String get gameId;

  SendInviteBody._();

  factory SendInviteBody([void updates(SendInviteBodyBuilder b)]) =
      _$SendInviteBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SendInviteBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SendInviteBody> get serializer =>
      _$SendInviteBodySerializer();
}

class _$SendInviteBodySerializer
    implements PrimitiveSerializer<SendInviteBody> {
  @override
  final Iterable<Type> types = const [SendInviteBody, _$SendInviteBody];

  @override
  final String wireName = r'SendInviteBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SendInviteBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'playWhen';
    yield serializers.serialize(
      object.playWhen,
      specifiedType: const FullType(InviteWhen),
    );
    yield r'toUserId';
    yield serializers.serialize(
      object.toUserId,
      specifiedType: const FullType(String),
    );
    yield r'gameId';
    yield serializers.serialize(
      object.gameId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SendInviteBody object, {
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
    required SendInviteBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'playWhen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InviteWhen),
          ) as InviteWhen;
          result.playWhen = valueDes;
          break;
        case r'toUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.toUserId = valueDes;
          break;
        case r'gameId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.gameId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SendInviteBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SendInviteBodyBuilder();
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
