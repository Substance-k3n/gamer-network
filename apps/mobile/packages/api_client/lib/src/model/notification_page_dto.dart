//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/notification_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notification_page_dto.g.dart';

/// NotificationPageDto
///
/// Properties:
/// * [items]
/// * [nextCursor]
@BuiltValue()
abstract class NotificationPageDto
    implements Built<NotificationPageDto, NotificationPageDtoBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<NotificationDto> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  NotificationPageDto._();

  factory NotificationPageDto([void updates(NotificationPageDtoBuilder b)]) =
      _$NotificationPageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificationPageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificationPageDto> get serializer =>
      _$NotificationPageDtoSerializer();
}

class _$NotificationPageDtoSerializer
    implements PrimitiveSerializer<NotificationPageDto> {
  @override
  final Iterable<Type> types = const [
    NotificationPageDto,
    _$NotificationPageDto
  ];

  @override
  final String wireName = r'NotificationPageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificationPageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(NotificationDto)]),
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
    NotificationPageDto object, {
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
    required NotificationPageDtoBuilder result,
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
                const FullType(BuiltList, [FullType(NotificationDto)]),
          ) as BuiltList<NotificationDto>;
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
  NotificationPageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationPageDtoBuilder();
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
