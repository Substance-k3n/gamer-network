//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/admin_user_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_user_number_page_dto.g.dart';

/// AdminUserNumberPageDto
///
/// Properties:
/// * [items]
/// * [total]
/// * [page]
/// * [pageSize]
@BuiltValue()
abstract class AdminUserNumberPageDto
    implements Built<AdminUserNumberPageDto, AdminUserNumberPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminUserDto> get items;

  @BuiltValueField(wireName: r'total')
  num get total;

  @BuiltValueField(wireName: r'page')
  num get page;

  @BuiltValueField(wireName: r'pageSize')
  num get pageSize;

  AdminUserNumberPageDto._();

  factory AdminUserNumberPageDto(
          [void updates(AdminUserNumberPageDtoBuilder b)]) =
      _$AdminUserNumberPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUserNumberPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUserNumberPageDto> get serializer =>
      _$AdminUserNumberPageDtoSerializer();
}

class _$AdminUserNumberPageDtoSerializer
    implements PrimitiveSerializer<AdminUserNumberPageDto> {
  @override
  final Iterable<Type> types = const [
    AdminUserNumberPageDto,
    _$AdminUserNumberPageDto
  ];

  @override
  final String wireName = r'AdminUserNumberPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUserNumberPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminUserDto)]),
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
    AdminUserNumberPageDto object, {
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
    required AdminUserNumberPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminUserDto)]),
          ) as BuiltList<AdminUserDto>;
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
  AdminUserNumberPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUserNumberPageDtoBuilder();
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
