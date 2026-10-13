// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waitlist_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WaitlistBody extends WaitlistBody {
  @override
  final String topic;

  factory _$WaitlistBody([void Function(WaitlistBodyBuilder)? updates]) =>
      (WaitlistBodyBuilder()..update(updates))._build();

  _$WaitlistBody._({required this.topic}) : super._();
  @override
  WaitlistBody rebuild(void Function(WaitlistBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WaitlistBodyBuilder toBuilder() => WaitlistBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WaitlistBody && topic == other.topic;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, topic.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WaitlistBody')..add('topic', topic))
        .toString();
  }
}

class WaitlistBodyBuilder
    implements Builder<WaitlistBody, WaitlistBodyBuilder> {
  _$WaitlistBody? _$v;

  String? _topic;
  String? get topic => _$this._topic;
  set topic(String? topic) => _$this._topic = topic;

  WaitlistBodyBuilder() {
    WaitlistBody._defaults(this);
  }

  WaitlistBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _topic = $v.topic;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WaitlistBody other) {
    _$v = other as _$WaitlistBody;
  }

  @override
  void update(void Function(WaitlistBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WaitlistBody build() => _build();

  _$WaitlistBody _build() {
    final _$result = _$v ??
        _$WaitlistBody._(
          topic: BuiltValueNullFieldError.checkNotNull(
              topic, r'WaitlistBody', 'topic'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
