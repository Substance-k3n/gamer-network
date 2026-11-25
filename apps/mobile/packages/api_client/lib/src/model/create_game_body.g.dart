// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_game_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateGameBody extends CreateGameBody {
  @override
  final BuiltList<Platform> platforms;
  @override
  final String id;
  @override
  final String name;
  @override
  final String shortCode;
  @override
  final bool hasRanks;
  @override
  final num maxParty;
  @override
  final bool isLaunch;
  @override
  final num? sort;

  factory _$CreateGameBody([void Function(CreateGameBodyBuilder)? updates]) =>
      (CreateGameBodyBuilder()..update(updates))._build();

  _$CreateGameBody._(
      {required this.platforms,
      required this.id,
      required this.name,
      required this.shortCode,
      required this.hasRanks,
      required this.maxParty,
      required this.isLaunch,
      this.sort})
      : super._();
  @override
  CreateGameBody rebuild(void Function(CreateGameBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateGameBodyBuilder toBuilder() => CreateGameBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateGameBody &&
        platforms == other.platforms &&
        id == other.id &&
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
    _$hash = $jc(_$hash, id.hashCode);
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
    return (newBuiltValueToStringHelper(r'CreateGameBody')
          ..add('platforms', platforms)
          ..add('id', id)
          ..add('name', name)
          ..add('shortCode', shortCode)
          ..add('hasRanks', hasRanks)
          ..add('maxParty', maxParty)
          ..add('isLaunch', isLaunch)
          ..add('sort', sort))
        .toString();
  }
}

class CreateGameBodyBuilder
    implements Builder<CreateGameBody, CreateGameBodyBuilder> {
  _$CreateGameBody? _$v;

  ListBuilder<Platform>? _platforms;
  ListBuilder<Platform> get platforms =>
      _$this._platforms ??= ListBuilder<Platform>();
  set platforms(ListBuilder<Platform>? platforms) =>
      _$this._platforms = platforms;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  CreateGameBodyBuilder() {
    CreateGameBody._defaults(this);
  }

  CreateGameBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platforms = $v.platforms.toBuilder();
      _id = $v.id;
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
  void replace(CreateGameBody other) {
    _$v = other as _$CreateGameBody;
  }

  @override
  void update(void Function(CreateGameBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateGameBody build() => _build();

  _$CreateGameBody _build() {
    _$CreateGameBody _$result;
    try {
      _$result = _$v ??
          _$CreateGameBody._(
            platforms: platforms.build(),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CreateGameBody', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateGameBody', 'name'),
            shortCode: BuiltValueNullFieldError.checkNotNull(
                shortCode, r'CreateGameBody', 'shortCode'),
            hasRanks: BuiltValueNullFieldError.checkNotNull(
                hasRanks, r'CreateGameBody', 'hasRanks'),
            maxParty: BuiltValueNullFieldError.checkNotNull(
                maxParty, r'CreateGameBody', 'maxParty'),
            isLaunch: BuiltValueNullFieldError.checkNotNull(
                isLaunch, r'CreateGameBody', 'isLaunch'),
            sort: sort,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'platforms';
        platforms.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateGameBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
