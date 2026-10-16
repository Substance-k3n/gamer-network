//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/voice.dart';
import 'package:api_client/src/model/play_style.dart';
import 'package:api_client/src/model/play_when.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_listing_body.g.dart';

/// UpdateListingBody
///
/// Properties:
/// * [voice]
/// * [style]
/// * [playWhen] - Moves the start and the end, keeping durationHours, counted from now.
/// * [note] - null or \"\" clears it.
@BuiltValue()
abstract class UpdateListingBody
    implements Built<UpdateListingBody, UpdateListingBodyBuilder> {
  @BuiltValueField(wireName: r'voice')
  Voice? get voice;
  // enum voiceEnum {  required,  optional,  };

  @BuiltValueField(wireName: r'style')
  PlayStyle? get style;
  // enum styleEnum {  competitive,  casual,  };

  /// Moves the start and the end, keeping durationHours, counted from now.
  @BuiltValueField(wireName: r'playWhen')
  PlayWhen? get playWhen;
  // enum playWhenEnum {  now,  tonight,  weekend,  };

  /// null or \"\" clears it.
  @BuiltValueField(wireName: r'note')
  String? get note;

  UpdateListingBody._();

  factory UpdateListingBody([void updates(UpdateListingBodyBuilder b)]) =
      _$UpdateListingBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateListingBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateListingBody> get serializer =>
      _$UpdateListingBodySerializer();
}

class _$UpdateListingBodySerializer
    implements PrimitiveSerializer<UpdateListingBody> {
  @override
  final Iterable<Type> types = const [UpdateListingBody, _$UpdateListingBody];

  @override
  final String wireName = r'UpdateListingBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateListingBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.voice != null) {
      yield r'voice';
      yield serializers.serialize(
        object.voice,
        specifiedType: const FullType(Voice),
      );
    }
    if (object.style != null) {
      yield r'style';
      yield serializers.serialize(
        object.style,
        specifiedType: const FullType(PlayStyle),
      );
    }
    if (object.playWhen != null) {
      yield r'playWhen';
      yield serializers.serialize(
        object.playWhen,
        specifiedType: const FullType(PlayWhen),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateListingBody object, {
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
    required UpdateListingBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'voice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Voice),
          ) as Voice?;
          if (valueDes == null) continue;
          result.voice = valueDes;
          break;
        case r'style':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PlayStyle),
          ) as PlayStyle?;
          if (valueDes == null) continue;
          result.style = valueDes;
          break;
        case r'playWhen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PlayWhen),
          ) as PlayWhen?;
          if (valueDes == null) continue;
          result.playWhen = valueDes;
          break;
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
  UpdateListingBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateListingBodyBuilder();
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
