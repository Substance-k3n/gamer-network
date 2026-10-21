// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_comment_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateCommentBody extends CreateCommentBody {
  @override
  final String text;
  @override
  final String? parentId;

  factory _$CreateCommentBody(
          [void Function(CreateCommentBodyBuilder)? updates]) =>
      (CreateCommentBodyBuilder()..update(updates))._build();

  _$CreateCommentBody._({required this.text, this.parentId}) : super._();
  @override
  CreateCommentBody rebuild(void Function(CreateCommentBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateCommentBodyBuilder toBuilder() =>
      CreateCommentBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateCommentBody &&
        text == other.text &&
        parentId == other.parentId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateCommentBody')
          ..add('text', text)
          ..add('parentId', parentId))
        .toString();
  }
}

class CreateCommentBodyBuilder
    implements Builder<CreateCommentBody, CreateCommentBodyBuilder> {
  _$CreateCommentBody? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _parentId;
  String? get parentId => _$this._parentId;
  set parentId(String? parentId) => _$this._parentId = parentId;

  CreateCommentBodyBuilder() {
    CreateCommentBody._defaults(this);
  }

  CreateCommentBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _parentId = $v.parentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateCommentBody other) {
    _$v = other as _$CreateCommentBody;
  }

  @override
  void update(void Function(CreateCommentBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateCommentBody build() => _build();

  _$CreateCommentBody _build() {
    final _$result = _$v ??
        _$CreateCommentBody._(
          text: BuiltValueNullFieldError.checkNotNull(
              text, r'CreateCommentBody', 'text'),
          parentId: parentId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
