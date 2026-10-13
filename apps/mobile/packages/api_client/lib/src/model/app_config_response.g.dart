// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppConfigResponse extends AppConfigResponse {
  @override
  final String minSupportedVersion;
  @override
  final String latestVersion;
  @override
  final String launchCity;
  @override
  final bool groupsComingSoon;

  factory _$AppConfigResponse(
          [void Function(AppConfigResponseBuilder)? updates]) =>
      (AppConfigResponseBuilder()..update(updates))._build();

  _$AppConfigResponse._(
      {required this.minSupportedVersion,
      required this.latestVersion,
      required this.launchCity,
      required this.groupsComingSoon})
      : super._();
  @override
  AppConfigResponse rebuild(void Function(AppConfigResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppConfigResponseBuilder toBuilder() =>
      AppConfigResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppConfigResponse &&
        minSupportedVersion == other.minSupportedVersion &&
        latestVersion == other.latestVersion &&
        launchCity == other.launchCity &&
        groupsComingSoon == other.groupsComingSoon;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, minSupportedVersion.hashCode);
    _$hash = $jc(_$hash, latestVersion.hashCode);
    _$hash = $jc(_$hash, launchCity.hashCode);
    _$hash = $jc(_$hash, groupsComingSoon.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppConfigResponse')
          ..add('minSupportedVersion', minSupportedVersion)
          ..add('latestVersion', latestVersion)
          ..add('launchCity', launchCity)
          ..add('groupsComingSoon', groupsComingSoon))
        .toString();
  }
}

class AppConfigResponseBuilder
    implements Builder<AppConfigResponse, AppConfigResponseBuilder> {
  _$AppConfigResponse? _$v;

  String? _minSupportedVersion;
  String? get minSupportedVersion => _$this._minSupportedVersion;
  set minSupportedVersion(String? minSupportedVersion) =>
      _$this._minSupportedVersion = minSupportedVersion;

  String? _latestVersion;
  String? get latestVersion => _$this._latestVersion;
  set latestVersion(String? latestVersion) =>
      _$this._latestVersion = latestVersion;

  String? _launchCity;
  String? get launchCity => _$this._launchCity;
  set launchCity(String? launchCity) => _$this._launchCity = launchCity;

  bool? _groupsComingSoon;
  bool? get groupsComingSoon => _$this._groupsComingSoon;
  set groupsComingSoon(bool? groupsComingSoon) =>
      _$this._groupsComingSoon = groupsComingSoon;

  AppConfigResponseBuilder() {
    AppConfigResponse._defaults(this);
  }

  AppConfigResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _minSupportedVersion = $v.minSupportedVersion;
      _latestVersion = $v.latestVersion;
      _launchCity = $v.launchCity;
      _groupsComingSoon = $v.groupsComingSoon;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppConfigResponse other) {
    _$v = other as _$AppConfigResponse;
  }

  @override
  void update(void Function(AppConfigResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppConfigResponse build() => _build();

  _$AppConfigResponse _build() {
    final _$result = _$v ??
        _$AppConfigResponse._(
          minSupportedVersion: BuiltValueNullFieldError.checkNotNull(
              minSupportedVersion, r'AppConfigResponse', 'minSupportedVersion'),
          latestVersion: BuiltValueNullFieldError.checkNotNull(
              latestVersion, r'AppConfigResponse', 'latestVersion'),
          launchCity: BuiltValueNullFieldError.checkNotNull(
              launchCity, r'AppConfigResponse', 'launchCity'),
          groupsComingSoon: BuiltValueNullFieldError.checkNotNull(
              groupsComingSoon, r'AppConfigResponse', 'groupsComingSoon'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
