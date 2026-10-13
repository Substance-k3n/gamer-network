// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BlockBody extends BlockBody {
  @override
  final String userId;

  factory _$BlockBody([void Function(BlockBodyBuilder)? updates]) =>
      (BlockBodyBuilder()..update(updates))._build();

  _$BlockBody._({required this.userId}) : super._();
  @override
  BlockBody rebuild(void Function(BlockBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BlockBodyBuilder toBuilder() => BlockBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlockBody && userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BlockBody')..add('userId', userId))
        .toString();
  }
}

class BlockBodyBuilder implements Builder<BlockBody, BlockBodyBuilder> {
  _$BlockBody? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  BlockBodyBuilder() {
    BlockBody._defaults(this);
  }

  BlockBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlockBody other) {
    _$v = other as _$BlockBody;
  }

  @override
  void update(void Function(BlockBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlockBody build() => _build();

  _$BlockBody _build() {
    final _$result = _$v ??
        _$BlockBody._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'BlockBody', 'userId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
