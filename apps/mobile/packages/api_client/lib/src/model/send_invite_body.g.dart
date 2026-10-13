// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_invite_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SendInviteBody extends SendInviteBody {
  @override
  final InviteWhen playWhen;
  @override
  final String toUserId;
  @override
  final String gameId;

  factory _$SendInviteBody([void Function(SendInviteBodyBuilder)? updates]) =>
      (SendInviteBodyBuilder()..update(updates))._build();

  _$SendInviteBody._(
      {required this.playWhen, required this.toUserId, required this.gameId})
      : super._();
  @override
  SendInviteBody rebuild(void Function(SendInviteBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SendInviteBodyBuilder toBuilder() => SendInviteBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SendInviteBody &&
        playWhen == other.playWhen &&
        toUserId == other.toUserId &&
        gameId == other.gameId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, playWhen.hashCode);
    _$hash = $jc(_$hash, toUserId.hashCode);
    _$hash = $jc(_$hash, gameId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SendInviteBody')
          ..add('playWhen', playWhen)
          ..add('toUserId', toUserId)
          ..add('gameId', gameId))
        .toString();
  }
}

class SendInviteBodyBuilder
    implements Builder<SendInviteBody, SendInviteBodyBuilder> {
  _$SendInviteBody? _$v;

  InviteWhen? _playWhen;
  InviteWhen? get playWhen => _$this._playWhen;
  set playWhen(InviteWhen? playWhen) => _$this._playWhen = playWhen;

  String? _toUserId;
  String? get toUserId => _$this._toUserId;
  set toUserId(String? toUserId) => _$this._toUserId = toUserId;

  String? _gameId;
  String? get gameId => _$this._gameId;
  set gameId(String? gameId) => _$this._gameId = gameId;

  SendInviteBodyBuilder() {
    SendInviteBody._defaults(this);
  }

  SendInviteBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _playWhen = $v.playWhen;
      _toUserId = $v.toUserId;
      _gameId = $v.gameId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SendInviteBody other) {
    _$v = other as _$SendInviteBody;
  }

  @override
  void update(void Function(SendInviteBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SendInviteBody build() => _build();

  _$SendInviteBody _build() {
    final _$result = _$v ??
        _$SendInviteBody._(
          playWhen: BuiltValueNullFieldError.checkNotNull(
              playWhen, r'SendInviteBody', 'playWhen'),
          toUserId: BuiltValueNullFieldError.checkNotNull(
              toUserId, r'SendInviteBody', 'toUserId'),
          gameId: BuiltValueNullFieldError.checkNotNull(
              gameId, r'SendInviteBody', 'gameId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
