// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PollBody extends PollBody {
  @override
  final PollDuration duration;
  @override
  final BuiltSet<String> options;

  factory _$PollBody([void Function(PollBodyBuilder)? updates]) =>
      (PollBodyBuilder()..update(updates))._build();

  _$PollBody._({required this.duration, required this.options}) : super._();
  @override
  PollBody rebuild(void Function(PollBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PollBodyBuilder toBuilder() => PollBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PollBody &&
        duration == other.duration &&
        options == other.options;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PollBody')
          ..add('duration', duration)
          ..add('options', options))
        .toString();
  }
}

class PollBodyBuilder implements Builder<PollBody, PollBodyBuilder> {
  _$PollBody? _$v;

  PollDuration? _duration;
  PollDuration? get duration => _$this._duration;
  set duration(PollDuration? duration) => _$this._duration = duration;

  SetBuilder<String>? _options;
  SetBuilder<String> get options => _$this._options ??= SetBuilder<String>();
  set options(SetBuilder<String>? options) => _$this._options = options;

  PollBodyBuilder() {
    PollBody._defaults(this);
  }

  PollBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _options = $v.options.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PollBody other) {
    _$v = other as _$PollBody;
  }

  @override
  void update(void Function(PollBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PollBody build() => _build();

  _$PollBody _build() {
    _$PollBody _$result;
    try {
      _$result = _$v ??
          _$PollBody._(
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'PollBody', 'duration'),
            options: options.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PollBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
