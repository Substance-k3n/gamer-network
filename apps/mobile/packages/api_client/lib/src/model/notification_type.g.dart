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
const NotificationType _$postGg = const NotificationType._('postGg');
const NotificationType _$postComment = const NotificationType._('postComment');
const NotificationType _$commentReply =
    const NotificationType._('commentReply');
const NotificationType _$mention = const NotificationType._('mention');
const NotificationType _$recruitApplication =
    const NotificationType._('recruitApplication');
const NotificationType _$recruitAccepted =
    const NotificationType._('recruitAccepted');

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
    case 'postGg':
      return _$postGg;
    case 'postComment':
      return _$postComment;
    case 'commentReply':
      return _$commentReply;
    case 'mention':
      return _$mention;
    case 'recruitApplication':
      return _$recruitApplication;
    case 'recruitAccepted':
      return _$recruitAccepted;
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
  _$postGg,
  _$postComment,
  _$commentReply,
  _$mention,
  _$recruitApplication,
  _$recruitAccepted,
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
  NotificationType get postGg => _$postGg;
  NotificationType get postComment => _$postComment;
  NotificationType get commentReply => _$commentReply;
  NotificationType get mention => _$mention;
  NotificationType get recruitApplication => _$recruitApplication;
  NotificationType get recruitAccepted => _$recruitAccepted;
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
    'postGg': 'post_gg',
    'postComment': 'post_comment',
    'commentReply': 'comment_reply',
    'mention': 'mention',
    'recruitApplication': 'recruit_application',
    'recruitAccepted': 'recruit_accepted',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'connection_request': 'connectionRequest',
    'connection_accepted': 'connectionAccepted',
    'play_invite': 'playInvite',
    'play_invite_accepted': 'playInviteAccepted',
    'check_in_due': 'checkInDue',
    'listing_expiring': 'listingExpiring',
    'report_resolved': 'reportResolved',
    'post_gg': 'postGg',
    'post_comment': 'postComment',
    'comment_reply': 'commentReply',
    'mention': 'mention',
    'recruit_application': 'recruitApplication',
    'recruit_accepted': 'recruitAccepted',
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
