//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_post_author_dto.g.dart';

/// PublicPostAuthorDto
///
/// Properties:
/// * [displayName]
/// * [username]
/// * [avatarUrl]
@BuiltValue()
abstract class PublicPostAuthorDto
    implements Built<PublicPostAuthorDto, PublicPostAuthorDtoBuilder> {
  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'avatarUrl')
  String? get avatarUrl;

  PublicPostAuthorDto._();

  factory PublicPostAuthorDto([void updates(PublicPostAuthorDtoBuilder b)]) =
      _$PublicPostAuthorDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicPostAuthorDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicPostAuthorDto> get serializer =>
      _$PublicPostAuthorDtoSerializer();
}

class _$PublicPostAuthorDtoSerializer
    implements PrimitiveSerializer<PublicPostAuthorDto> {
  @override
  final Iterable<Type> types = const [
    PublicPostAuthorDto,
    _$PublicPostAuthorDto
  ];

  @override
  final String wireName = r'PublicPostAuthorDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicPostAuthorDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'avatarUrl';
    yield object.avatarUrl == null
        ? null
        : serializers.serialize(
            object.avatarUrl,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicPostAuthorDto object, {
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
    required PublicPostAuthorDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'avatarUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicPostAuthorDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicPostAuthorDtoBuilder();
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
