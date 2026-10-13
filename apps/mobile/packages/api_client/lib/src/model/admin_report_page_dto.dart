//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/admin_report_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_page_dto.g.dart';

/// AdminReportPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class AdminReportPageDto
    implements Built<AdminReportPageDto, AdminReportPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminReportDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  AdminReportPageDto._();

  factory AdminReportPageDto([void updates(AdminReportPageDtoBuilder b)]) =
      _$AdminReportPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportPageDto> get serializer =>
      _$AdminReportPageDtoSerializer();
}

class _$AdminReportPageDtoSerializer
    implements PrimitiveSerializer<AdminReportPageDto> {
  @override
  final Iterable<Type> types = const [AdminReportPageDto, _$AdminReportPageDto];

  @override
  final String wireName = r'AdminReportPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminReportDto)]),
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
    AdminReportPageDto object, {
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
    required AdminReportPageDtoBuilder result,
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
                const FullType(BuiltList, [FullType(AdminReportDto)]),
          ) as BuiltList<AdminReportDto>;
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
  AdminReportPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportPageDtoBuilder();
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
