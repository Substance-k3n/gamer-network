// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InviteStatus _$pending = const InviteStatus._('pending');
const InviteStatus _$accepted = const InviteStatus._('accepted');
const InviteStatus _$declined = const InviteStatus._('declined');
const InviteStatus _$expired = const InviteStatus._('expired');

InviteStatus _$valueOf(String name) {
  switch (name) {
    case 'pending':
      return _$pending;
    case 'accepted':
      return _$accepted;
    case 'declined':
      return _$declined;
    case 'expired':
      return _$expired;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InviteStatus> _$values =
    BuiltSet<InviteStatus>(const <InviteStatus>[
  _$pending,
  _$accepted,
  _$declined,
  _$expired,
]);

class _$InviteStatusMeta {
  const _$InviteStatusMeta();
  InviteStatus get pending => _$pending;
  InviteStatus get accepted => _$accepted;
  InviteStatus get declined => _$declined;
  InviteStatus get expired => _$expired;
  InviteStatus valueOf(String name) => _$valueOf(name);
  BuiltSet<InviteStatus> get values => _$values;
}

abstract class _$InviteStatusMixin {
  // ignore: non_constant_identifier_names
  _$InviteStatusMeta get InviteStatus => const _$InviteStatusMeta();
}

Serializer<InviteStatus> _$inviteStatusSerializer = _$InviteStatusSerializer();

class _$InviteStatusSerializer implements PrimitiveSerializer<InviteStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'accepted': 'accepted',
    'declined': 'declined',
    'expired': 'expired',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'accepted': 'accepted',
    'declined': 'declined',
    'expired': 'expired',
  };

  @override
  final Iterable<Type> types = const <Type>[InviteStatus];
  @override
  final String wireName = 'InviteStatus';

  @override
  Object serialize(Serializers serializers, InviteStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InviteStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InviteStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
