// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationDto extends NotificationDto {
  @override
  final NotificationType type;
  @override
  final String id;
  @override
  final UserCardDto? actor;
  @override
  final String? listingId;
  @override
  final String? connectionRequestId;
  @override
  final String? playInviteId;
  @override
  final String? checkInId;
  @override
  final String? postId;
  @override
  final String? commentId;
  @override
  final String? recruitApplicationId;
  @override
  final String? groupId;
  @override
  final String? groupEventId;
  @override
  final String title;
  @override
  final String text;
  @override
  final String route;
  @override
  final DateTime? readAt;
  @override
  final DateTime createdAt;

  factory _$NotificationDto([void Function(NotificationDtoBuilder)? updates]) =>
      (NotificationDtoBuilder()..update(updates))._build();

  _$NotificationDto._(
      {required this.type,
      required this.id,
      this.actor,
      this.listingId,
      this.connectionRequestId,
      this.playInviteId,
      this.checkInId,
      this.postId,
      this.commentId,
      this.recruitApplicationId,
      this.groupId,
      this.groupEventId,
      required this.title,
      required this.text,
      required this.route,
      this.readAt,
      required this.createdAt})
      : super._();
  @override
  NotificationDto rebuild(void Function(NotificationDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationDtoBuilder toBuilder() => NotificationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationDto &&
        type == other.type &&
        id == other.id &&
        actor == other.actor &&
        listingId == other.listingId &&
        connectionRequestId == other.connectionRequestId &&
        playInviteId == other.playInviteId &&
        checkInId == other.checkInId &&
        postId == other.postId &&
        commentId == other.commentId &&
        recruitApplicationId == other.recruitApplicationId &&
        groupId == other.groupId &&
        groupEventId == other.groupEventId &&
        title == other.title &&
        text == other.text &&
        route == other.route &&
        readAt == other.readAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, connectionRequestId.hashCode);
    _$hash = $jc(_$hash, playInviteId.hashCode);
    _$hash = $jc(_$hash, checkInId.hashCode);
    _$hash = $jc(_$hash, postId.hashCode);
    _$hash = $jc(_$hash, commentId.hashCode);
    _$hash = $jc(_$hash, recruitApplicationId.hashCode);
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, groupEventId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, route.hashCode);
    _$hash = $jc(_$hash, readAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationDto')
          ..add('type', type)
          ..add('id', id)
          ..add('actor', actor)
          ..add('listingId', listingId)
          ..add('connectionRequestId', connectionRequestId)
          ..add('playInviteId', playInviteId)
          ..add('checkInId', checkInId)
          ..add('postId', postId)
          ..add('commentId', commentId)
          ..add('recruitApplicationId', recruitApplicationId)
          ..add('groupId', groupId)
          ..add('groupEventId', groupEventId)
          ..add('title', title)
          ..add('text', text)
          ..add('route', route)
          ..add('readAt', readAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class NotificationDtoBuilder
    implements Builder<NotificationDto, NotificationDtoBuilder> {
  _$NotificationDto? _$v;

  NotificationType? _type;
  NotificationType? get type => _$this._type;
  set type(NotificationType? type) => _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  UserCardDtoBuilder? _actor;
  UserCardDtoBuilder get actor => _$this._actor ??= UserCardDtoBuilder();
  set actor(UserCardDtoBuilder? actor) => _$this._actor = actor;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _connectionRequestId;
  String? get connectionRequestId => _$this._connectionRequestId;
  set connectionRequestId(String? connectionRequestId) =>
      _$this._connectionRequestId = connectionRequestId;

  String? _playInviteId;
  String? get playInviteId => _$this._playInviteId;
  set playInviteId(String? playInviteId) => _$this._playInviteId = playInviteId;

  String? _checkInId;
  String? get checkInId => _$this._checkInId;
  set checkInId(String? checkInId) => _$this._checkInId = checkInId;

  String? _postId;
  String? get postId => _$this._postId;
  set postId(String? postId) => _$this._postId = postId;

  String? _commentId;
  String? get commentId => _$this._commentId;
  set commentId(String? commentId) => _$this._commentId = commentId;

  String? _recruitApplicationId;
  String? get recruitApplicationId => _$this._recruitApplicationId;
  set recruitApplicationId(String? recruitApplicationId) =>
      _$this._recruitApplicationId = recruitApplicationId;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  String? _groupEventId;
  String? get groupEventId => _$this._groupEventId;
  set groupEventId(String? groupEventId) => _$this._groupEventId = groupEventId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _route;
  String? get route => _$this._route;
  set route(String? route) => _$this._route = route;

  DateTime? _readAt;
  DateTime? get readAt => _$this._readAt;
  set readAt(DateTime? readAt) => _$this._readAt = readAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  NotificationDtoBuilder() {
    NotificationDto._defaults(this);
  }

  NotificationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _actor = $v.actor?.toBuilder();
      _listingId = $v.listingId;
      _connectionRequestId = $v.connectionRequestId;
      _playInviteId = $v.playInviteId;
      _checkInId = $v.checkInId;
      _postId = $v.postId;
      _commentId = $v.commentId;
      _recruitApplicationId = $v.recruitApplicationId;
      _groupId = $v.groupId;
      _groupEventId = $v.groupEventId;
      _title = $v.title;
      _text = $v.text;
      _route = $v.route;
      _readAt = $v.readAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationDto other) {
    _$v = other as _$NotificationDto;
  }

  @override
  void update(void Function(NotificationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationDto build() => _build();

  _$NotificationDto _build() {
    _$NotificationDto _$result;
    try {
      _$result = _$v ??
          _$NotificationDto._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'NotificationDto', 'type'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'NotificationDto', 'id'),
            actor: _actor?.build(),
            listingId: listingId,
            connectionRequestId: connectionRequestId,
            playInviteId: playInviteId,
            checkInId: checkInId,
            postId: postId,
            commentId: commentId,
            recruitApplicationId: recruitApplicationId,
            groupId: groupId,
            groupEventId: groupEventId,
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'NotificationDto', 'title'),
            text: BuiltValueNullFieldError.checkNotNull(
                text, r'NotificationDto', 'text'),
            route: BuiltValueNullFieldError.checkNotNull(
                route, r'NotificationDto', 'route'),
            readAt: readAt,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'NotificationDto', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'actor';
        _actor?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'NotificationDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
