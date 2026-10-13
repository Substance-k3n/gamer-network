//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/report_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'report_body.g.dart';

/// ReportBody
///
/// Properties:
/// * [reason]
/// * [userId]
/// * [listingId] - When reporting from a listing card: one of their listings.
/// * [details]
@BuiltValue()
abstract class ReportBody implements Built<ReportBody, ReportBodyBuilder> {
  @BuiltValueField(wireName: r'reason')
  ReportReason get reason;
  // enum reasonEnum {  harassment,  hate,  sexual_content,  underage,  spam,  impersonation,  cheating_or_scam,  other,  };

  @BuiltValueField(wireName: r'userId')
  String get userId;

  /// When reporting from a listing card: one of their listings.
  @BuiltValueField(wireName: r'listingId')
  String? get listingId;

  @BuiltValueField(wireName: r'details')
  String? get details;

  ReportBody._();

  factory ReportBody([void updates(ReportBodyBuilder b)]) = _$ReportBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReportBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReportBody> get serializer => _$ReportBodySerializer();
}

class _$ReportBodySerializer implements PrimitiveSerializer<ReportBody> {
  @override
  final Iterable<Type> types = const [ReportBody, _$ReportBody];

  @override
  final String wireName = r'ReportBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReportBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(ReportReason),
    );
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    if (object.listingId != null) {
      yield r'listingId';
      yield serializers.serialize(
        object.listingId,
        specifiedType: const FullType(String),
      );
    }
    if (object.details != null) {
      yield r'details';
      yield serializers.serialize(
        object.details,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReportBody object, {
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
    required ReportBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReportReason),
          ) as ReportReason;
          result.reason = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'listingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.listingId = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.details = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReportBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReportBodyBuilder();
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
