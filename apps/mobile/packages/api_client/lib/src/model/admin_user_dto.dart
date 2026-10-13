//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/account_state.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_user_dto.g.dart';

/// AdminUserDto
///
/// Properties:
/// * [state]
/// * [id]
/// * [username]
/// * [displayName]
/// * [email]
/// * [city]
/// * [mainGame] - First game on their profile.
/// * [banReason]
/// * [onboarded]
/// * [createdAt]
/// * [lastSeenAt] - Latest activity on any session.
/// * [connections]
/// * [playedWith]
/// * [openReports] - Reports against them still open.
@BuiltValue()
abstract class AdminUserDto
    implements Built<AdminUserDto, AdminUserDtoBuilder> {
  @BuiltValueField(wireName: r'state')
  AccountState get state;
  // enum stateEnum {  active,  banned,  deleted,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'city')
  String get city;

  /// First game on their profile.
  @BuiltValueField(wireName: r'mainGame')
  String? get mainGame;

  @BuiltValueField(wireName: r'banReason')
  String? get banReason;

  @BuiltValueField(wireName: r'onboarded')
  bool get onboarded;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Latest activity on any session.
  @BuiltValueField(wireName: r'lastSeenAt')
  DateTime? get lastSeenAt;

  @BuiltValueField(wireName: r'connections')
  num get connections;

  @BuiltValueField(wireName: r'playedWith')
  num get playedWith;

  /// Reports against them still open.
  @BuiltValueField(wireName: r'openReports')
  num get openReports;

  AdminUserDto._();

  factory AdminUserDto([void updates(AdminUserDtoBuilder b)]) = _$AdminUserDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUserDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUserDto> get serializer => _$AdminUserDtoSerializer();
}

class _$AdminUserDtoSerializer implements PrimitiveSerializer<AdminUserDto> {
  @override
  final Iterable<Type> types = const [AdminUserDto, _$AdminUserDto];

  @override
  final String wireName = r'AdminUserDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(AccountState),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'mainGame';
    yield object.mainGame == null
        ? null
        : serializers.serialize(
            object.mainGame,
            specifiedType: const FullType.nullable(String),
          );
    yield r'banReason';
    yield object.banReason == null
        ? null
        : serializers.serialize(
            object.banReason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'onboarded';
    yield serializers.serialize(
      object.onboarded,
      specifiedType: const FullType(bool),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lastSeenAt';
    yield object.lastSeenAt == null
        ? null
        : serializers.serialize(
            object.lastSeenAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'connections';
    yield serializers.serialize(
      object.connections,
      specifiedType: const FullType(num),
    );
    yield r'playedWith';
    yield serializers.serialize(
      object.playedWith,
      specifiedType: const FullType(num),
    );
    yield r'openReports';
    yield serializers.serialize(
      object.openReports,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminUserDto object, {
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
    required AdminUserDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountState),
          ) as AccountState;
          result.state = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'mainGame':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mainGame = valueDes;
          break;
        case r'banReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.banReason = valueDes;
          break;
        case r'onboarded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.onboarded = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'lastSeenAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastSeenAt = valueDes;
          break;
        case r'connections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.connections = valueDes;
          break;
        case r'playedWith':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.playedWith = valueDes;
          break;
        case r'openReports':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.openReports = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminUserDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUserDtoBuilder();
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
