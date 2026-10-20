// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PostDto extends PostDto {
  @override
  final PostType type;
  @override
  final PostKind kind;
  @override
  final PostAudience audience;
  @override
  final String id;
  @override
  final UserCardDto author;
  @override
  final GameRefDto? game;
  @override
  final String text;
  @override
  final BuiltList<MediaDto> media;
  @override
  final PollDto? poll;
  @override
  final RecruitDto? recruit;
  @override
  final CommentDto? topComment;
  @override
  final num ggCount;
  @override
  final num commentCount;
  @override
  final bool myGG;
  @override
  final bool saved;
  @override
  final bool mine;
  @override
  final String shareUrl;
  @override
  final DateTime createdAt;

  factory _$PostDto([void Function(PostDtoBuilder)? updates]) =>
      (PostDtoBuilder()..update(updates))._build();

  _$PostDto._(
      {required this.type,
      required this.kind,
      required this.audience,
      required this.id,
      required this.author,
      this.game,
      required this.text,
      required this.media,
      this.poll,
      this.recruit,
      this.topComment,
      required this.ggCount,
      required this.commentCount,
      required this.myGG,
      required this.saved,
      required this.mine,
      required this.shareUrl,
      required this.createdAt})
      : super._();
  @override
  PostDto rebuild(void Function(PostDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostDtoBuilder toBuilder() => PostDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostDto &&
        type == other.type &&
        kind == other.kind &&
        audience == other.audience &&
        id == other.id &&
        author == other.author &&
        game == other.game &&
        text == other.text &&
        media == other.media &&
        poll == other.poll &&
        recruit == other.recruit &&
        topComment == other.topComment &&
        ggCount == other.ggCount &&
        commentCount == other.commentCount &&
        myGG == other.myGG &&
        saved == other.saved &&
        mine == other.mine &&
        shareUrl == other.shareUrl &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jc(_$hash, poll.hashCode);
    _$hash = $jc(_$hash, recruit.hashCode);
    _$hash = $jc(_$hash, topComment.hashCode);
    _$hash = $jc(_$hash, ggCount.hashCode);
    _$hash = $jc(_$hash, commentCount.hashCode);
    _$hash = $jc(_$hash, myGG.hashCode);
    _$hash = $jc(_$hash, saved.hashCode);
    _$hash = $jc(_$hash, mine.hashCode);
    _$hash = $jc(_$hash, shareUrl.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PostDto')
          ..add('type', type)
          ..add('kind', kind)
          ..add('audience', audience)
          ..add('id', id)
          ..add('author', author)
          ..add('game', game)
          ..add('text', text)
          ..add('media', media)
          ..add('poll', poll)
          ..add('recruit', recruit)
          ..add('topComment', topComment)
          ..add('ggCount', ggCount)
          ..add('commentCount', commentCount)
          ..add('myGG', myGG)
          ..add('saved', saved)
          ..add('mine', mine)
          ..add('shareUrl', shareUrl)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PostDtoBuilder implements Builder<PostDto, PostDtoBuilder> {
  _$PostDto? _$v;

  PostType? _type;
  PostType? get type => _$this._type;
  set type(PostType? type) => _$this._type = type;

  PostKind? _kind;
  PostKind? get kind => _$this._kind;
  set kind(PostKind? kind) => _$this._kind = kind;

  PostAudience? _audience;
  PostAudience? get audience => _$this._audience;
  set audience(PostAudience? audience) => _$this._audience = audience;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  UserCardDtoBuilder? _author;
  UserCardDtoBuilder get author => _$this._author ??= UserCardDtoBuilder();
  set author(UserCardDtoBuilder? author) => _$this._author = author;

  GameRefDtoBuilder? _game;
  GameRefDtoBuilder get game => _$this._game ??= GameRefDtoBuilder();
  set game(GameRefDtoBuilder? game) => _$this._game = game;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  ListBuilder<MediaDto>? _media;
  ListBuilder<MediaDto> get media => _$this._media ??= ListBuilder<MediaDto>();
  set media(ListBuilder<MediaDto>? media) => _$this._media = media;

  PollDtoBuilder? _poll;
  PollDtoBuilder get poll => _$this._poll ??= PollDtoBuilder();
  set poll(PollDtoBuilder? poll) => _$this._poll = poll;

  RecruitDtoBuilder? _recruit;
  RecruitDtoBuilder get recruit => _$this._recruit ??= RecruitDtoBuilder();
  set recruit(RecruitDtoBuilder? recruit) => _$this._recruit = recruit;

  CommentDtoBuilder? _topComment;
  CommentDtoBuilder get topComment =>
      _$this._topComment ??= CommentDtoBuilder();
  set topComment(CommentDtoBuilder? topComment) =>
      _$this._topComment = topComment;

  num? _ggCount;
  num? get ggCount => _$this._ggCount;
  set ggCount(num? ggCount) => _$this._ggCount = ggCount;

  num? _commentCount;
  num? get commentCount => _$this._commentCount;
  set commentCount(num? commentCount) => _$this._commentCount = commentCount;

  bool? _myGG;
  bool? get myGG => _$this._myGG;
  set myGG(bool? myGG) => _$this._myGG = myGG;

  bool? _saved;
  bool? get saved => _$this._saved;
  set saved(bool? saved) => _$this._saved = saved;

  bool? _mine;
  bool? get mine => _$this._mine;
  set mine(bool? mine) => _$this._mine = mine;

  String? _shareUrl;
  String? get shareUrl => _$this._shareUrl;
  set shareUrl(String? shareUrl) => _$this._shareUrl = shareUrl;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PostDtoBuilder() {
    PostDto._defaults(this);
  }

  PostDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _kind = $v.kind;
      _audience = $v.audience;
      _id = $v.id;
      _author = $v.author.toBuilder();
      _game = $v.game?.toBuilder();
      _text = $v.text;
      _media = $v.media.toBuilder();
      _poll = $v.poll?.toBuilder();
      _recruit = $v.recruit?.toBuilder();
      _topComment = $v.topComment?.toBuilder();
      _ggCount = $v.ggCount;
      _commentCount = $v.commentCount;
      _myGG = $v.myGG;
      _saved = $v.saved;
      _mine = $v.mine;
      _shareUrl = $v.shareUrl;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PostDto other) {
    _$v = other as _$PostDto;
  }

  @override
  void update(void Function(PostDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PostDto build() => _build();

  _$PostDto _build() {
    _$PostDto _$result;
    try {
      _$result = _$v ??
          _$PostDto._(
            type:
                BuiltValueNullFieldError.checkNotNull(type, r'PostDto', 'type'),
            kind:
                BuiltValueNullFieldError.checkNotNull(kind, r'PostDto', 'kind'),
            audience: BuiltValueNullFieldError.checkNotNull(
                audience, r'PostDto', 'audience'),
            id: BuiltValueNullFieldError.checkNotNull(id, r'PostDto', 'id'),
            author: author.build(),
            game: _game?.build(),
            text:
                BuiltValueNullFieldError.checkNotNull(text, r'PostDto', 'text'),
            media: media.build(),
            poll: _poll?.build(),
            recruit: _recruit?.build(),
            topComment: _topComment?.build(),
            ggCount: BuiltValueNullFieldError.checkNotNull(
                ggCount, r'PostDto', 'ggCount'),
            commentCount: BuiltValueNullFieldError.checkNotNull(
                commentCount, r'PostDto', 'commentCount'),
            myGG:
                BuiltValueNullFieldError.checkNotNull(myGG, r'PostDto', 'myGG'),
            saved: BuiltValueNullFieldError.checkNotNull(
                saved, r'PostDto', 'saved'),
            mine:
                BuiltValueNullFieldError.checkNotNull(mine, r'PostDto', 'mine'),
            shareUrl: BuiltValueNullFieldError.checkNotNull(
                shareUrl, r'PostDto', 'shareUrl'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PostDto', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'author';
        author.build();
        _$failedField = 'game';
        _game?.build();

        _$failedField = 'media';
        media.build();
        _$failedField = 'poll';
        _poll?.build();
        _$failedField = 'recruit';
        _recruit?.build();
        _$failedField = 'topComment';
        _topComment?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PostDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
