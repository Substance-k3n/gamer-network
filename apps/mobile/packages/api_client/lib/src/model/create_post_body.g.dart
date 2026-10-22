// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreatePostBody extends CreatePostBody {
  @override
  final PostType type;
  @override
  final PostAudience? audience;
  @override
  final String text;
  @override
  final String? gameId;
  @override
  final String? groupId;
  @override
  final BuiltSet<String>? media;
  @override
  final PollBody? poll;
  @override
  final RecruitBody? recruit;

  factory _$CreatePostBody([void Function(CreatePostBodyBuilder)? updates]) =>
      (CreatePostBodyBuilder()..update(updates))._build();

  _$CreatePostBody._(
      {required this.type,
      this.audience,
      required this.text,
      this.gameId,
      this.groupId,
      this.media,
      this.poll,
      this.recruit})
      : super._();
  @override
  CreatePostBody rebuild(void Function(CreatePostBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatePostBodyBuilder toBuilder() => CreatePostBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatePostBody &&
        type == other.type &&
        audience == other.audience &&
        text == other.text &&
        gameId == other.gameId &&
        groupId == other.groupId &&
        media == other.media &&
        poll == other.poll &&
        recruit == other.recruit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, gameId.hashCode);
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, media.hashCode);
    _$hash = $jc(_$hash, poll.hashCode);
    _$hash = $jc(_$hash, recruit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatePostBody')
          ..add('type', type)
          ..add('audience', audience)
          ..add('text', text)
          ..add('gameId', gameId)
          ..add('groupId', groupId)
          ..add('media', media)
          ..add('poll', poll)
          ..add('recruit', recruit))
        .toString();
  }
}

class CreatePostBodyBuilder
    implements Builder<CreatePostBody, CreatePostBodyBuilder> {
  _$CreatePostBody? _$v;

  PostType? _type;
  PostType? get type => _$this._type;
  set type(PostType? type) => _$this._type = type;

  PostAudience? _audience;
  PostAudience? get audience => _$this._audience;
  set audience(PostAudience? audience) => _$this._audience = audience;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _gameId;
  String? get gameId => _$this._gameId;
  set gameId(String? gameId) => _$this._gameId = gameId;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  SetBuilder<String>? _media;
  SetBuilder<String> get media => _$this._media ??= SetBuilder<String>();
  set media(SetBuilder<String>? media) => _$this._media = media;

  PollBodyBuilder? _poll;
  PollBodyBuilder get poll => _$this._poll ??= PollBodyBuilder();
  set poll(PollBodyBuilder? poll) => _$this._poll = poll;

  RecruitBodyBuilder? _recruit;
  RecruitBodyBuilder get recruit => _$this._recruit ??= RecruitBodyBuilder();
  set recruit(RecruitBodyBuilder? recruit) => _$this._recruit = recruit;

  CreatePostBodyBuilder() {
    CreatePostBody._defaults(this);
  }

  CreatePostBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _audience = $v.audience;
      _text = $v.text;
      _gameId = $v.gameId;
      _groupId = $v.groupId;
      _media = $v.media?.toBuilder();
      _poll = $v.poll?.toBuilder();
      _recruit = $v.recruit?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatePostBody other) {
    _$v = other as _$CreatePostBody;
  }

  @override
  void update(void Function(CreatePostBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatePostBody build() => _build();

  _$CreatePostBody _build() {
    _$CreatePostBody _$result;
    try {
      _$result = _$v ??
          _$CreatePostBody._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CreatePostBody', 'type'),
            audience: audience,
            text: BuiltValueNullFieldError.checkNotNull(
                text, r'CreatePostBody', 'text'),
            gameId: gameId,
            groupId: groupId,
            media: _media?.build(),
            poll: _poll?.build(),
            recruit: _recruit?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'media';
        _media?.build();
        _$failedField = 'poll';
        _poll?.build();
        _$failedField = 'recruit';
        _recruit?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreatePostBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
