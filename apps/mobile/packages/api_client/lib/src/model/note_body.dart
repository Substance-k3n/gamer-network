//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'note_body.g.dart';

/// NoteBody
///
/// Properties:
/// * [note]
@BuiltValue()
abstract class NoteBody implements Built<NoteBody, NoteBodyBuilder> {
  @BuiltValueField(wireName: r'note')
  String? get note;

  NoteBody._();

  factory NoteBody([void updates(NoteBodyBuilder b)]) = _$NoteBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NoteBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NoteBody> get serializer => _$NoteBodySerializer();
}

class _$NoteBodySerializer implements PrimitiveSerializer<NoteBody> {
  @override
  final Iterable<Type> types = const [NoteBody, _$NoteBody];

  @override
  final String wireName = r'NoteBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NoteBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NoteBody object, {
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
    required NoteBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NoteBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NoteBodyBuilder();
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
