//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_game_input.g.dart';

/// UserGameInput
///
/// Properties:
/// * [gameId]
/// * [customGameName]
/// * [rankId] - A rank of this game, from GET /v1/games. Catalog games only.
/// * [rankText] - Free-text level. Custom games only.
/// * [roleId] - A role of this game. Catalog games only.
@BuiltValue()
abstract class UserGameInput
    implements Built<UserGameInput, UserGameInputBuilder> {
  @BuiltValueField(wireName: r'gameId')
  String? get gameId;

  @BuiltValueField(wireName: r'customGameName')
  String? get customGameName;

  /// A rank of this game, from GET /v1/games. Catalog games only.
  @BuiltValueField(wireName: r'rankId')
  String? get rankId;

  /// Free-text level. Custom games only.
  @BuiltValueField(wireName: r'rankText')
  String? get rankText;

  /// A role of this game. Catalog games only.
  @BuiltValueField(wireName: r'roleId')
  String? get roleId;

  UserGameInput._();

  factory UserGameInput([void updates(UserGameInputBuilder b)]) =
      _$UserGameInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserGameInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserGameInput> get serializer =>
      _$UserGameInputSerializer();
}

class _$UserGameInputSerializer implements PrimitiveSerializer<UserGameInput> {
  @override
  final Iterable<Type> types = const [UserGameInput, _$UserGameInput];

  @override
  final String wireName = r'UserGameInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserGameInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.gameId != null) {
      yield r'gameId';
      yield serializers.serialize(
        object.gameId,
        specifiedType: const FullType(String),
      );
    }
    if (object.customGameName != null) {
      yield r'customGameName';
      yield serializers.serialize(
        object.customGameName,
        specifiedType: const FullType(String),
      );
    }
    if (object.rankId != null) {
      yield r'rankId';
      yield serializers.serialize(
        object.rankId,
        specifiedType: const FullType(String),
      );
    }
    if (object.rankText != null) {
      yield r'rankText';
      yield serializers.serialize(
        object.rankText,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.roleId != null) {
      yield r'roleId';
      yield serializers.serialize(
        object.roleId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserGameInput object, {
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
    required UserGameInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'gameId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gameId = valueDes;
          break;
        case r'customGameName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customGameName = valueDes;
          break;
        case r'rankId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rankId = valueDes;
          break;
        case r'rankText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rankText = valueDes;
          break;
        case r'roleId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.roleId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserGameInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserGameInputBuilder();
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
