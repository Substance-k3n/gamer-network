//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/admin_user_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_user_page_dto.g.dart';

/// AdminUserPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class AdminUserPageDto
    implements Built<AdminUserPageDto, AdminUserPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminUserDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  AdminUserPageDto._();

  factory AdminUserPageDto([void updates(AdminUserPageDtoBuilder b)]) =
      _$AdminUserPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUserPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUserPageDto> get serializer =>
      _$AdminUserPageDtoSerializer();
}

class _$AdminUserPageDtoSerializer
    implements PrimitiveSerializer<AdminUserPageDto> {
  @override
  final Iterable<Type> types = const [AdminUserPageDto, _$AdminUserPageDto];

  @override
  final String wireName = r'AdminUserPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUserPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminUserDto)]),
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
    AdminUserPageDto object, {
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
    required AdminUserPageDtoBuilder result,
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
  AdminUserPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUserPageDtoBuilder();
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
