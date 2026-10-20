// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommentDto extends CommentDto {
  @override
  final String id;
  @override
  final String postId;
  @override
  final String? parentId;
  @override
  final UserCardDto author;
  @override
  final String text;
  @override
  final num ggCount;
  @override
  final bool myGG;
  @override
  final bool mine;
  @override
  final num replies;
  @override
  final DateTime createdAt;

  factory _$CommentDto([void Function(CommentDtoBuilder)? updates]) =>
      (CommentDtoBuilder()..update(updates))._build();

  _$CommentDto._(
      {required this.id,
      required this.postId,
      this.parentId,
      required this.author,
      required this.text,
      required this.ggCount,
      required this.myGG,
      required this.mine,
      required this.replies,
      required this.createdAt})
      : super._();
  @override
  CommentDto rebuild(void Function(CommentDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommentDtoBuilder toBuilder() => CommentDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommentDto &&
        id == other.id &&
        postId == other.postId &&
        parentId == other.parentId &&
        author == other.author &&
        text == other.text &&
        ggCount == other.ggCount &&
        myGG == other.myGG &&
        mine == other.mine &&
        replies == other.replies &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, postId.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, ggCount.hashCode);
    _$hash = $jc(_$hash, myGG.hashCode);
    _$hash = $jc(_$hash, mine.hashCode);
    _$hash = $jc(_$hash, replies.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommentDto')
          ..add('id', id)
          ..add('postId', postId)
          ..add('parentId', parentId)
          ..add('author', author)
          ..add('text', text)
          ..add('ggCount', ggCount)
          ..add('myGG', myGG)
          ..add('mine', mine)
          ..add('replies', replies)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class CommentDtoBuilder implements Builder<CommentDto, CommentDtoBuilder> {
  _$CommentDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _postId;
  String? get postId => _$this._postId;
  set postId(String? postId) => _$this._postId = postId;

  String? _parentId;
  String? get parentId => _$this._parentId;
  set parentId(String? parentId) => _$this._parentId = parentId;

  UserCardDtoBuilder? _author;
  UserCardDtoBuilder get author => _$this._author ??= UserCardDtoBuilder();
  set author(UserCardDtoBuilder? author) => _$this._author = author;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  num? _ggCount;
  num? get ggCount => _$this._ggCount;
  set ggCount(num? ggCount) => _$this._ggCount = ggCount;

  bool? _myGG;
  bool? get myGG => _$this._myGG;
  set myGG(bool? myGG) => _$this._myGG = myGG;

  bool? _mine;
  bool? get mine => _$this._mine;
  set mine(bool? mine) => _$this._mine = mine;

  num? _replies;
  num? get replies => _$this._replies;
  set replies(num? replies) => _$this._replies = replies;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  CommentDtoBuilder() {
    CommentDto._defaults(this);
  }

  CommentDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _postId = $v.postId;
      _parentId = $v.parentId;
      _author = $v.author.toBuilder();
      _text = $v.text;
      _ggCount = $v.ggCount;
      _myGG = $v.myGG;
      _mine = $v.mine;
      _replies = $v.replies;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommentDto other) {
    _$v = other as _$CommentDto;
  }

  @override
  void update(void Function(CommentDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommentDto build() => _build();

  _$CommentDto _build() {
    _$CommentDto _$result;
    try {
      _$result = _$v ??
          _$CommentDto._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'CommentDto', 'id'),
            postId: BuiltValueNullFieldError.checkNotNull(
                postId, r'CommentDto', 'postId'),
            parentId: parentId,
            author: author.build(),
            text: BuiltValueNullFieldError.checkNotNull(
                text, r'CommentDto', 'text'),
            ggCount: BuiltValueNullFieldError.checkNotNull(
                ggCount, r'CommentDto', 'ggCount'),
            myGG: BuiltValueNullFieldError.checkNotNull(
                myGG, r'CommentDto', 'myGG'),
            mine: BuiltValueNullFieldError.checkNotNull(
                mine, r'CommentDto', 'mine'),
            replies: BuiltValueNullFieldError.checkNotNull(
                replies, r'CommentDto', 'replies'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CommentDto', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'author';
        author.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CommentDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
