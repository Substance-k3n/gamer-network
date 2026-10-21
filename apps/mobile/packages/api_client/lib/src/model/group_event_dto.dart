//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_event_dto.g.dart';

/// GroupEventDto
///
/// Properties:
/// * [id]
/// * [groupId]
/// * [title] - 1–80 characters.
/// * [startsAt]
/// * [game]
/// * [goingCount] - People going, leaving out anyone no longer live.
/// * [goingPreview] - Up to 3 of them, for the avatars.
/// * [imGoing]
/// * [createdBy] - Its creator or a group admin can delete it.
@BuiltValue()
abstract class GroupEventDto
    implements Built<GroupEventDto, GroupEventDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'groupId')
  String get groupId;

  /// 1–80 characters.
  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'game')
  GameRefDto? get game;

  /// People going, leaving out anyone no longer live.
  @BuiltValueField(wireName: r'goingCount')
  num get goingCount;

  /// Up to 3 of them, for the avatars.
  @BuiltValueField(wireName: r'goingPreview')
  BuiltList<UserCardDto> get goingPreview;

  @BuiltValueField(wireName: r'imGoing')
  bool get imGoing;

  /// Its creator or a group admin can delete it.
  @BuiltValueField(wireName: r'createdBy')
  UserCardDto get createdBy;

  GroupEventDto._();

  factory GroupEventDto([void updates(GroupEventDtoBuilder b)]) =
      _$GroupEventDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupEventDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupEventDto> get serializer =>
      _$GroupEventDtoSerializer();
}

class _$GroupEventDtoSerializer implements PrimitiveSerializer<GroupEventDto> {
  @override
  final Iterable<Type> types = const [GroupEventDto, _$GroupEventDto];

  @override
  final String wireName = r'GroupEventDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupEventDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'groupId';
    yield serializers.serialize(
      object.groupId,
      specifiedType: const FullType(String),
    );
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
    yield r'game';
    yield object.game == null
        ? null
        : serializers.serialize(
            object.game,
            specifiedType: const FullType.nullable(GameRefDto),
          );
    yield r'goingCount';
    yield serializers.serialize(
      object.goingCount,
      specifiedType: const FullType(num),
    );
    yield r'goingPreview';
    yield serializers.serialize(
      object.goingPreview,
      specifiedType: const FullType(BuiltList, [FullType(UserCardDto)]),
    );
    yield r'imGoing';
    yield serializers.serialize(
      object.imGoing,
      specifiedType: const FullType(bool),
    );
    yield r'createdBy';
    yield serializers.serialize(
      object.createdBy,
      specifiedType: const FullType(UserCardDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupEventDto object, {
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
    required GroupEventDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'groupId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.groupId = valueDes;
          break;
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
        case r'game':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GameRefDto),
          ) as GameRefDto?;
          if (valueDes == null) continue;
          result.game.replace(valueDes);
          break;
        case r'goingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.goingCount = valueDes;
          break;
        case r'goingPreview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UserCardDto)]),
          ) as BuiltList<UserCardDto>;
          result.goingPreview.replace(valueDes);
          break;
        case r'imGoing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.imGoing = valueDes;
          break;
        case r'createdBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserCardDto),
          ) as UserCardDto;
          result.createdBy.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GroupEventDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupEventDtoBuilder();
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
