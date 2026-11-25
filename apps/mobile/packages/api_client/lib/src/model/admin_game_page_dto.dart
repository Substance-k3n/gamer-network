//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/admin_game_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_game_page_dto.g.dart';

/// AdminGamePageDto
///
/// Properties:
/// * [items]
/// * [total]
/// * [page]
/// * [pageSize]
@BuiltValue()
abstract class AdminGamePageDto
    implements Built<AdminGamePageDto, AdminGamePageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminGameDto> get items;

  @BuiltValueField(wireName: r'total')
  num get total;

  @BuiltValueField(wireName: r'page')
  num get page;

  @BuiltValueField(wireName: r'pageSize')
  num get pageSize;

  AdminGamePageDto._();

  factory AdminGamePageDto([void updates(AdminGamePageDtoBuilder b)]) =
      _$AdminGamePageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminGamePageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminGamePageDto> get serializer =>
      _$AdminGamePageDtoSerializer();
}

class _$AdminGamePageDtoSerializer
    implements PrimitiveSerializer<AdminGamePageDto> {
  @override
  final Iterable<Type> types = const [AdminGamePageDto, _$AdminGamePageDto];

  @override
  final String wireName = r'AdminGamePageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminGamePageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminGameDto)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(num),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(num),
    );
    yield r'pageSize';
    yield serializers.serialize(
      object.pageSize,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminGamePageDto object, {
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
    required AdminGamePageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminGameDto)]),
          ) as BuiltList<AdminGameDto>;
          result.items.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.total = valueDes;
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.page = valueDes;
          break;
        case r'pageSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.pageSize = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminGamePageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminGamePageDtoBuilder();
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
