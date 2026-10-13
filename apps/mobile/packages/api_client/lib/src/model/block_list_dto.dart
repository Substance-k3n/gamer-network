//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'block_list_dto.g.dart';

/// BlockListDto
///
/// Properties:
/// * [items] - People you blocked, most recent first (Settings → Blocked users).
@BuiltValue()
abstract class BlockListDto
    implements Built<BlockListDto, BlockListDtoBuilder> {
  /// People you blocked, most recent first (Settings → Blocked users).
  @BuiltValueField(wireName: r'items')
  BuiltList<UserCardDto> get items;

  BlockListDto._();

  factory BlockListDto([void updates(BlockListDtoBuilder b)]) = _$BlockListDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BlockListDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BlockListDto> get serializer => _$BlockListDtoSerializer();
}

class _$BlockListDtoSerializer implements PrimitiveSerializer<BlockListDto> {
  @override
  final Iterable<Type> types = const [BlockListDto, _$BlockListDto];

  @override
  final String wireName = r'BlockListDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BlockListDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(UserCardDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BlockListDto object, {
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
    required BlockListDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UserCardDto)]),
          ) as BuiltList<UserCardDto>;
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
  BlockListDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BlockListDtoBuilder();
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
