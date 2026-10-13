// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RankDto extends RankDto {
  @override
  final String id;
  @override
  final String name;
  @override
  final num tier;

  factory _$RankDto([void Function(RankDtoBuilder)? updates]) =>
      (RankDtoBuilder()..update(updates))._build();

  _$RankDto._({required this.id, required this.name, required this.tier})
      : super._();
  @override
  RankDto rebuild(void Function(RankDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RankDtoBuilder toBuilder() => RankDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RankDto &&
        id == other.id &&
        name == other.name &&
        tier == other.tier;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RankDto')
          ..add('id', id)
          ..add('name', name)
          ..add('tier', tier))
        .toString();
  }
}

class RankDtoBuilder implements Builder<RankDto, RankDtoBuilder> {
  _$RankDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  num? _tier;
  num? get tier => _$this._tier;
  set tier(num? tier) => _$this._tier = tier;

  RankDtoBuilder() {
    RankDto._defaults(this);
  }

  RankDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _tier = $v.tier;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RankDto other) {
    _$v = other as _$RankDto;
  }

  @override
  void update(void Function(RankDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RankDto build() => _build();

  _$RankDto _build() {
    final _$result = _$v ??
        _$RankDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'RankDto', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'RankDto', 'name'),
          tier: BuiltValueNullFieldError.checkNotNull(tier, r'RankDto', 'tier'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
