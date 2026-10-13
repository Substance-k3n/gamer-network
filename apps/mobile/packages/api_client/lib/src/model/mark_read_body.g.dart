// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_read_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MarkReadBody extends MarkReadBody {
  @override
  final BuiltList<String>? ids;
  @override
  final bool? all;

  factory _$MarkReadBody([void Function(MarkReadBodyBuilder)? updates]) =>
      (MarkReadBodyBuilder()..update(updates))._build();

  _$MarkReadBody._({this.ids, this.all}) : super._();
  @override
  MarkReadBody rebuild(void Function(MarkReadBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MarkReadBodyBuilder toBuilder() => MarkReadBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MarkReadBody && ids == other.ids && all == other.all;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ids.hashCode);
    _$hash = $jc(_$hash, all.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MarkReadBody')
          ..add('ids', ids)
          ..add('all', all))
        .toString();
  }
}

class MarkReadBodyBuilder
    implements Builder<MarkReadBody, MarkReadBodyBuilder> {
  _$MarkReadBody? _$v;

  ListBuilder<String>? _ids;
  ListBuilder<String> get ids => _$this._ids ??= ListBuilder<String>();
  set ids(ListBuilder<String>? ids) => _$this._ids = ids;

  bool? _all;
  bool? get all => _$this._all;
  set all(bool? all) => _$this._all = all;

  MarkReadBodyBuilder() {
    MarkReadBody._defaults(this);
  }

  MarkReadBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ids = $v.ids?.toBuilder();
      _all = $v.all;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MarkReadBody other) {
    _$v = other as _$MarkReadBody;
  }

  @override
  void update(void Function(MarkReadBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MarkReadBody build() => _build();

  _$MarkReadBody _build() {
    _$MarkReadBody _$result;
    try {
      _$result = _$v ??
          _$MarkReadBody._(
            ids: _ids?.build(),
            all: all,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ids';
        _ids?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MarkReadBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
