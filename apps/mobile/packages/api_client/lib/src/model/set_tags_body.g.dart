// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_tags_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetTagsBody extends SetTagsBody {
  @override
  final BuiltSet<PlayTag> tags;

  factory _$SetTagsBody([void Function(SetTagsBodyBuilder)? updates]) =>
      (SetTagsBodyBuilder()..update(updates))._build();

  _$SetTagsBody._({required this.tags}) : super._();
  @override
  SetTagsBody rebuild(void Function(SetTagsBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetTagsBodyBuilder toBuilder() => SetTagsBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetTagsBody && tags == other.tags;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetTagsBody')..add('tags', tags))
        .toString();
  }
}

class SetTagsBodyBuilder implements Builder<SetTagsBody, SetTagsBodyBuilder> {
  _$SetTagsBody? _$v;

  SetBuilder<PlayTag>? _tags;
  SetBuilder<PlayTag> get tags => _$this._tags ??= SetBuilder<PlayTag>();
  set tags(SetBuilder<PlayTag>? tags) => _$this._tags = tags;

  SetTagsBodyBuilder() {
    SetTagsBody._defaults(this);
  }

  SetTagsBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tags = $v.tags.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetTagsBody other) {
    _$v = other as _$SetTagsBody;
  }

  @override
  void update(void Function(SetTagsBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetTagsBody build() => _build();

  _$SetTagsBody _build() {
    _$SetTagsBody _$result;
    try {
      _$result = _$v ??
          _$SetTagsBody._(
            tags: tags.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SetTagsBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
