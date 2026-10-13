//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/listing_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'my_listing_dto.g.dart';

/// MyListingDto
///
/// Properties:
/// * [listing] - Your open or full listing, or null.
@BuiltValue()
abstract class MyListingDto
    implements Built<MyListingDto, MyListingDtoBuilder> {
  /// Your open or full listing, or null.
  @BuiltValueField(wireName: r'listing')
  ListingDto? get listing;

  MyListingDto._();

  factory MyListingDto([void updates(MyListingDtoBuilder b)]) = _$MyListingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MyListingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MyListingDto> get serializer => _$MyListingDtoSerializer();
}

class _$MyListingDtoSerializer implements PrimitiveSerializer<MyListingDto> {
  @override
  final Iterable<Type> types = const [MyListingDto, _$MyListingDto];

  @override
  final String wireName = r'MyListingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MyListingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing';
    yield object.listing == null
        ? null
        : serializers.serialize(
            object.listing,
            specifiedType: const FullType.nullable(ListingDto),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MyListingDto object, {
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
    required MyListingDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingDto),
          ) as ListingDto?;
          if (valueDes == null) continue;
          result.listing.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MyListingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MyListingDtoBuilder();
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
