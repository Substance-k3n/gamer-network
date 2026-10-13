// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NotificationType _$connectionRequest =
    const NotificationType._('connectionRequest');
const NotificationType _$connectionAccepted =
    const NotificationType._('connectionAccepted');
const NotificationType _$playInvite = const NotificationType._('playInvite');
const NotificationType _$playInviteAccepted =
    const NotificationType._('playInviteAccepted');
const NotificationType _$checkInDue = const NotificationType._('checkInDue');
const NotificationType _$listingExpiring =
    const NotificationType._('listingExpiring');
const NotificationType _$reportResolved =
    const NotificationType._('reportResolved');

NotificationType _$valueOf(String name) {
  switch (name) {
    case 'connectionRequest':
      return _$connectionRequest;
    case 'connectionAccepted':
      return _$connectionAccepted;
    case 'playInvite':
      return _$playInvite;
    case 'playInviteAccepted':
      return _$playInviteAccepted;
    case 'checkInDue':
      return _$checkInDue;
    case 'listingExpiring':
      return _$listingExpiring;
    case 'reportResolved':
      return _$reportResolved;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NotificationType> _$values =
    BuiltSet<NotificationType>(const <NotificationType>[
  _$connectionRequest,
  _$connectionAccepted,
  _$playInvite,
  _$playInviteAccepted,
  _$checkInDue,
  _$listingExpiring,
  _$reportResolved,
]);

class _$NotificationTypeMeta {
  const _$NotificationTypeMeta();
  NotificationType get connectionRequest => _$connectionRequest;
  NotificationType get connectionAccepted => _$connectionAccepted;
  NotificationType get playInvite => _$playInvite;
  NotificationType get playInviteAccepted => _$playInviteAccepted;
  NotificationType get checkInDue => _$checkInDue;
  NotificationType get listingExpiring => _$listingExpiring;
  NotificationType get reportResolved => _$reportResolved;
  NotificationType valueOf(String name) => _$valueOf(name);
  BuiltSet<NotificationType> get values => _$values;
}

abstract class _$NotificationTypeMixin {
  // ignore: non_constant_identifier_names
  _$NotificationTypeMeta get NotificationType => const _$NotificationTypeMeta();
}

Serializer<NotificationType> _$notificationTypeSerializer =
    _$NotificationTypeSerializer();

class _$NotificationTypeSerializer
    implements PrimitiveSerializer<NotificationType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'connectionRequest': 'connection_request',
    'connectionAccepted': 'connection_accepted',
    'playInvite': 'play_invite',
    'playInviteAccepted': 'play_invite_accepted',
    'checkInDue': 'check_in_due',
    'listingExpiring': 'listing_expiring',
    'reportResolved': 'report_resolved',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'connection_request': 'connectionRequest',
    'connection_accepted': 'connectionAccepted',
    'play_invite': 'playInvite',
    'play_invite_accepted': 'playInviteAccepted',
    'check_in_due': 'checkInDue',
    'listing_expiring': 'listingExpiring',
    'report_resolved': 'reportResolved',
  };

  @override
  final Iterable<Type> types = const <Type>[NotificationType];
  @override
  final String wireName = 'NotificationType';

  @override
  Object serialize(Serializers serializers, NotificationType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NotificationType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NotificationType.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
