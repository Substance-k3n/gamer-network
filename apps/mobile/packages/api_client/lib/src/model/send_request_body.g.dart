// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_request_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SendRequestBody extends SendRequestBody {
  @override
  final String toUserId;
  @override
  final String? listingId;
  @override
  final String? message;

  factory _$SendRequestBody([void Function(SendRequestBodyBuilder)? updates]) =>
      (SendRequestBodyBuilder()..update(updates))._build();

  _$SendRequestBody._({required this.toUserId, this.listingId, this.message})
      : super._();
  @override
  SendRequestBody rebuild(void Function(SendRequestBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SendRequestBodyBuilder toBuilder() => SendRequestBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SendRequestBody &&
        toUserId == other.toUserId &&
        listingId == other.listingId &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, toUserId.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SendRequestBody')
          ..add('toUserId', toUserId)
          ..add('listingId', listingId)
          ..add('message', message))
        .toString();
  }
}

class SendRequestBodyBuilder
    implements Builder<SendRequestBody, SendRequestBodyBuilder> {
  _$SendRequestBody? _$v;

  String? _toUserId;
  String? get toUserId => _$this._toUserId;
  set toUserId(String? toUserId) => _$this._toUserId = toUserId;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  SendRequestBodyBuilder() {
    SendRequestBody._defaults(this);
  }

  SendRequestBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _toUserId = $v.toUserId;
      _listingId = $v.listingId;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SendRequestBody other) {
    _$v = other as _$SendRequestBody;
  }

  @override
  void update(void Function(SendRequestBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SendRequestBody build() => _build();

  _$SendRequestBody _build() {
    final _$result = _$v ??
        _$SendRequestBody._(
          toUserId: BuiltValueNullFieldError.checkNotNull(
              toUserId, r'SendRequestBody', 'toUserId'),
          listingId: listingId,
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
