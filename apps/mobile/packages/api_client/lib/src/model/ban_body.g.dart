// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ban_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BanBody extends BanBody {
  @override
  final String reason;

  factory _$BanBody([void Function(BanBodyBuilder)? updates]) =>
      (BanBodyBuilder()..update(updates))._build();

  _$BanBody._({required this.reason}) : super._();
  @override
  BanBody rebuild(void Function(BanBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BanBodyBuilder toBuilder() => BanBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BanBody && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BanBody')..add('reason', reason))
        .toString();
  }
}

class BanBodyBuilder implements Builder<BanBody, BanBodyBuilder> {
  _$BanBody? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  BanBodyBuilder() {
    BanBody._defaults(this);
  }

  BanBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BanBody other) {
    _$v = other as _$BanBody;
  }

  @override
  void update(void Function(BanBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BanBody build() => _build();

  _$BanBody _build() {
    final _$result = _$v ??
        _$BanBody._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'BanBody', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
