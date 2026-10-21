//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_group_event_body.g.dart';

/// CreateGroupEventBody
///
/// Properties:
/// * [title] - 1–80 characters, trimmed.
/// * [startsAt] - Within the next 60 days.
/// * [gameId] - One of GET /v1/games, or left out.
@BuiltValue()
abstract class CreateGroupEventBody
    implements Built<CreateGroupEventBody, CreateGroupEventBodyBuilder> {
  /// 1–80 characters, trimmed.
  @BuiltValueField(wireName: r'title')
  String get title;

  /// Within the next 60 days.
  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  /// One of GET /v1/games, or left out.
  @BuiltValueField(wireName: r'gameId')
  String? get gameId;

  CreateGroupEventBody._();

  factory CreateGroupEventBody([void updates(CreateGroupEventBodyBuilder b)]) =
      _$CreateGroupEventBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateGroupEventBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateGroupEventBody> get serializer =>
      _$CreateGroupEventBodySerializer();
}

class _$CreateGroupEventBodySerializer
    implements PrimitiveSerializer<CreateGroupEventBody> {
  @override
  final Iterable<Type> types = const [
    CreateGroupEventBody,
    _$CreateGroupEventBody
  ];

  @override
  final String wireName = r'CreateGroupEventBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateGroupEventBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.gameId != null) {
      yield r'gameId';
      yield serializers.serialize(
        object.gameId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateGroupEventBody object, {
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
    required CreateGroupEventBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'gameId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  CreateGroupEventBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateGroupEventBodyBuilder();
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
