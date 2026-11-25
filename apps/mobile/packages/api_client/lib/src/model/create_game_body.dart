//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/platform.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_game_body.g.dart';

/// CreateGameBody
///
/// Properties:
/// * [platforms]
/// * [id] - The id apps and links use, e.g. \"val\": 2–20 lowercase letters or digits. Can't change later.
/// * [name]
/// * [shortCode] - Tile label, e.g. \"VAL\".
/// * [hasRanks] - False when the ladder is play-style levels rather than ranks.
/// * [maxParty] - Largest party a listing can ask for, 2–10.
/// * [isLaunch] - On Find Players.
/// * [sort] - Catalog order, lowest first.
@BuiltValue()
abstract class CreateGameBody
    implements Built<CreateGameBody, CreateGameBodyBuilder> {
  @BuiltValueField(wireName: r'platforms')
  BuiltList<Platform> get platforms;

  /// The id apps and links use, e.g. \"val\": 2–20 lowercase letters or digits. Can't change later.
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Tile label, e.g. \"VAL\".
  @BuiltValueField(wireName: r'shortCode')
  String get shortCode;

  /// False when the ladder is play-style levels rather than ranks.
  @BuiltValueField(wireName: r'hasRanks')
  bool get hasRanks;

  /// Largest party a listing can ask for, 2–10.
  @BuiltValueField(wireName: r'maxParty')
  num get maxParty;

  /// On Find Players.
  @BuiltValueField(wireName: r'isLaunch')
  bool get isLaunch;

  /// Catalog order, lowest first.
  @BuiltValueField(wireName: r'sort')
  num? get sort;

  CreateGameBody._();

  factory CreateGameBody([void updates(CreateGameBodyBuilder b)]) =
      _$CreateGameBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateGameBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateGameBody> get serializer =>
      _$CreateGameBodySerializer();
}

class _$CreateGameBodySerializer
    implements PrimitiveSerializer<CreateGameBody> {
  @override
  final Iterable<Type> types = const [CreateGameBody, _$CreateGameBody];

  @override
  final String wireName = r'CreateGameBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateGameBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'platforms';
    yield serializers.serialize(
      object.platforms,
      specifiedType: const FullType(BuiltList, [FullType(Platform)]),
    );
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
    yield r'shortCode';
    yield serializers.serialize(
      object.shortCode,
      specifiedType: const FullType(String),
    );
    yield r'hasRanks';
    yield serializers.serialize(
      object.hasRanks,
      specifiedType: const FullType(bool),
    );
    yield r'maxParty';
    yield serializers.serialize(
      object.maxParty,
      specifiedType: const FullType(num),
    );
    yield r'isLaunch';
    yield serializers.serialize(
      object.isLaunch,
      specifiedType: const FullType(bool),
    );
    if (object.sort != null) {
      yield r'sort';
      yield serializers.serialize(
        object.sort,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateGameBody object, {
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
    required CreateGameBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'platforms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Platform)]),
          ) as BuiltList<Platform>;
          result.platforms.replace(valueDes);
          break;
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
        case r'shortCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.shortCode = valueDes;
          break;
        case r'hasRanks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasRanks = valueDes;
          break;
        case r'maxParty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.maxParty = valueDes;
          break;
        case r'isLaunch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isLaunch = valueDes;
          break;
        case r'sort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.sort = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateGameBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateGameBodyBuilder();
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
