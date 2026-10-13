//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'username_availability.g.dart';

/// UsernameAvailability
///
/// Properties:
/// * [available]
/// * [reason] - Why it isn't: \"taken\" or \"invalid\".
@BuiltValue()
abstract class UsernameAvailability
    implements Built<UsernameAvailability, UsernameAvailabilityBuilder> {
  @BuiltValueField(wireName: r'available')
  bool get available;

  /// Why it isn't: \"taken\" or \"invalid\".
  @BuiltValueField(wireName: r'reason')
  UsernameAvailabilityReasonEnum? get reason;
  // enum reasonEnum {  taken,  invalid,  };

  UsernameAvailability._();

  factory UsernameAvailability([void updates(UsernameAvailabilityBuilder b)]) =
      _$UsernameAvailability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UsernameAvailabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UsernameAvailability> get serializer =>
      _$UsernameAvailabilitySerializer();
}

class _$UsernameAvailabilitySerializer
    implements PrimitiveSerializer<UsernameAvailability> {
  @override
  final Iterable<Type> types = const [
    UsernameAvailability,
    _$UsernameAvailability
  ];

  @override
  final String wireName = r'UsernameAvailability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UsernameAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(UsernameAvailabilityReasonEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UsernameAvailability object, {
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
    required UsernameAvailabilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(UsernameAvailabilityReasonEnum),
          ) as UsernameAvailabilityReasonEnum?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UsernameAvailability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UsernameAvailabilityBuilder();
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

/// Why it isn't: \"taken\" or \"invalid\".
class UsernameAvailabilityReasonEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'taken')
  static const UsernameAvailabilityReasonEnum taken =
      _$usernameAvailabilityReasonEnum_taken;
  @BuiltValueEnumConst(wireName: r'invalid')
  static const UsernameAvailabilityReasonEnum invalid =
      _$usernameAvailabilityReasonEnum_invalid;

  static Serializer<UsernameAvailabilityReasonEnum> get serializer =>
      _$usernameAvailabilityReasonEnumSerializer;

  const UsernameAvailabilityReasonEnum._(String name) : super(name);

  static BuiltSet<UsernameAvailabilityReasonEnum> get values =>
      _$usernameAvailabilityReasonEnumValues;
  static UsernameAvailabilityReasonEnum valueOf(String name) =>
      _$usernameAvailabilityReasonEnumValueOf(name);
}
