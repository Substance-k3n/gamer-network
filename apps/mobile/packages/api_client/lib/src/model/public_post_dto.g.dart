// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_post_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicPostDto extends PublicPostDto {
  @override
  final PostType type;
  @override
  final String id;
  @override
  final String text;
  @override
  final PublicPostAuthorDto author;
  @override
  final GameRefDto? game;
  @override
  final BuiltList<MediaDto> media;
  @override
  final DateTime createdAt;

  factory _$PublicPostDto([void Function(PublicPostDtoBuilder)? updates]) =>
      (PublicPostDtoBuilder()..update(updates))._build();

  _$PublicPostDto._(
      {required this.type,
      required this.id,
      required this.text,
      required this.author,
      this.game,
      required this.media,
      required this.createdAt})
      : super._();
  @override
  PublicPostDto rebuild(void Function(PublicPostDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicPostDtoBuilder toBuilder() => PublicPostDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicPostDto &&
        type == other.type &&
        id == other.id &&
        text == other.text &&
        author == other.author &&
        game == other.game &&
        media == other.media &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, game.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicPostDto')
          ..add('type', type)
          ..add('id', id)
          ..add('text', text)
          ..add('author', author)
          ..add('game', game)
          ..add('media', media)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PublicPostDtoBuilder
    implements Builder<PublicPostDto, PublicPostDtoBuilder> {
  _$PublicPostDto? _$v;

  PostType? _type;
  PostType? get type => _$this._type;
  set type(PostType? type) => _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  PublicPostAuthorDtoBuilder? _author;
  PublicPostAuthorDtoBuilder get author =>
      _$this._author ??= PublicPostAuthorDtoBuilder();
  set author(PublicPostAuthorDtoBuilder? author) => _$this._author = author;

  GameRefDtoBuilder? _game;
  GameRefDtoBuilder get game => _$this._game ??= GameRefDtoBuilder();
  set game(GameRefDtoBuilder? game) => _$this._game = game;

  ListBuilder<MediaDto>? _media;
  ListBuilder<MediaDto> get media => _$this._media ??= ListBuilder<MediaDto>();
  set media(ListBuilder<MediaDto>? media) => _$this._media = media;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PublicPostDtoBuilder() {
    PublicPostDto._defaults(this);
  }

  PublicPostDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _text = $v.text;
      _author = $v.author.toBuilder();
      _game = $v.game?.toBuilder();
      _media = $v.media.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicPostDto other) {
    _$v = other as _$PublicPostDto;
  }

  @override
  void update(void Function(PublicPostDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicPostDto build() => _build();

  _$PublicPostDto _build() {
    _$PublicPostDto _$result;
    try {
      _$result = _$v ??
          _$PublicPostDto._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'PublicPostDto', 'type'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PublicPostDto', 'id'),
            text: BuiltValueNullFieldError.checkNotNull(
                text, r'PublicPostDto', 'text'),
            author: author.build(),
            game: _game?.build(),
            media: media.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'PublicPostDto', 'createdAt'),
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
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicPostDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
