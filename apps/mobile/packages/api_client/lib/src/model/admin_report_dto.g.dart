// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReportDto extends AdminReportDto {
  @override
  final ReportReason reason;
  @override
  final ReportStatus status;
  @override
  final String id;
  @override
  final AdminUserDto reporter;
  @override
  final AdminUserDto target;
  @override
  final String? listingId;
  @override
  final String? postId;
  @override
  final String? commentId;
  @override
  final String? groupId;
  @override
  final String? excerpt;
  @override
  final String? groupName;
  @override
  final MediaDto? image;
  @override
  final String? details;
  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;
  @override
  final String? resolutionNote;

  factory _$AdminReportDto([void Function(AdminReportDtoBuilder)? updates]) =>
      (AdminReportDtoBuilder()..update(updates))._build();

  _$AdminReportDto._(
      {required this.reason,
      required this.status,
      required this.id,
      required this.reporter,
      required this.target,
      this.listingId,
      this.postId,
      this.commentId,
      this.groupId,
      this.excerpt,
      this.groupName,
      this.image,
      this.details,
      required this.createdAt,
      this.resolvedAt,
      this.resolutionNote})
      : super._();
  @override
  AdminReportDto rebuild(void Function(AdminReportDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReportDtoBuilder toBuilder() => AdminReportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportDto &&
        reason == other.reason &&
        status == other.status &&
        id == other.id &&
        reporter == other.reporter &&
        target == other.target &&
        listingId == other.listingId &&
        postId == other.postId &&
        commentId == other.commentId &&
        groupId == other.groupId &&
        excerpt == other.excerpt &&
        groupName == other.groupName &&
        image == other.image &&
        details == other.details &&
        createdAt == other.createdAt &&
        resolvedAt == other.resolvedAt &&
        resolutionNote == other.resolutionNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reporter.hashCode);
    _$hash = $jc(_$hash, target.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, postId.hashCode);
    _$hash = $jc(_$hash, commentId.hashCode);
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, excerpt.hashCode);
    _$hash = $jc(_$hash, groupName.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jc(_$hash, resolutionNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReportDto')
          ..add('reason', reason)
          ..add('status', status)
          ..add('id', id)
          ..add('reporter', reporter)
          ..add('target', target)
          ..add('listingId', listingId)
          ..add('postId', postId)
          ..add('commentId', commentId)
          ..add('groupId', groupId)
          ..add('excerpt', excerpt)
          ..add('groupName', groupName)
          ..add('image', image)
          ..add('details', details)
          ..add('createdAt', createdAt)
          ..add('resolvedAt', resolvedAt)
          ..add('resolutionNote', resolutionNote))
        .toString();
  }
}

class AdminReportDtoBuilder
    implements Builder<AdminReportDto, AdminReportDtoBuilder> {
  _$AdminReportDto? _$v;

  ReportReason? _reason;
  ReportReason? get reason => _$this._reason;
  set reason(ReportReason? reason) => _$this._reason = reason;

  ReportStatus? _status;
  ReportStatus? get status => _$this._status;
  set status(ReportStatus? status) => _$this._status = status;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminUserDtoBuilder? _reporter;
  AdminUserDtoBuilder get reporter =>
      _$this._reporter ??= AdminUserDtoBuilder();
  set reporter(AdminUserDtoBuilder? reporter) => _$this._reporter = reporter;

  AdminUserDtoBuilder? _target;
  AdminUserDtoBuilder get target => _$this._target ??= AdminUserDtoBuilder();
  set target(AdminUserDtoBuilder? target) => _$this._target = target;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _postId;
  String? get postId => _$this._postId;
  set postId(String? postId) => _$this._postId = postId;

  String? _commentId;
  String? get commentId => _$this._commentId;
  set commentId(String? commentId) => _$this._commentId = commentId;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  String? _excerpt;
  String? get excerpt => _$this._excerpt;
  set excerpt(String? excerpt) => _$this._excerpt = excerpt;

  String? _groupName;
  String? get groupName => _$this._groupName;
  set groupName(String? groupName) => _$this._groupName = groupName;

  MediaDtoBuilder? _image;
  MediaDtoBuilder get image => _$this._image ??= MediaDtoBuilder();
  set image(MediaDtoBuilder? image) => _$this._image = image;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  String? _resolutionNote;
  String? get resolutionNote => _$this._resolutionNote;
  set resolutionNote(String? resolutionNote) =>
      _$this._resolutionNote = resolutionNote;

  AdminReportDtoBuilder() {
    AdminReportDto._defaults(this);
  }

  AdminReportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _status = $v.status;
      _id = $v.id;
      _reporter = $v.reporter.toBuilder();
      _target = $v.target.toBuilder();
      _listingId = $v.listingId;
      _postId = $v.postId;
      _commentId = $v.commentId;
      _groupId = $v.groupId;
      _excerpt = $v.excerpt;
      _groupName = $v.groupName;
      _image = $v.image?.toBuilder();
      _details = $v.details;
      _createdAt = $v.createdAt;
      _resolvedAt = $v.resolvedAt;
      _resolutionNote = $v.resolutionNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportDto other) {
    _$v = other as _$AdminReportDto;
  }

  @override
  void update(void Function(AdminReportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportDto build() => _build();

  _$AdminReportDto _build() {
    _$AdminReportDto _$result;
    try {
      _$result = _$v ??
          _$AdminReportDto._(
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'AdminReportDto', 'reason'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminReportDto', 'status'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminReportDto', 'id'),
            reporter: reporter.build(),
            target: target.build(),
            listingId: listingId,
            postId: postId,
            commentId: commentId,
            groupId: groupId,
            excerpt: excerpt,
            groupName: groupName,
            image: _image?.build(),
            details: details,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AdminReportDto', 'createdAt'),
            resolvedAt: resolvedAt,
            resolutionNote: resolutionNote,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reporter';
        reporter.build();
        _$failedField = 'target';
        target.build();

        _$failedField = 'image';
        _image?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminReportDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
