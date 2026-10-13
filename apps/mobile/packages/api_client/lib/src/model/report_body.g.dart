// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReportBody extends ReportBody {
  @override
  final ReportReason reason;
  @override
  final String userId;
  @override
  final String? listingId;
  @override
  final String? details;

  factory _$ReportBody([void Function(ReportBodyBuilder)? updates]) =>
      (ReportBodyBuilder()..update(updates))._build();

  _$ReportBody._(
      {required this.reason,
      required this.userId,
      this.listingId,
      this.details})
      : super._();
  @override
  ReportBody rebuild(void Function(ReportBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportBodyBuilder toBuilder() => ReportBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReportBody &&
        reason == other.reason &&
        userId == other.userId &&
        listingId == other.listingId &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReportBody')
          ..add('reason', reason)
          ..add('userId', userId)
          ..add('listingId', listingId)
          ..add('details', details))
        .toString();
  }
}

class ReportBodyBuilder implements Builder<ReportBody, ReportBodyBuilder> {
  _$ReportBody? _$v;

  ReportReason? _reason;
  ReportReason? get reason => _$this._reason;
  set reason(ReportReason? reason) => _$this._reason = reason;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  ReportBodyBuilder() {
    ReportBody._defaults(this);
  }

  ReportBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _userId = $v.userId;
      _listingId = $v.listingId;
      _details = $v.details;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReportBody other) {
    _$v = other as _$ReportBody;
  }

  @override
  void update(void Function(ReportBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReportBody build() => _build();

  _$ReportBody _build() {
    final _$result = _$v ??
        _$ReportBody._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'ReportBody', 'reason'),
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'ReportBody', 'userId'),
          listingId: listingId,
          details: details,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
