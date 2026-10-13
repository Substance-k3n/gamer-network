//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/resolve_action.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'resolve_report_body.g.dart';

/// ResolveReportBody
///
/// Properties:
/// * [action] - dismiss: no action. warn, remove_listing (the reported listing), ban (the target).
/// * [note]
@BuiltValue()
abstract class ResolveReportBody
    implements Built<ResolveReportBody, ResolveReportBodyBuilder> {
  /// dismiss: no action. warn, remove_listing (the reported listing), ban (the target).
  @BuiltValueField(wireName: r'action')
  ResolveAction get action;
  // enum actionEnum {  dismiss,  warn,  remove_listing,  ban,  };

  @BuiltValueField(wireName: r'note')
  String get note;

  ResolveReportBody._();

  factory ResolveReportBody([void updates(ResolveReportBodyBuilder b)]) =
      _$ResolveReportBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResolveReportBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResolveReportBody> get serializer =>
      _$ResolveReportBodySerializer();
}

class _$ResolveReportBodySerializer
    implements PrimitiveSerializer<ResolveReportBody> {
  @override
  final Iterable<Type> types = const [ResolveReportBody, _$ResolveReportBody];

  @override
  final String wireName = r'ResolveReportBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResolveReportBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(ResolveAction),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResolveReportBody object, {
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
    required ResolveReportBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ResolveAction),
          ) as ResolveAction;
          result.action = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResolveReportBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResolveReportBodyBuilder();
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
