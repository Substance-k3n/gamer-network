// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VoteBody extends VoteBody {
  @override
  final num position;

  factory _$VoteBody([void Function(VoteBodyBuilder)? updates]) =>
      (VoteBodyBuilder()..update(updates))._build();

  _$VoteBody._({required this.position}) : super._();
  @override
  VoteBody rebuild(void Function(VoteBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VoteBodyBuilder toBuilder() => VoteBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VoteBody && position == other.position;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VoteBody')..add('position', position))
        .toString();
  }
}

class VoteBodyBuilder implements Builder<VoteBody, VoteBodyBuilder> {
  _$VoteBody? _$v;

  num? _position;
  num? get position => _$this._position;
  set position(num? position) => _$this._position = position;

  VoteBodyBuilder() {
    VoteBody._defaults(this);
  }

  VoteBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VoteBody other) {
    _$v = other as _$VoteBody;
  }

  @override
  void update(void Function(VoteBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VoteBody build() => _build();

  _$VoteBody _build() {
    final _$result = _$v ??
        _$VoteBody._(
          position: BuiltValueNullFieldError.checkNotNull(
              position, r'VoteBody', 'position'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
