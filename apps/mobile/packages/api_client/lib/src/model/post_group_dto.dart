//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/group_tone.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'post_group_dto.g.dart';

/// PostGroupDto
///
/// Properties:
/// * [tone]
/// * [id]
/// * [name]
/// * [short] - The badge, e.g. \"VAL\".
@BuiltValue()
abstract class PostGroupDto
    implements Built<PostGroupDto, PostGroupDtoBuilder> {
  @BuiltValueField(wireName: r'tone')
  GroupTone get tone;
  // enum toneEnum {  accent,  lav,  soft,  grey,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// The badge, e.g. \"VAL\".
  @BuiltValueField(wireName: r'short')
  String get short;

  PostGroupDto._();

  factory PostGroupDto([void updates(PostGroupDtoBuilder b)]) = _$PostGroupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PostGroupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PostGroupDto> get serializer => _$PostGroupDtoSerializer();
}

class _$PostGroupDtoSerializer implements PrimitiveSerializer<PostGroupDto> {
  @override
  final Iterable<Type> types = const [PostGroupDto, _$PostGroupDto];

  @override
  final String wireName = r'PostGroupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PostGroupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tone';
    yield serializers.serialize(
      object.tone,
      specifiedType: const FullType(GroupTone),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    PostGroupDto object, {
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
    required PostGroupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GroupTone),
          ) as GroupTone;
          result.tone = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PostGroupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PostGroupDtoBuilder();
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
