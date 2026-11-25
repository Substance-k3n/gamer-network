//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/platform.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_game_body.g.dart';

/// UpdateGameBody
///
/// Properties:
/// * [platforms]
/// * [name]
/// * [shortCode]
/// * [hasRanks]
/// * [maxParty]
/// * [isLaunch] - On Find Players.
/// * [sort]
@BuiltValue()
abstract class UpdateGameBody
    implements Built<UpdateGameBody, UpdateGameBodyBuilder> {
  @BuiltValueField(wireName: r'platforms')
  BuiltList<Platform>? get platforms;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'shortCode')
  String? get shortCode;

  @BuiltValueField(wireName: r'hasRanks')
  bool? get hasRanks;

  @BuiltValueField(wireName: r'maxParty')
  num? get maxParty;

  /// On Find Players.
  @BuiltValueField(wireName: r'isLaunch')
  bool? get isLaunch;

  @BuiltValueField(wireName: r'sort')
  num? get sort;

  UpdateGameBody._();

  factory UpdateGameBody([void updates(UpdateGameBodyBuilder b)]) =
      _$UpdateGameBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateGameBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateGameBody> get serializer =>
      _$UpdateGameBodySerializer();
}

class _$UpdateGameBodySerializer
    implements PrimitiveSerializer<UpdateGameBody> {
  @override
  final Iterable<Type> types = const [UpdateGameBody, _$UpdateGameBody];

  @override
  final String wireName = r'UpdateGameBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateGameBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.platforms != null) {
      yield r'platforms';
      yield serializers.serialize(
        object.platforms,
        specifiedType: const FullType(BuiltList, [FullType(Platform)]),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.shortCode != null) {
      yield r'shortCode';
      yield serializers.serialize(
        object.shortCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.hasRanks != null) {
      yield r'hasRanks';
      yield serializers.serialize(
        object.hasRanks,
        specifiedType: const FullType(bool),
      );
    }
    if (object.maxParty != null) {
      yield r'maxParty';
      yield serializers.serialize(
        object.maxParty,
        specifiedType: const FullType(num),
      );
    }
    if (object.isLaunch != null) {
      yield r'isLaunch';
      yield serializers.serialize(
        object.isLaunch,
        specifiedType: const FullType(bool),
      );
    }
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
    UpdateGameBody object, {
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
    required UpdateGameBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'platforms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(Platform)]),
          ) as BuiltList<Platform>?;
          if (valueDes == null) continue;
          result.platforms.replace(valueDes);
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'shortCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.shortCode = valueDes;
          break;
        case r'hasRanks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.hasRanks = valueDes;
          break;
        case r'maxParty':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.maxParty = valueDes;
          break;
        case r'isLaunch':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
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
  UpdateGameBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateGameBodyBuilder();
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
