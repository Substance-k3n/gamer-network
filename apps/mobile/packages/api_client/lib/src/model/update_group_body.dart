//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/group_tone.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_group_body.g.dart';

/// UpdateGroupBody
///
/// Properties:
/// * [tone]
/// * [name] - 3–40 characters, trimmed. Unique, ignoring case (409 group_name_taken).
/// * [short] - The badge: 2–5 letters or digits, stored uppercase. Left out: made from the name.
/// * [gameId] - One of GET /v1/games. Required on game groups.
/// * [place] - City, campus or country: 1–60 characters, trimmed.
/// * [about] - Up to 500 characters, trimmed.
/// * [rules] - Up to 10 rules, 1–140 characters each, trimmed.
/// * [approval] - New members wait for an admin. Default false.
@BuiltValue()
abstract class UpdateGroupBody
    implements Built<UpdateGroupBody, UpdateGroupBodyBuilder> {
  @BuiltValueField(wireName: r'tone')
  GroupTone? get tone;
  // enum toneEnum {  accent,  lav,  soft,  grey,  };

  /// 3–40 characters, trimmed. Unique, ignoring case (409 group_name_taken).
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// The badge: 2–5 letters or digits, stored uppercase. Left out: made from the name.
  @BuiltValueField(wireName: r'short')
  String? get short;

  /// One of GET /v1/games. Required on game groups.
  @BuiltValueField(wireName: r'gameId')
  String? get gameId;

  /// City, campus or country: 1–60 characters, trimmed.
  @BuiltValueField(wireName: r'place')
  String? get place;

  /// Up to 500 characters, trimmed.
  @BuiltValueField(wireName: r'about')
  String? get about;

  /// Up to 10 rules, 1–140 characters each, trimmed.
  @BuiltValueField(wireName: r'rules')
  BuiltList<String>? get rules;

  /// New members wait for an admin. Default false.
  @BuiltValueField(wireName: r'approval')
  bool? get approval;

  UpdateGroupBody._();

  factory UpdateGroupBody([void updates(UpdateGroupBodyBuilder b)]) =
      _$UpdateGroupBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateGroupBodyBuilder b) => b..tone = GroupTone.accent;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateGroupBody> get serializer =>
      _$UpdateGroupBodySerializer();
}

class _$UpdateGroupBodySerializer
    implements PrimitiveSerializer<UpdateGroupBody> {
  @override
  final Iterable<Type> types = const [UpdateGroupBody, _$UpdateGroupBody];

  @override
  final String wireName = r'UpdateGroupBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateGroupBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.tone != null) {
      yield r'tone';
      yield serializers.serialize(
        object.tone,
        specifiedType: const FullType(GroupTone),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.short != null) {
      yield r'short';
      yield serializers.serialize(
        object.short,
        specifiedType: const FullType(String),
      );
    }
    if (object.gameId != null) {
      yield r'gameId';
      yield serializers.serialize(
        object.gameId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.place != null) {
      yield r'place';
      yield serializers.serialize(
        object.place,
        specifiedType: const FullType(String),
      );
    }
    if (object.about != null) {
      yield r'about';
      yield serializers.serialize(
        object.about,
        specifiedType: const FullType(String),
      );
    }
    if (object.rules != null) {
      yield r'rules';
      yield serializers.serialize(
        object.rules,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.approval != null) {
      yield r'approval';
      yield serializers.serialize(
        object.approval,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateGroupBody object, {
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
    required UpdateGroupBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GroupTone),
          ) as GroupTone?;
          if (valueDes == null) continue;
          result.tone = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'short':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.short = valueDes;
          break;
        case r'gameId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.gameId = valueDes;
          break;
        case r'place':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.place = valueDes;
          break;
        case r'about':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.about = valueDes;
          break;
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.rules.replace(valueDes);
          break;
        case r'approval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.approval = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateGroupBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateGroupBodyBuilder();
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
