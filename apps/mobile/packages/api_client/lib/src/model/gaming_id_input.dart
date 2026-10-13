//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/gaming_id_kind.dart';
import 'package:api_client/src/model/id_visibility.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gaming_id_input.g.dart';

/// GamingIdInput
///
/// Properties:
/// * [kind]
/// * [visibility] - Defaults to connections.
/// * [gameId] - Required for in_game (e.g. a PUBG Mobile UID), absent otherwise.
/// * [value]
@BuiltValue()
abstract class GamingIdInput
    implements Built<GamingIdInput, GamingIdInputBuilder> {
  @BuiltValueField(wireName: r'kind')
  GamingIdKind get kind;
  // enum kindEnum {  riot,  steam,  discord,  playstation,  xbox,  epic,  ea,  activision,  in_game,  };

  /// Defaults to connections.
  @BuiltValueField(wireName: r'visibility')
  IdVisibility? get visibility;
  // enum visibilityEnum {  public,  connections,  };

  /// Required for in_game (e.g. a PUBG Mobile UID), absent otherwise.
  @BuiltValueField(wireName: r'gameId')
  String? get gameId;

  @BuiltValueField(wireName: r'value')
  String get value;

  GamingIdInput._();

  factory GamingIdInput([void updates(GamingIdInputBuilder b)]) =
      _$GamingIdInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GamingIdInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GamingIdInput> get serializer =>
      _$GamingIdInputSerializer();
}

class _$GamingIdInputSerializer implements PrimitiveSerializer<GamingIdInput> {
  @override
  final Iterable<Type> types = const [GamingIdInput, _$GamingIdInput];

  @override
  final String wireName = r'GamingIdInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GamingIdInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(GamingIdKind),
    );
    if (object.visibility != null) {
      yield r'visibility';
      yield serializers.serialize(
        object.visibility,
        specifiedType: const FullType(IdVisibility),
      );
    }
    if (object.gameId != null) {
      yield r'gameId';
      yield serializers.serialize(
        object.gameId,
        specifiedType: const FullType(String),
      );
    }
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GamingIdInput object, {
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
    required GamingIdInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GamingIdKind),
          ) as GamingIdKind;
          result.kind = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(IdVisibility),
          ) as IdVisibility?;
          if (valueDes == null) continue;
          result.visibility = valueDes;
          break;
        case r'gameId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gameId = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GamingIdInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GamingIdInputBuilder();
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
