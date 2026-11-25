// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_rank_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateRankBody extends UpdateRankBody {
  @override
  final String? name;
  @override
  final num? tier;

  factory _$UpdateRankBody([void Function(UpdateRankBodyBuilder)? updates]) =>
      (UpdateRankBodyBuilder()..update(updates))._build();

  _$UpdateRankBody._({this.name, this.tier}) : super._();
  @override
  UpdateRankBody rebuild(void Function(UpdateRankBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateRankBodyBuilder toBuilder() => UpdateRankBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateRankBody && name == other.name && tier == other.tier;
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
    return (newBuiltValueToStringHelper(r'UpdateRankBody')
          ..add('name', name)
          ..add('tier', tier))
        .toString();
  }
}

class UpdateRankBodyBuilder
    implements Builder<UpdateRankBody, UpdateRankBodyBuilder> {
  _$UpdateRankBody? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  num? _tier;
  num? get tier => _$this._tier;
  set tier(num? tier) => _$this._tier = tier;

  UpdateRankBodyBuilder() {
    UpdateRankBody._defaults(this);
  }

  UpdateRankBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _tier = $v.tier;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateRankBody other) {
    _$v = other as _$UpdateRankBody;
  }

  @override
  void update(void Function(UpdateRankBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateRankBody build() => _build();

  _$UpdateRankBody _build() {
    final _$result = _$v ??
        _$UpdateRankBody._(
          name: name,
          tier: tier,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
