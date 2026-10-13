//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/play_invite_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'play_invite_list_dto.g.dart';

/// PlayInviteListDto
///
/// Properties:
/// * [items] - Pending and not expired, newest first.
@BuiltValue()
abstract class PlayInviteListDto
    implements Built<PlayInviteListDto, PlayInviteListDtoBuilder> {
  /// Pending and not expired, newest first.
  @BuiltValueField(wireName: r'items')
  BuiltList<PlayInviteDto> get items;

  PlayInviteListDto._();

  factory PlayInviteListDto([void updates(PlayInviteListDtoBuilder b)]) =
      _$PlayInviteListDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlayInviteListDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlayInviteListDto> get serializer =>
      _$PlayInviteListDtoSerializer();
}

class _$PlayInviteListDtoSerializer
    implements PrimitiveSerializer<PlayInviteListDto> {
  @override
  final Iterable<Type> types = const [PlayInviteListDto, _$PlayInviteListDto];

  @override
  final String wireName = r'PlayInviteListDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlayInviteListDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(PlayInviteDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PlayInviteListDto object, {
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
    required PlayInviteListDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PlayInviteDto)]),
          ) as BuiltList<PlayInviteDto>;
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
  PlayInviteListDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlayInviteListDtoBuilder();
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
