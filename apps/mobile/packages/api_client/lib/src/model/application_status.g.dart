// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApplicationStatus _$pending = const ApplicationStatus._('pending');
const ApplicationStatus _$accepted = const ApplicationStatus._('accepted');
const ApplicationStatus _$declined = const ApplicationStatus._('declined');

ApplicationStatus _$valueOf(String name) {
  switch (name) {
    case 'pending':
      return _$pending;
    case 'accepted':
      return _$accepted;
    case 'declined':
      return _$declined;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApplicationStatus> _$values =
    BuiltSet<ApplicationStatus>(const <ApplicationStatus>[
  _$pending,
  _$accepted,
  _$declined,
]);

class _$ApplicationStatusMeta {
  const _$ApplicationStatusMeta();
  ApplicationStatus get pending => _$pending;
  ApplicationStatus get accepted => _$accepted;
  ApplicationStatus get declined => _$declined;
  ApplicationStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<ApplicationStatus> get values => _$values;
}

abstract class _$ApplicationStatusMixin {
  // ignore: non_constant_identifier_names
  _$ApplicationStatusMeta get ApplicationStatus =>
      const _$ApplicationStatusMeta();
}

Serializer<ApplicationStatus> _$applicationStatusSerializer =
    _$ApplicationStatusSerializer();

class _$ApplicationStatusSerializer
    implements PrimitiveSerializer<ApplicationStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'accepted': 'accepted',
    'declined': 'declined',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'accepted': 'accepted',
    'declined': 'declined',
  };

  @override
  final Iterable<Type> types = const <Type>[ApplicationStatus];
  @override
  final String wireName = 'ApplicationStatus';

  @override
  Object serialize(Serializers serializers, ApplicationStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApplicationStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApplicationStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
