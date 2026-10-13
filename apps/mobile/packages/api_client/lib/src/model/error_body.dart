//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'error_body.g.dart';

/// ErrorBody
///
/// Properties:
/// * [fields] - Field name → problem, on 422
/// * [code] - Stable machine code, e.g. `listing_already_open`.
/// * [message] - Safe to show to the user.
@BuiltValue()
abstract class ErrorBody implements Built<ErrorBody, ErrorBodyBuilder> {
  /// Field name → problem, on 422
  @BuiltValueField(wireName: r'fields')
  BuiltMap<String, String>? get fields;

  /// Stable machine code, e.g. `listing_already_open`.
  @BuiltValueField(wireName: r'code')
  String get code;

  /// Safe to show to the user.
  @BuiltValueField(wireName: r'message')
  String get message;

  ErrorBody._();

  factory ErrorBody([void updates(ErrorBodyBuilder b)]) = _$ErrorBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ErrorBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ErrorBody> get serializer => _$ErrorBodySerializer();
}

class _$ErrorBodySerializer implements PrimitiveSerializer<ErrorBody> {
  @override
  final Iterable<Type> types = const [ErrorBody, _$ErrorBody];

  @override
  final String wireName = r'ErrorBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ErrorBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fields != null) {
      yield r'fields';
      yield serializers.serialize(
        object.fields,
        specifiedType:
            const FullType(BuiltMap, [FullType(String), FullType(String)]),
      );
    }
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ErrorBody object, {
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
    required ErrorBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fields':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>?;
          if (valueDes == null) continue;
          result.fields.replace(valueDes);
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ErrorBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ErrorBodyBuilder();
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
