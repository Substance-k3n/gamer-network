//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'code_body.g.dart';

/// CodeBody
///
/// Properties:
/// * [code] - The 6 digits from the email.
@BuiltValue()
abstract class CodeBody implements Built<CodeBody, CodeBodyBuilder> {
  /// The 6 digits from the email.
  @BuiltValueField(wireName: r'code')
  String get code;

  CodeBody._();

  factory CodeBody([void updates(CodeBodyBuilder b)]) = _$CodeBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CodeBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CodeBody> get serializer => _$CodeBodySerializer();
}

class _$CodeBodySerializer implements PrimitiveSerializer<CodeBody> {
  @override
  final Iterable<Type> types = const [CodeBody, _$CodeBody];

  @override
  final String wireName = r'CodeBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CodeBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CodeBody object, {
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
    required CodeBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CodeBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CodeBodyBuilder();
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
