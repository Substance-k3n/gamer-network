// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_game_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateGameBody extends UpdateGameBody {
  @override
  final BuiltList<Platform>? platforms;
  @override
  final String? name;
  @override
  final String? shortCode;
  @override
  final bool? hasRanks;
  @override
  final num? maxParty;
  @override
  final bool? isLaunch;
  @override
  final num? sort;

  factory _$UpdateGameBody([void Function(UpdateGameBodyBuilder)? updates]) =>
      (UpdateGameBodyBuilder()..update(updates))._build();

  _$UpdateGameBody._(
      {this.platforms,
      this.name,
      this.shortCode,
      this.hasRanks,
      this.maxParty,
      this.isLaunch,
      this.sort})
      : super._();
  @override
  UpdateGameBody rebuild(void Function(UpdateGameBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateGameBodyBuilder toBuilder() => UpdateGameBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateGameBody &&
        platforms == other.platforms &&
        name == other.name &&
        shortCode == other.shortCode &&
        hasRanks == other.hasRanks &&
        maxParty == other.maxParty &&
        isLaunch == other.isLaunch &&
        sort == other.sort;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, platforms.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, shortCode.hashCode);
    _$hash = $jc(_$hash, hasRanks.hashCode);
    _$hash = $jc(_$hash, maxParty.hashCode);
    _$hash = $jc(_$hash, isLaunch.hashCode);
    _$hash = $jc(_$hash, sort.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateGameBody')
          ..add('platforms', platforms)
          ..add('name', name)
          ..add('shortCode', shortCode)
          ..add('hasRanks', hasRanks)
          ..add('maxParty', maxParty)
          ..add('isLaunch', isLaunch)
          ..add('sort', sort))
        .toString();
  }
}

class UpdateGameBodyBuilder
    implements Builder<UpdateGameBody, UpdateGameBodyBuilder> {
  _$UpdateGameBody? _$v;

  ListBuilder<Platform>? _platforms;
  ListBuilder<Platform> get platforms =>
      _$this._platforms ??= ListBuilder<Platform>();
  set platforms(ListBuilder<Platform>? platforms) =>
      _$this._platforms = platforms;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _shortCode;
  String? get shortCode => _$this._shortCode;
  set shortCode(String? shortCode) => _$this._shortCode = shortCode;

  bool? _hasRanks;
  bool? get hasRanks => _$this._hasRanks;
  set hasRanks(bool? hasRanks) => _$this._hasRanks = hasRanks;

  num? _maxParty;
  num? get maxParty => _$this._maxParty;
  set maxParty(num? maxParty) => _$this._maxParty = maxParty;

  bool? _isLaunch;
  bool? get isLaunch => _$this._isLaunch;
  set isLaunch(bool? isLaunch) => _$this._isLaunch = isLaunch;

  num? _sort;
  num? get sort => _$this._sort;
  set sort(num? sort) => _$this._sort = sort;

  UpdateGameBodyBuilder() {
    UpdateGameBody._defaults(this);
  }

  UpdateGameBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platforms = $v.platforms?.toBuilder();
      _name = $v.name;
      _shortCode = $v.shortCode;
      _hasRanks = $v.hasRanks;
      _maxParty = $v.maxParty;
      _isLaunch = $v.isLaunch;
      _sort = $v.sort;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateGameBody other) {
    _$v = other as _$UpdateGameBody;
  }

  @override
  void update(void Function(UpdateGameBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateGameBody build() => _build();

  _$UpdateGameBody _build() {
    _$UpdateGameBody _$result;
    try {
      _$result = _$v ??
          _$UpdateGameBody._(
            platforms: _platforms?.build(),
            name: name,
            shortCode: shortCode,
            hasRanks: hasRanks,
            maxParty: maxParty,
            isLaunch: isLaunch,
            sort: sort,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'platforms';
        _platforms?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateGameBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
