// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_device_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterDeviceBody extends RegisterDeviceBody {
  @override
  final DevicePlatform platform;
  @override
  final String? appVersion;
  @override
  final String fcmToken;

  factory _$RegisterDeviceBody(
          [void Function(RegisterDeviceBodyBuilder)? updates]) =>
      (RegisterDeviceBodyBuilder()..update(updates))._build();

  _$RegisterDeviceBody._(
      {required this.platform, this.appVersion, required this.fcmToken})
      : super._();
  @override
  RegisterDeviceBody rebuild(
          void Function(RegisterDeviceBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterDeviceBodyBuilder toBuilder() =>
      RegisterDeviceBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterDeviceBody &&
        platform == other.platform &&
        appVersion == other.appVersion &&
        fcmToken == other.fcmToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jc(_$hash, fcmToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterDeviceBody')
          ..add('platform', platform)
          ..add('appVersion', appVersion)
          ..add('fcmToken', fcmToken))
        .toString();
  }
}

class RegisterDeviceBodyBuilder
    implements Builder<RegisterDeviceBody, RegisterDeviceBodyBuilder> {
  _$RegisterDeviceBody? _$v;

  DevicePlatform? _platform;
  DevicePlatform? get platform => _$this._platform;
  set platform(DevicePlatform? platform) => _$this._platform = platform;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  String? _fcmToken;
  String? get fcmToken => _$this._fcmToken;
  set fcmToken(String? fcmToken) => _$this._fcmToken = fcmToken;

  RegisterDeviceBodyBuilder() {
    RegisterDeviceBody._defaults(this);
  }

  RegisterDeviceBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platform = $v.platform;
      _appVersion = $v.appVersion;
      _fcmToken = $v.fcmToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterDeviceBody other) {
    _$v = other as _$RegisterDeviceBody;
  }

  @override
  void update(void Function(RegisterDeviceBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterDeviceBody build() => _build();

  _$RegisterDeviceBody _build() {
    final _$result = _$v ??
        _$RegisterDeviceBody._(
          platform: BuiltValueNullFieldError.checkNotNull(
              platform, r'RegisterDeviceBody', 'platform'),
          appVersion: appVersion,
          fcmToken: BuiltValueNullFieldError.checkNotNull(
              fcmToken, r'RegisterDeviceBody', 'fcmToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
