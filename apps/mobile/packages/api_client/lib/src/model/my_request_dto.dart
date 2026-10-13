//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/request_status.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'my_request_dto.g.dart';

/// MyRequestDto
///
/// Properties:
/// * [status]
/// * [id]
@BuiltValue()
abstract class MyRequestDto
    implements Built<MyRequestDto, MyRequestDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  RequestStatus get status;
  // enum statusEnum {  pending,  accepted,  declined,  cancelled,  expired,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  MyRequestDto._();

  factory MyRequestDto([void updates(MyRequestDtoBuilder b)]) = _$MyRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MyRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MyRequestDto> get serializer => _$MyRequestDtoSerializer();
}

class _$MyRequestDtoSerializer implements PrimitiveSerializer<MyRequestDto> {
  @override
  final Iterable<Type> types = const [MyRequestDto, _$MyRequestDto];

  @override
  final String wireName = r'MyRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MyRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(RequestStatus),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MyRequestDto object, {
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
    required MyRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RequestStatus),
          ) as RequestStatus;
          result.status = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MyRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MyRequestDtoBuilder();
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
