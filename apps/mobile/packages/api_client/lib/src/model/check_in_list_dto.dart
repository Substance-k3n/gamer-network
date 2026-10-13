//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/check_in_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'check_in_list_dto.g.dart';

/// CheckInListDto
///
/// Properties:
/// * [items] - Due and unanswered, oldest first.
@BuiltValue()
abstract class CheckInListDto
    implements Built<CheckInListDto, CheckInListDtoBuilder> {
  /// Due and unanswered, oldest first.
  @BuiltValueField(wireName: r'items')
  BuiltList<CheckInDto> get items;

  CheckInListDto._();

  factory CheckInListDto([void updates(CheckInListDtoBuilder b)]) =
      _$CheckInListDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckInListDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckInListDto> get serializer =>
      _$CheckInListDtoSerializer();
}

class _$CheckInListDtoSerializer
    implements PrimitiveSerializer<CheckInListDto> {
  @override
  final Iterable<Type> types = const [CheckInListDto, _$CheckInListDto];

  @override
  final String wireName = r'CheckInListDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckInListDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CheckInDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckInListDto object, {
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
    required CheckInListDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CheckInDto)]),
          ) as BuiltList<CheckInDto>;
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
  CheckInListDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckInListDtoBuilder();
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
