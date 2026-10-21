// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gg_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GgDto extends GgDto {
  @override
  final num ggCount;
  @override
  final bool myGG;

  factory _$GgDto([void Function(GgDtoBuilder)? updates]) =>
      (GgDtoBuilder()..update(updates))._build();

  _$GgDto._({required this.ggCount, required this.myGG}) : super._();
  @override
  GgDto rebuild(void Function(GgDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GgDtoBuilder toBuilder() => GgDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GgDto && ggCount == other.ggCount && myGG == other.myGG;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ggCount.hashCode);
    _$hash = $jc(_$hash, myGG.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GgDto')
          ..add('ggCount', ggCount)
          ..add('myGG', myGG))
        .toString();
  }
}

class GgDtoBuilder implements Builder<GgDto, GgDtoBuilder> {
  _$GgDto? _$v;

  num? _ggCount;
  num? get ggCount => _$this._ggCount;
  set ggCount(num? ggCount) => _$this._ggCount = ggCount;

  bool? _myGG;
  bool? get myGG => _$this._myGG;
  set myGG(bool? myGG) => _$this._myGG = myGG;

  GgDtoBuilder() {
    GgDto._defaults(this);
  }

  GgDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ggCount = $v.ggCount;
      _myGG = $v.myGG;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GgDto other) {
    _$v = other as _$GgDto;
  }

  @override
  void update(void Function(GgDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GgDto build() => _build();

  _$GgDto _build() {
    final _$result = _$v ??
        _$GgDto._(
          ggCount: BuiltValueNullFieldError.checkNotNull(
              ggCount, r'GgDto', 'ggCount'),
          myGG: BuiltValueNullFieldError.checkNotNull(myGG, r'GgDto', 'myGG'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
