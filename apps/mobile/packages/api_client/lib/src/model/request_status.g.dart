// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RequestStatus _$pending = const RequestStatus._('pending');
const RequestStatus _$accepted = const RequestStatus._('accepted');
const RequestStatus _$declined = const RequestStatus._('declined');
const RequestStatus _$cancelled = const RequestStatus._('cancelled');
const RequestStatus _$expired = const RequestStatus._('expired');

RequestStatus _$valueOf(String name) {
  switch (name) {
    case 'pending':
      return _$pending;
    case 'accepted':
      return _$accepted;
    case 'declined':
      return _$declined;
    case 'cancelled':
      return _$cancelled;
    case 'expired':
      return _$expired;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RequestStatus> _$values =
    BuiltSet<RequestStatus>(const <RequestStatus>[
  _$pending,
  _$accepted,
  _$declined,
  _$cancelled,
  _$expired,
]);

class _$RequestStatusMeta {
  const _$RequestStatusMeta();
  RequestStatus get pending => _$pending;
  RequestStatus get accepted => _$accepted;
  RequestStatus get declined => _$declined;
  RequestStatus get cancelled => _$cancelled;
  RequestStatus get expired => _$expired;
  RequestStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<RequestStatus> get values => _$values;
}

abstract class _$RequestStatusMixin {
  // ignore: non_constant_identifier_names
  _$RequestStatusMeta get RequestStatus => const _$RequestStatusMeta();
}

Serializer<RequestStatus> _$requestStatusSerializer =
    _$RequestStatusSerializer();

class _$RequestStatusSerializer implements PrimitiveSerializer<RequestStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'accepted': 'accepted',
    'declined': 'declined',
    'cancelled': 'cancelled',
    'expired': 'expired',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'accepted': 'accepted',
    'declined': 'declined',
    'cancelled': 'cancelled',
    'expired': 'expired',
  };

  @override
  final Iterable<Type> types = const <Type>[RequestStatus];
  @override
  final String wireName = 'RequestStatus';

  @override
  Object serialize(Serializers serializers, RequestStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RequestStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RequestStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
