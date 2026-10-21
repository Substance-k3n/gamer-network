//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:api_client/src/model/membership_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/group_tone.dart';
import 'package:api_client/src/model/game_ref_dto.dart';
import 'package:api_client/src/model/group_role.dart';
import 'package:api_client/src/model/group_event_dto.dart';
import 'package:api_client/src/model/group_kind.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_dto.g.dart';

/// GroupDto
///
/// Properties:
/// * [kind]
/// * [tone]
/// * [myRole] - Null when you aren't a member (or are still pending).
/// * [myStatus] - pending: you asked to join and wait for an admin. Null: not in it.
/// * [id]
/// * [name]
/// * [short] - The badge, e.g. \"VAL\": 2–5 uppercase letters or digits.
/// * [game] - Set on game groups; may be set on others.
/// * [place] - City, campus or country.
/// * [about]
/// * [rules] - Up to 10, up to 140 characters each.
/// * [approval] - New members wait for an admin.
/// * [memberCount]
/// * [membersPreview] - Up to 3 members, your connections first.
/// * [nextEvent] - The soonest upcoming event, or null.
/// * [createdAt] - \"since Mar 2025\".
@BuiltValue()
abstract class GroupDto implements Built<GroupDto, GroupDtoBuilder> {
  @BuiltValueField(wireName: r'kind')
  GroupKind get kind;
  // enum kindEnum {  game,  city,  campus,  squad,  };

  @BuiltValueField(wireName: r'tone')
  GroupTone get tone;
  // enum toneEnum {  accent,  lav,  soft,  grey,  };

  /// Null when you aren't a member (or are still pending).
  @BuiltValueField(wireName: r'myRole')
  GroupRole? get myRole;
  // enum myRoleEnum {  admin,  member,  };

  /// pending: you asked to join and wait for an admin. Null: not in it.
  @BuiltValueField(wireName: r'myStatus')
  MembershipStatus? get myStatus;
  // enum myStatusEnum {  member,  pending,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// The badge, e.g. \"VAL\": 2–5 uppercase letters or digits.
  @BuiltValueField(wireName: r'short')
  String get short;

  /// Set on game groups; may be set on others.
  @BuiltValueField(wireName: r'game')
  GameRefDto? get game;

  /// City, campus or country.
  @BuiltValueField(wireName: r'place')
  String get place;

  @BuiltValueField(wireName: r'about')
  String get about;

  /// Up to 10, up to 140 characters each.
  @BuiltValueField(wireName: r'rules')
  BuiltList<String> get rules;

  /// New members wait for an admin.
  @BuiltValueField(wireName: r'approval')
  bool get approval;

  @BuiltValueField(wireName: r'memberCount')
  num get memberCount;

  /// Up to 3 members, your connections first.
  @BuiltValueField(wireName: r'membersPreview')
  BuiltList<UserCardDto> get membersPreview;

  /// The soonest upcoming event, or null.
  @BuiltValueField(wireName: r'nextEvent')
  GroupEventDto? get nextEvent;

  /// \"since Mar 2025\".
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  GroupDto._();

  factory GroupDto([void updates(GroupDtoBuilder b)]) = _$GroupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupDto> get serializer => _$GroupDtoSerializer();
}

class _$GroupDtoSerializer implements PrimitiveSerializer<GroupDto> {
  @override
  final Iterable<Type> types = const [GroupDto, _$GroupDto];

  @override
  final String wireName = r'GroupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(GroupKind),
    );
    yield r'tone';
    yield serializers.serialize(
      object.tone,
      specifiedType: const FullType(GroupTone),
    );
    yield r'myRole';
    yield object.myRole == null
        ? null
        : serializers.serialize(
            object.myRole,
            specifiedType: const FullType.nullable(GroupRole),
          );
    yield r'myStatus';
    yield object.myStatus == null
        ? null
        : serializers.serialize(
            object.myStatus,
            specifiedType: const FullType.nullable(MembershipStatus),
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
    yield r'short';
    yield serializers.serialize(
      object.short,
      specifiedType: const FullType(String),
    );
    yield r'game';
    yield object.game == null
        ? null
        : serializers.serialize(
            object.game,
            specifiedType: const FullType.nullable(GameRefDto),
          );
    yield r'place';
    yield serializers.serialize(
      object.place,
      specifiedType: const FullType(String),
    );
    yield r'about';
    yield serializers.serialize(
      object.about,
      specifiedType: const FullType(String),
    );
    yield r'rules';
    yield serializers.serialize(
      object.rules,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'approval';
    yield serializers.serialize(
      object.approval,
      specifiedType: const FullType(bool),
    );
    yield r'memberCount';
    yield serializers.serialize(
      object.memberCount,
      specifiedType: const FullType(num),
    );
    yield r'membersPreview';
    yield serializers.serialize(
      object.membersPreview,
      specifiedType: const FullType(BuiltList, [FullType(UserCardDto)]),
    );
    yield r'nextEvent';
    yield object.nextEvent == null
        ? null
        : serializers.serialize(
            object.nextEvent,
            specifiedType: const FullType.nullable(GroupEventDto),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupDto object, {
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
    required GroupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GroupKind),
          ) as GroupKind;
          result.kind = valueDes;
          break;
        case r'tone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GroupTone),
          ) as GroupTone;
          result.tone = valueDes;
          break;
        case r'myRole':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GroupRole),
          ) as GroupRole?;
          if (valueDes == null) continue;
          result.myRole = valueDes;
          break;
        case r'myStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MembershipStatus),
          ) as MembershipStatus?;
          if (valueDes == null) continue;
          result.myStatus = valueDes;
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
        case r'short':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.short = valueDes;
          break;
        case r'game':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GameRefDto),
          ) as GameRefDto?;
          if (valueDes == null) continue;
          result.game.replace(valueDes);
          break;
        case r'place':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.place = valueDes;
          break;
        case r'about':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.about = valueDes;
          break;
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.rules.replace(valueDes);
          break;
        case r'approval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.approval = valueDes;
          break;
        case r'memberCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.memberCount = valueDes;
          break;
        case r'membersPreview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UserCardDto)]),
          ) as BuiltList<UserCardDto>;
          result.membersPreview.replace(valueDes);
          break;
        case r'nextEvent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GroupEventDto),
          ) as GroupEventDto?;
          if (valueDes == null) continue;
          result.nextEvent.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GroupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupDtoBuilder();
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
