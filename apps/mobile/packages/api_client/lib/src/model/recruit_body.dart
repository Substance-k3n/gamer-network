//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'recruit_body.g.dart';

/// RecruitBody
///
/// Properties:
/// * [slots] - Players wanted, 1–10.
/// * [roles] - Free text, e.g. \"Sniper, Support\". Up to 80 characters, trimmed.
@BuiltValue()
abstract class RecruitBody implements Built<RecruitBody, RecruitBodyBuilder> {
  /// Players wanted, 1–10.
  @BuiltValueField(wireName: r'slots')
  num get slots;

  /// Free text, e.g. \"Sniper, Support\". Up to 80 characters, trimmed.
  @BuiltValueField(wireName: r'roles')
  String? get roles;

  RecruitBody._();

  factory RecruitBody([void updates(RecruitBodyBuilder b)]) = _$RecruitBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RecruitBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RecruitBody> get serializer => _$RecruitBodySerializer();
}

class _$RecruitBodySerializer implements PrimitiveSerializer<RecruitBody> {
  @override
  final Iterable<Type> types = const [RecruitBody, _$RecruitBody];

  @override
  final String wireName = r'RecruitBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RecruitBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'slots';
    yield serializers.serialize(
      object.slots,
      specifiedType: const FullType(num),
    );
    if (object.roles != null) {
      yield r'roles';
      yield serializers.serialize(
        object.roles,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RecruitBody object, {
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
    required RecruitBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'slots':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.slots = valueDes;
          break;
        case r'roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.roles = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RecruitBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RecruitBodyBuilder();
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
