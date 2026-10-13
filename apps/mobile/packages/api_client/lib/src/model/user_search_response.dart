//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/user_card_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_search_response.g.dart';

/// UserSearchResponse
///
/// Properties:
/// * [items] - Up to 20, by username.
@BuiltValue()
abstract class UserSearchResponse
    implements Built<UserSearchResponse, UserSearchResponseBuilder> {
  /// Up to 20, by username.
  @BuiltValueField(wireName: r'items')
  BuiltList<UserCardDto> get items;

  UserSearchResponse._();

  factory UserSearchResponse([void updates(UserSearchResponseBuilder b)]) =
      _$UserSearchResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserSearchResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserSearchResponse> get serializer =>
      _$UserSearchResponseSerializer();
}

class _$UserSearchResponseSerializer
    implements PrimitiveSerializer<UserSearchResponse> {
  @override
  final Iterable<Type> types = const [UserSearchResponse, _$UserSearchResponse];

  @override
  final String wireName = r'UserSearchResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserSearchResponse object, {
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
    UserSearchResponse object, {
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
    required UserSearchResponseBuilder result,
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
  UserSearchResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserSearchResponseBuilder();
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
