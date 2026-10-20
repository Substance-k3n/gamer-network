//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/poll_duration.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'poll_body.g.dart';

/// PollBody
///
/// Properties:
/// * [duration] - How long it stays open: 1 day, 3 days or 1 week.
/// * [options] - 2–4 options, 1–60 characters each, trimmed, all different.
@BuiltValue()
abstract class PollBody implements Built<PollBody, PollBodyBuilder> {
  /// How long it stays open: 1 day, 3 days or 1 week.
  @BuiltValueField(wireName: r'duration')
  PollDuration get duration;
  // enum durationEnum {  1d,  3d,  1w,  };

  /// 2–4 options, 1–60 characters each, trimmed, all different.
  @BuiltValueField(wireName: r'options')
  BuiltSet<String> get options;

  PollBody._();

  factory PollBody([void updates(PollBodyBuilder b)]) = _$PollBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PollBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PollBody> get serializer => _$PollBodySerializer();
}

class _$PollBodySerializer implements PrimitiveSerializer<PollBody> {
  @override
  final Iterable<Type> types = const [PollBody, _$PollBody];

  @override
  final String wireName = r'PollBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PollBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'duration';
    yield serializers.serialize(
      object.duration,
      specifiedType: const FullType(PollDuration),
    );
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PollBody object, {
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
    required PollBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PollDuration),
          ) as PollDuration;
          result.duration = valueDes;
          break;
        case r'options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>;
          result.options.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PollBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PollBodyBuilder();
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
