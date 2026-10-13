// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_ref_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RankRefDto extends RankRefDto {
  @override
  final String id;
  @override
  final String name;
  @override
  final num tier;

  factory _$RankRefDto([void Function(RankRefDtoBuilder)? updates]) =>
      (RankRefDtoBuilder()..update(updates))._build();

  _$RankRefDto._({required this.id, required this.name, required this.tier})
      : super._();
  @override
  RankRefDto rebuild(void Function(RankRefDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RankRefDtoBuilder toBuilder() => RankRefDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RankRefDto &&
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
    return (newBuiltValueToStringHelper(r'RankRefDto')
          ..add('id', id)
          ..add('name', name)
          ..add('tier', tier))
        .toString();
  }
}

class RankRefDtoBuilder implements Builder<RankRefDto, RankRefDtoBuilder> {
  _$RankRefDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  num? _tier;
  num? get tier => _$this._tier;
  set tier(num? tier) => _$this._tier = tier;

  RankRefDtoBuilder() {
    RankRefDto._defaults(this);
  }

  RankRefDtoBuilder get _$this {
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
  void replace(RankRefDto other) {
    _$v = other as _$RankRefDto;
  }

  @override
  void update(void Function(RankRefDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RankRefDto build() => _build();

  _$RankRefDto _build() {
    final _$result = _$v ??
        _$RankRefDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'RankRefDto', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'RankRefDto', 'name'),
          tier: BuiltValueNullFieldError.checkNotNull(
              tier, r'RankRefDto', 'tier'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
