//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/listing_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_page_dto.g.dart';

/// ListingPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class ListingPageDto
    implements Built<ListingPageDto, ListingPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ListingDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  ListingPageDto._();

  factory ListingPageDto([void updates(ListingPageDtoBuilder b)]) =
      _$ListingPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingPageDto> get serializer =>
      _$ListingPageDtoSerializer();
}

class _$ListingPageDtoSerializer
    implements PrimitiveSerializer<ListingPageDto> {
  @override
  final Iterable<Type> types = const [ListingPageDto, _$ListingPageDto];

  @override
  final String wireName = r'ListingPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ListingDto)]),
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
    ListingPageDto object, {
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
    required ListingPageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ListingDto)]),
          ) as BuiltList<ListingDto>;
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
  ListingPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingPageDtoBuilder();
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
