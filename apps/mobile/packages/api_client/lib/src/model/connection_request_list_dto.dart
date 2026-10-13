//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/connection_request_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'connection_request_list_dto.g.dart';

/// ConnectionRequestListDto
///
/// Properties:
/// * [items] - Pending only, newest first.
@BuiltValue()
abstract class ConnectionRequestListDto
    implements
        Built<ConnectionRequestListDto, ConnectionRequestListDtoBuilder> {
  /// Pending only, newest first.
  @BuiltValueField(wireName: r'items')
  BuiltList<ConnectionRequestDto> get items;

  ConnectionRequestListDto._();

  factory ConnectionRequestListDto(
          [void updates(ConnectionRequestListDtoBuilder b)]) =
      _$ConnectionRequestListDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConnectionRequestListDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConnectionRequestListDto> get serializer =>
      _$ConnectionRequestListDtoSerializer();
}

class _$ConnectionRequestListDtoSerializer
    implements PrimitiveSerializer<ConnectionRequestListDto> {
  @override
  final Iterable<Type> types = const [
    ConnectionRequestListDto,
    _$ConnectionRequestListDto
  ];

  @override
  final String wireName = r'ConnectionRequestListDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConnectionRequestListDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType:
          const FullType(BuiltList, [FullType(ConnectionRequestDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConnectionRequestListDto object, {
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
    required ConnectionRequestListDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(ConnectionRequestDto)]),
          ) as BuiltList<ConnectionRequestDto>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConnectionRequestListDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConnectionRequestListDtoBuilder();
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
