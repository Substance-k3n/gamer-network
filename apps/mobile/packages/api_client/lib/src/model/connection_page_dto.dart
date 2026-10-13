//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/connection_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'connection_page_dto.g.dart';

/// ConnectionPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class ConnectionPageDto
    implements Built<ConnectionPageDto, ConnectionPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ConnectionDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  ConnectionPageDto._();

  factory ConnectionPageDto([void updates(ConnectionPageDtoBuilder b)]) =
      _$ConnectionPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConnectionPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConnectionPageDto> get serializer =>
      _$ConnectionPageDtoSerializer();
}

class _$ConnectionPageDtoSerializer
    implements PrimitiveSerializer<ConnectionPageDto> {
  @override
  final Iterable<Type> types = const [ConnectionPageDto, _$ConnectionPageDto];

  @override
  final String wireName = r'ConnectionPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConnectionPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ConnectionDto)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null
        ? null
        : serializers.serialize(
            object.nextCursor,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConnectionPageDto object, {
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
    required ConnectionPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ConnectionDto)]),
          ) as BuiltList<ConnectionDto>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConnectionPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConnectionPageDtoBuilder();
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
