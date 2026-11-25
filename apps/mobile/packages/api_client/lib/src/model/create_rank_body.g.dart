// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_rank_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateRankBody extends CreateRankBody {
  @override
  final String name;
  @override
  final num? tier;

  factory _$CreateRankBody([void Function(CreateRankBodyBuilder)? updates]) =>
      (CreateRankBodyBuilder()..update(updates))._build();

  _$CreateRankBody._({required this.name, this.tier}) : super._();
  @override
  CreateRankBody rebuild(void Function(CreateRankBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateRankBodyBuilder toBuilder() => CreateRankBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateRankBody && name == other.name && tier == other.tier;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateRankBody')
          ..add('name', name)
          ..add('tier', tier))
        .toString();
  }
}

class CreateRankBodyBuilder
    implements Builder<CreateRankBody, CreateRankBodyBuilder> {
  _$CreateRankBody? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  num? _tier;
  num? get tier => _$this._tier;
  set tier(num? tier) => _$this._tier = tier;

  CreateRankBodyBuilder() {
    CreateRankBody._defaults(this);
  }

  CreateRankBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _tier = $v.tier;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateRankBody other) {
    _$v = other as _$CreateRankBody;
  }

  @override
  void update(void Function(CreateRankBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateRankBody build() => _build();

  _$CreateRankBody _build() {
    final _$result = _$v ??
        _$CreateRankBody._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CreateRankBody', 'name'),
          tier: tier,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
