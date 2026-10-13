// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_launch_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetLaunchBody extends SetLaunchBody {
  @override
  final bool isLaunch;

  factory _$SetLaunchBody([void Function(SetLaunchBodyBuilder)? updates]) =>
      (SetLaunchBodyBuilder()..update(updates))._build();

  _$SetLaunchBody._({required this.isLaunch}) : super._();
  @override
  SetLaunchBody rebuild(void Function(SetLaunchBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetLaunchBodyBuilder toBuilder() => SetLaunchBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetLaunchBody && isLaunch == other.isLaunch;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLaunch.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetLaunchBody')
          ..add('isLaunch', isLaunch))
        .toString();
  }
}

class SetLaunchBodyBuilder
    implements Builder<SetLaunchBody, SetLaunchBodyBuilder> {
  _$SetLaunchBody? _$v;

  bool? _isLaunch;
  bool? get isLaunch => _$this._isLaunch;
  set isLaunch(bool? isLaunch) => _$this._isLaunch = isLaunch;

  SetLaunchBodyBuilder() {
    SetLaunchBody._defaults(this);
  }

  SetLaunchBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLaunch = $v.isLaunch;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetLaunchBody other) {
    _$v = other as _$SetLaunchBody;
  }

  @override
  void update(void Function(SetLaunchBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetLaunchBody build() => _build();

  _$SetLaunchBody _build() {
    final _$result = _$v ??
        _$SetLaunchBody._(
          isLaunch: BuiltValueNullFieldError.checkNotNull(
              isLaunch, r'SetLaunchBody', 'isLaunch'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
