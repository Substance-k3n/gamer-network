//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'app_config_response.g.dart';

/// AppConfigResponse
///
/// Properties:
/// * [minSupportedVersion] - Apps below this version must update (they get 426 everywhere else).
/// * [latestVersion] - Newest released version, for a gentle \"Update available\".
/// * [launchCity] - The one city the beta runs in.
/// * [groupsComingSoon] - Show the Groups tab as \"coming soon\" with a waitlist. False once groups ship (the opposite of groupsEnabled).
/// * [feedEnabled] - Show the Home feed (posts, comments, GG). On by default (FEED_ENABLED=false turns it off).
/// * [groupsEnabled] - Show Groups for real. On by default (GROUPS_ENABLED=false turns it off).
@BuiltValue()
abstract class AppConfigResponse
    implements Built<AppConfigResponse, AppConfigResponseBuilder> {
  /// Apps below this version must update (they get 426 everywhere else).
  @BuiltValueField(wireName: r'minSupportedVersion')
  String get minSupportedVersion;

  /// Newest released version, for a gentle \"Update available\".
  @BuiltValueField(wireName: r'latestVersion')
  String get latestVersion;

  /// The one city the beta runs in.
  @BuiltValueField(wireName: r'launchCity')
  String get launchCity;

  /// Show the Groups tab as \"coming soon\" with a waitlist. False once groups ship (the opposite of groupsEnabled).
  @BuiltValueField(wireName: r'groupsComingSoon')
  bool get groupsComingSoon;

  /// Show the Home feed (posts, comments, GG). On by default (FEED_ENABLED=false turns it off).
  @BuiltValueField(wireName: r'feedEnabled')
  bool get feedEnabled;

  /// Show Groups for real. On by default (GROUPS_ENABLED=false turns it off).
  @BuiltValueField(wireName: r'groupsEnabled')
  bool get groupsEnabled;

  AppConfigResponse._();

  factory AppConfigResponse([void updates(AppConfigResponseBuilder b)]) =
      _$AppConfigResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AppConfigResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AppConfigResponse> get serializer =>
      _$AppConfigResponseSerializer();
}

class _$AppConfigResponseSerializer
    implements PrimitiveSerializer<AppConfigResponse> {
  @override
  final Iterable<Type> types = const [AppConfigResponse, _$AppConfigResponse];

  @override
  final String wireName = r'AppConfigResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AppConfigResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minSupportedVersion';
    yield serializers.serialize(
      object.minSupportedVersion,
      specifiedType: const FullType(String),
    );
    yield r'latestVersion';
    yield serializers.serialize(
      object.latestVersion,
      specifiedType: const FullType(String),
    );
    yield r'launchCity';
    yield serializers.serialize(
      object.launchCity,
      specifiedType: const FullType(String),
    );
    yield r'groupsComingSoon';
    yield serializers.serialize(
      object.groupsComingSoon,
      specifiedType: const FullType(bool),
    );
    yield r'feedEnabled';
    yield serializers.serialize(
      object.feedEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'groupsEnabled';
    yield serializers.serialize(
      object.groupsEnabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AppConfigResponse object, {
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
    required AppConfigResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minSupportedVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.minSupportedVersion = valueDes;
          break;
        case r'latestVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.latestVersion = valueDes;
          break;
        case r'launchCity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.launchCity = valueDes;
          break;
        case r'groupsComingSoon':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.groupsComingSoon = valueDes;
          break;
        case r'feedEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.feedEnabled = valueDes;
          break;
        case r'groupsEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.groupsEnabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AppConfigResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AppConfigResponseBuilder();
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
