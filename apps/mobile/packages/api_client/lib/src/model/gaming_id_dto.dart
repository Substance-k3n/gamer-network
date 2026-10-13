//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:api_client/src/model/gaming_id_kind.dart';
import 'package:api_client/src/model/id_visibility.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'gaming_id_dto.g.dart';

/// GamingIdDto
///
/// Properties:
/// * [kind]
/// * [visibility]
/// * [id]
/// * [game] - Set when kind is in_game.
/// * [value]
@BuiltValue()
abstract class GamingIdDto implements Built<GamingIdDto, GamingIdDtoBuilder> {
  @BuiltValueField(wireName: r'kind')
  GamingIdKind get kind;
  // enum kindEnum {  riot,  steam,  discord,  playstation,  xbox,  epic,  ea,  activision,  in_game,  };

  @BuiltValueField(wireName: r'visibility')
  IdVisibility get visibility;
  // enum visibilityEnum {  public,  connections,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  /// Set when kind is in_game.
  @BuiltValueField(wireName: r'game')
  GameRefDto? get game;

  @BuiltValueField(wireName: r'value')
  String get value;

  GamingIdDto._();

  factory GamingIdDto([void updates(GamingIdDtoBuilder b)]) = _$GamingIdDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GamingIdDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GamingIdDto> get serializer => _$GamingIdDtoSerializer();
}

class _$GamingIdDtoSerializer implements PrimitiveSerializer<GamingIdDto> {
  @override
  final Iterable<Type> types = const [GamingIdDto, _$GamingIdDto];

  @override
  final String wireName = r'GamingIdDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GamingIdDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(GamingIdKind),
    );
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(IdVisibility),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'game';
    yield object.game == null
        ? null
        : serializers.serialize(
            object.game,
            specifiedType: const FullType.nullable(GameRefDto),
          );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GamingIdDto object, {
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
    required GamingIdDtoBuilder result,
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
            specifiedType: const FullType(IdVisibility),
          ) as IdVisibility;
          result.visibility = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'game':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GameRefDto),
          ) as GameRefDto?;
          if (valueDes == null) continue;
          result.game.replace(valueDes);
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
  GamingIdDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GamingIdDtoBuilder();
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
