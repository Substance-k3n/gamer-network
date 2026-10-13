//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/play_tag.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_tags_body.g.dart';

/// SetTagsBody
///
/// Properties:
/// * [tags] - At most 6.
@BuiltValue()
abstract class SetTagsBody implements Built<SetTagsBody, SetTagsBodyBuilder> {
  /// At most 6.
  @BuiltValueField(wireName: r'tags')
  BuiltSet<PlayTag> get tags;

  SetTagsBody._();

  factory SetTagsBody([void updates(SetTagsBodyBuilder b)]) = _$SetTagsBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetTagsBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetTagsBody> get serializer => _$SetTagsBodySerializer();
}

class _$SetTagsBodySerializer implements PrimitiveSerializer<SetTagsBody> {
  @override
  final Iterable<Type> types = const [SetTagsBody, _$SetTagsBody];

  @override
  final String wireName = r'SetTagsBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetTagsBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tags';
    yield serializers.serialize(
      object.tags,
      specifiedType: const FullType(BuiltSet, [FullType(PlayTag)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetTagsBody object, {
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
    required SetTagsBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tags':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(PlayTag)]),
          ) as BuiltSet<PlayTag>;
          result.tags.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetTagsBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetTagsBodyBuilder();
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
