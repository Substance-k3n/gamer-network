//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/admin_user_dto.dart';
import 'package:api_client/src/model/report_status.dart';
import 'package:api_client/src/model/report_reason.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto.g.dart';

/// AdminReportDto
///
/// Properties:
/// * [reason]
/// * [status]
/// * [id]
/// * [reporter]
/// * [target]
/// * [listingId]
/// * [details]
/// * [createdAt]
/// * [resolvedAt]
/// * [resolutionNote]
@BuiltValue()
abstract class AdminReportDto
    implements Built<AdminReportDto, AdminReportDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  ReportReason get reason;
  // enum reasonEnum {  harassment,  hate,  sexual_content,  underage,  spam,  impersonation,  cheating_or_scam,  other,  };

  @BuiltValueField(wireName: r'status')
  ReportStatus get status;
  // enum statusEnum {  open,  actioned,  dismissed,  };

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reporter')
  AdminUserDto get reporter;

  @BuiltValueField(wireName: r'target')
  AdminUserDto get target;

  @BuiltValueField(wireName: r'listingId')
  String? get listingId;

  @BuiltValueField(wireName: r'details')
  String? get details;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  @BuiltValueField(wireName: r'resolutionNote')
  String? get resolutionNote;

  AdminReportDto._();

  factory AdminReportDto([void updates(AdminReportDtoBuilder b)]) =
      _$AdminReportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDto> get serializer =>
      _$AdminReportDtoSerializer();
}

class _$AdminReportDtoSerializer
    implements PrimitiveSerializer<AdminReportDto> {
  @override
  final Iterable<Type> types = const [AdminReportDto, _$AdminReportDto];

  @override
  final String wireName = r'AdminReportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(ReportReason),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ReportStatus),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reporter';
    yield serializers.serialize(
      object.reporter,
      specifiedType: const FullType(AdminUserDto),
    );
    yield r'target';
    yield serializers.serialize(
      object.target,
      specifiedType: const FullType(AdminUserDto),
    );
    yield r'listingId';
    yield object.listingId == null
        ? null
        : serializers.serialize(
            object.listingId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'details';
    yield object.details == null
        ? null
        : serializers.serialize(
            object.details,
            specifiedType: const FullType.nullable(String),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'resolvedAt';
    yield object.resolvedAt == null
        ? null
        : serializers.serialize(
            object.resolvedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'resolutionNote';
    yield object.resolutionNote == null
        ? null
        : serializers.serialize(
            object.resolutionNote,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDto object, {
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
    required AdminReportDtoBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReportStatus),
          ) as ReportStatus;
          result.status = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'reporter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminUserDto),
          ) as AdminUserDto;
          result.reporter.replace(valueDes);
          break;
        case r'target':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminUserDto),
          ) as AdminUserDto;
          result.target.replace(valueDes);
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
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'resolvedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        case r'resolutionNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.resolutionNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoBuilder();
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
